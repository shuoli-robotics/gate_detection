function [corners,gates_candidate_corners] = run_detection_corner_refine_img(dir_name, frame_nr, graphics)
% function [corners,gates_candidate_corners] = run_detection_corner_refine_img(dir_name, frame_nr, graphics)
%

if(~exist('graphics', 'var') || isempty(graphics))
    graphics = true;
end

n_coordinates = 8;
n_detection = 1;
size_gate_vector = n_detection + n_coordinates;

% If true, we compare and select gates based on the initial square
% detections:
EVALUATE_INITIAL_GATES = true;
ALLOW_MULTIPLE_GATES = true;

% read image
RGB = imread([dir_name '/' 'img_' sprintf('%05d',frame_nr) '.jpg']);
RGB = double(RGB) ./ 255;
RGB = imrotate(RGB, 90);

% color filter the image:
[Response,~] = createMask_basement(RGB);
if(graphics)
    figure()
    imshow(RGB);
    figure()
    imagesc(Response);
end

% perform subsampling to find all candidates:
SQUARE = 1;
shape = SQUARE;
[x,y,s,n_gates] = sub_sampling_snake(Response);
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
        
        Q_r1 = refine_corner(Q1,s(i),Response,0.5,graphics);
        Q_r2 = refine_corner(Q2,s(i),Response,0.5,graphics);
        Q_r3 = refine_corner(Q3,s(i),Response,0.5,graphics);
        Q_r4 = refine_corner(Q4,s(i),Response,0.5,graphics);
        
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
        cf(g) = get_color_fitness([x(g), y(g), s(g)], Response, STICK, shape);
    end
    
    if(ALLOW_MULTIPLE_GATES)
        % add the gates to a final list:
        [Q1, Q2, Q3, Q4] = get_corners_from_initial_detection(x(1), y(1), s(1))
        box1 = get_box_from_corners(Q1, Q2, Q3, Q4);
        boxes = [box1];
        indices = [1];
        iou_threshold_same = 0.7;
        for g = 2:n_gates
            [Q1, Q2, Q3, Q4] = get_corners_from_initial_detection(x(g), y(g), s(g));
            box_gate = get_box_from_corners(Q1, Q2, Q3, Q4);
            % go over the existing gates to see whether to add this gate:
            new_gate = true;
            for i = 1:size(boxes,1)
                iou = intersection_over_union(box_gate, boxes(i,:));
                if(iou > iou_threshold_same)
                    new_gate = false;
                    if(cf(g) > cf(indices(i)))
                        % gate g is better than the current one in the list:
                        boxes(i,:) = box_gate;
                        indices(i) = g;
                    end
                end
            end
            % if a new gate, add it:
            if(new_gate)
                boxes = [boxes; box_gate];
                indices(length(gates)+1) = g;
            end
        end
        plot_gates_candidates(boxes,'green',2);
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
        Q_r1 = refine_corner(Q1,s,Response,0.4,graphics);
        Q_r2 = refine_corner(Q2,s,Response,0.4,graphics);
        Q_r3 = refine_corner(Q3,s,Response,0.4,graphics);
        Q_r4 = refine_corner(Q4,s,Response,0.4,graphics);
        corners = [1 Q_r1(1) Q_r2(1) Q_r3(1) Q_r4(1) Q_r1(2) Q_r2(2) Q_r3(2) Q_r4(2)];
    end
end
end

function [refined_corner] = refine_corner(corner,size,Response,s_factor,graphics)

x_round_l = round(corner(1) - size * s_factor);
x_round_h = round(corner(1) + size * s_factor);
y_round_l = round(corner(2) - size * s_factor);
y_round_h = round(corner(2) + size * s_factor);

[x_l, y_l] = check_coordinate(x_round_l, y_round_l, 312, 160);
[x_h, y_h] = check_coordinate(x_round_h, y_round_h, 312, 160);

Q1_s1 = [x_l; y_l];
Q1_s2 = [x_h; y_l];
Q1_s3 = [x_h; y_h];
Q1_s4 = [x_l; y_h];
color = [1 0 0];

%     if graphics == 1
%         plot([Q1_s1(1) Q1_s2(1)], [Q1_s1(2), Q1_s2(2)], 'Color', color, 'LineWidth', 2);
%         plot([Q1_s2(1) Q1_s3(1)], [Q1_s2(2), Q1_s3(2)], 'Color', color, 'LineWidth', 2);
%         plot([Q1_s3(1) Q1_s4(1)], [Q1_s3(2), Q1_s4(2)], 'Color', color, 'LineWidth', 2);
%         plot([Q1_s4(1) Q1_s1(1)], [Q1_s4(2), Q1_s1(2)], 'Color', color, 'LineWidth', 2);
%     end
x_size = x_h-x_l+1;
y_size = y_h-y_l+1;

x_hist = zeros(1,x_size);
y_hist = zeros(1,y_size);

%Response(50,200)
best_x = 0;
best_x_loc = x_l;
x_best_start = x_l;
best_y = 0;
best_y_loc = y_l;
y_best_start = y_l;


for y_pix = y_l:y_h
    for x_pix = x_l:x_h
        if(Response(y_pix,x_pix)>0)
            
            cur_x = x_hist(x_pix-x_l+1);
            cur_y = y_hist(y_pix-y_l+1);
            
            if(cur_x > best_x)
                best_x = cur_x;
                best_x_loc = x_pix;
                x_best_start = x_pix;
            elseif(cur_x == best_x)
                best_x_loc = round((x_pix+x_best_start)/2);
            end
            if(cur_y > best_y)
                best_y = cur_y;
                best_y_loc = y_pix;
                y_best_start = y_pix;
            elseif(cur_y == best_y)
                best_y_loc = round((y_pix+y_best_start)/2);
            end
            
            x_hist(x_pix-x_l+1) = cur_x+1;
            y_hist(y_pix-y_l+1) = cur_y+1;
        end
    end
end

refined_corner = [best_x_loc,best_y_loc];
%    color = [0 1 0];
%     plot([Q1_s1(1) Q1_s2(1)], [best_y_loc, best_y_loc], 'Color', color, 'LineWidth', 2);
%     plot([best_x_loc, best_x_loc], [Q1_s2(2), Q1_s3(2)], 'Color', color, 'LineWidth', 2);
%
%     plot([Q1_s1(1) Q1_s2(1)], [Q1_s1(2), Q1_s2(2)], 'Color', color, 'LineWidth', 2);
%     plot([Q1_s2(1) Q1_s3(1)], [Q1_s2(2), Q1_s3(2)], 'Color', color, 'LineWidth', 2);
%     plot([Q1_s3(1) Q1_s4(1)], [Q1_s3(2), Q1_s4(2)], 'Color', color, 'LineWidth', 2);
%     plot([Q1_s4(1) Q1_s1(1)], [Q1_s4(2), Q1_s1(2)], 'Color', color, 'LineWidth', 2);
end

function [x, y] = check_coordinate(x, y, W, H)
% function [x, y] = check_coordinate(x, y, W, H)

x = max([1,x]);
x = min([W,x]);
y = max([1,y]);
y = min([H,y]);
end