function [corners,gates_candidate_corners, color_fitnesses] = run_detection_corner_refine_img(dir_name, frame_nr, graphics, ROTATE_90, rotation, extension)
% function [corners,gates_candidate_corners, color_fitnesses] = run_detection_corner_refine_img(dir_name, frame_nr, graphics, ROTATE_90, rotation, extension)
%

% whether to first approximate the detection as a rectangle:
USE_INITIAL_RECTANGLE_BOXES = true;

color_fitnesses = [];
refinement_ratio = 0.3;

if(~exist('graphics', 'var') || isempty(graphics))
    graphics = true;
end
if(~exist('extension', 'var') || isempty(extension))
    extension = 'jpg';
end

n_coordinates = 8;
n_detection = 1;
size_gate_vector = n_detection + n_coordinates;

% If true, we compare and select gates based on the initial square
% detections:
EVALUATE_INITIAL_GATES = true;
ALLOW_MULTIPLE_GATES = true;

% read image
RGB = imread([dir_name '/' 'img_' sprintf('%05d',frame_nr) '.' extension]);
RGB = double(RGB) ./ 255;
if(ROTATE_90)
    RGB = imrotate(RGB, 90);
end
if(exist('rotation', 'var') && ~isempty(rotation))
   RGB = imrotate(RGB, rotation); 
end

filter_YUV = true;

if(filter_YUV)
    YCbCr = rgb2ycbcr(RGB);
    Response = YCbCr(:,:,2) < 0.5 & YCbCr(:,:,3) > 0.5 & YCbCr(:,:,1) > 0.2;
else
    HSV = rgb2hsv(RGB);
    % more difficult:
    % Response = (HSV(:,:,1) < 0.15 | HSV(:,:,1) > 0.9) & HSV(:,:,2) > 0.5 & HSV(:,:,3) > 0.3;
    % easier (e.g., basement):
    Response = (HSV(:,:,1) < 0.2 | HSV(:,:,1) > 0.85) & HSV(:,:,2) > 0.2 & HSV(:,:,3) > 0.2;
    % corridor:
    % Response = (HSV(:,:,1) > 0.03 & HSV(:,:,1) < 0.16) & HSV(:,:,2) > 0.2 & HSV(:,:,3) > 0.1;
end
% color filter the image:
% [Response,~] = createMask_basement(RGB);

if(graphics)
    figure()
    imshow(RGB);
    figure()
    imagesc(Response);
end

% perform subsampling to find all candidates:
SQUARE = 1;
POLYGON = 3;
shape = SQUARE;

% **********
% SNAKE GATE
% **********
[x,y,s,n_gates, initial_boxes] = sub_sampling_snake(Response, [], [], true);

if n_gates < 1
    corners = zeros(1,size_gate_vector);
    gates_candidate_corners = [];
    return;
end
fprintf('%d initial gates found\n', n_gates);

if(~EVALUATE_INITIAL_GATES)
    % refine corners of all gates found
    gates_candidate_corners = zeros(n_gates, n_coordinates);
    for i = 1:n_gates
        
        [Q1, Q2, Q3, Q4] = get_corners_from_initial_detection(x(i), y(i), s(i));
        
        Q_r1 = refine_corner(Q1,s(i),Response,refinement_ratio,graphics);
        Q_r2 = refine_corner(Q2,s(i),Response,refinement_ratio,graphics);
        Q_r3 = refine_corner(Q3,s(i),Response,refinement_ratio,graphics);
        Q_r4 = refine_corner(Q4,s(i),Response,refinement_ratio,graphics);
        
        gates_candidate_corners(i,1) = Q_r1(1);
        gates_candidate_corners(i,2) = Q_r2(1);
        gates_candidate_corners(i,3) = Q_r3(1);
        gates_candidate_corners(i,4) = Q_r4(1);
        gates_candidate_corners(i,5) = Q_r1(2);
        gates_candidate_corners(i,6) = Q_r2(2);
        gates_candidate_corners(i,7) = Q_r3(2);
        gates_candidate_corners(i,8) = Q_r4(2);
    end
else
    
    % check fitness of all gates and select the best one:
    STICK = false;
    cf = zeros(1,n_gates);
    for g = 1:n_gates
        if(USE_INITIAL_RECTANGLE_BOXES)
            cf(g) = get_color_fitness([x(g), y(g), s(g)], Response, STICK, shape);
        else
            cf(g) = get_color_fitness(initial_boxes(g,:), Response, STICK, POLYGON);
        end
    end
    
    if(ALLOW_MULTIPLE_GATES)
        % add the gates to a final list:
        [Q1, Q2, Q3, Q4] = get_corners_from_initial_detection(x(1), y(1), s(1))
        box1 = get_box_from_corners(Q1, Q2, Q3, Q4);
        rectangle_boxes = [box1];
        if(USE_INITIAL_RECTANGLE_BOXES)
            final_boxes = rectangle_boxes;
        else
            final_boxes = [initial_boxes(1,:)];
        end
        indices = [1];
        iou_threshold_same = 0.7;
        for g = 2:n_gates
            [Q1, Q2, Q3, Q4] = get_corners_from_initial_detection(x(g), y(g), s(g));
            box_gate = get_box_from_corners(Q1, Q2, Q3, Q4);
            % go over the existing gates to see whether to add this gate:
            new_gate = true;
            for i = 1:size(rectangle_boxes,1)
                iou = intersection_over_union(box_gate, rectangle_boxes(i,:));
                if(iou > iou_threshold_same)
                    new_gate = false;
                    if(cf(g) > cf(indices(i)))
                        % gate g is better than the current one in the list:
                        rectangle_boxes(i, :) = box_gate;
                        if(USE_INITIAL_RECTANGLE_BOXES)
                            final_boxes(i,:) = box_gate;
                        else
                            final_boxes(i,:) = initial_boxes(g,:);
                        end
                        indices(i) = g;
                    end
                end
            end
            % if a new gate, add it:
            if(new_gate)
                rectangle_boxes = [rectangle_boxes; box_gate];
                if(USE_INITIAL_RECTANGLE_BOXES)
                    final_boxes = [final_boxes; box_gate];
                else
                    final_boxes = [final_boxes; initial_boxes(g,:)]; 
                end
                indices(size(final_boxes,1)) = g;
            end
        end
        
        % plot all remaining gate detections:
        plot_gates_candidates(final_boxes,'green',2);
        
        % TODO: return multiple gates. This has to be afforded for in
        % snake_gate_detection.m
        n_gates = size(final_boxes, 1);
        gates_candidate_corners = zeros(n_gates, n_coordinates);
        color_fitnesses = zeros(n_gates, 1);
        for i = 1:n_gates
            
            if(USE_INITIAL_RECTANGLE_BOXES)
                [Q1, Q2, Q3, Q4] = get_corners_from_initial_detection(x(indices(i)), y(indices(i)), s(indices(i)));
            else
                [Q1, Q2, Q3, Q4] = get_corners_from_box(final_boxes(i,:));
            end
            
            Q_r1 = refine_corner(Q1,s(indices(i)),Response,refinement_ratio,graphics);
            Q_r2 = refine_corner(Q2,s(indices(i)),Response,refinement_ratio,graphics);
            Q_r3 = refine_corner(Q3,s(indices(i)),Response,refinement_ratio,graphics);
            Q_r4 = refine_corner(Q4,s(indices(i)),Response,refinement_ratio,graphics);
            
            gates_candidate_corners(i,1) = Q_r1(1);
            gates_candidate_corners(i,2) = Q_r2(1);
            gates_candidate_corners(i,3) = Q_r3(1);
            gates_candidate_corners(i,4) = Q_r4(1);
            gates_candidate_corners(i,5) = Q_r1(2);
            gates_candidate_corners(i,6) = Q_r2(2);
            gates_candidate_corners(i,7) = Q_r3(2);
            gates_candidate_corners(i,8) = Q_r4(2);
            
            color_fitnesses(i) = get_color_fitness(gates_candidate_corners(i, :), Response, STICK, POLYGON);
        end
        
        % single best gate:
        if(n_gates >= 1)
            [v,i] = max(color_fitnesses);
        end
        corners = [1 gates_candidate_corners(i,:)];
    else
        if(n_gates >= 1)
            [v,i] = max(cf);
            x = x(i); y = y(i); s = s(i);
            n_gates = length(x);
        end
        
        Q1 = [x-s; y-s];
        Q2 = [x+s; y-s];
        Q3 = [x+s; y+s];
        Q4 = [x-s; y+s];
        
        %sub corners
        Q_r1 = refine_corner(Q1,s,Response,refinement_ratio,graphics);
        Q_r2 = refine_corner(Q2,s,Response,refinement_ratio,graphics);
        Q_r3 = refine_corner(Q3,s,Response,refinement_ratio,graphics);
        Q_r4 = refine_corner(Q4,s,Response,refinement_ratio,graphics);
        corners = [1 Q_r1(1) Q_r2(1) Q_r3(1) Q_r4(1) Q_r1(2) Q_r2(2) Q_r3(2) Q_r4(2)];
    end
end
end

