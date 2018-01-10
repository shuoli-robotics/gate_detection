function [gate_corners_x, gate_corners_y] = run_detection_corner_refine_img(dir_name, frame_nr)

graphics = true;%true;%false;

% image_names = makeListOfFiles(dir_name, 'jpg');
% image_names = sort_nat(image_names);
% n_images = length(image_names);

% whether to threshold the color response:
THRESHOLD = true;
CUT_OFF_PROPELLORS = false;
% the detection method (should be true in this file)
SUB_SAMPLING_SNAKE = true;

% filter images

% read the image in RGB
%     RGB = imread([dir_name '\' image_names{im}]);
RGB = imread([dir_name '/' 'img_' sprintf('%05d',frame_nr) '.jpg']);
RGB = double(RGB) ./ 255;

%rotate anyway
RGB = imrotate(RGB, 90);

% potentially resize the image:
if(strcmp(dir_name, 'images') || strcmp(dir_name, 'ventilator_images'))
    RGB = imrotate(RGB, 90);
end
if(strcmp(dir_name, 'phone_images') || strcmp(dir_name, 'real_arena'))
    RGB = imresize(RGB, 0.25);
end

if(graphics)
    % show the image:
    figure(); 
    imshow(RGB);
    title('RGB image');
    
    figure()
    imagesc(RGB)
    axis([90 210 20 130])
end

% we filter in the hsv domain:
HSV = rgb2hsv(RGB);
H_ref = 0;%0.10;%0;
std_var = 0.10;%0 %0.10
S_thresh = 0.2;%0.4
Response = filter_HSV(HSV, H_ref, std_var, S_thresh);

% response thresholding:
if(THRESHOLD)
    std_factor = 2; % 1.5;
    mR = mean(Response(:));
    stdR = std(Response(:));
    Response = (Response > mR + std_factor*stdR) .* Response;
end

if(CUT_OFF_PROPELLORS)
    % cut off propellors:
    Response(:, 1:100) = 0;
    Response(:, end-100:end) = 0;
end

if(graphics)
    figure();
    imagesc(Response);
    axis([90 210 20 130])
    hold on;
    %title('Response Hue filter');
end


if(SUB_SAMPLING_SNAKE)

    SQUARE = 1;
    CIRCLE = 2;
    shape = SQUARE;

    [x,y,s,n_gates] = sub_sampling_snake(Response); 

    % check fitness of all gates and select the best one:
    STICK = false;
    cf = zeros(1,n_gates);
    for g = 1:n_gates
        cf(g) = get_color_fitness([x(g), y(g), s(g)], Response, STICK, shape); 
    end
    if(n_gates >= 1)
        [v,i] = max(cf);
        x = x(i); y = y(i); s = s(i);
        n_gates = length(x);
    end
    
    Q1 = [x-s; y-s];
    Q2 = [x+s; y-s];
    Q3 = [x+s; y+s];
    Q4 = [x-s; y+s];
    
    if(graphics)
    figure();
    imagesc(Response);
    axis([90 210 20 130])
    hold on;

    color = [0 1 0];
    plot([Q1(1) Q2(1)], [Q1(2), Q2(2)], 'Color', color, 'LineWidth', 5);
    plot([Q2(1) Q3(1)], [Q2(2), Q3(2)], 'Color', color, 'LineWidth', 5);
    plot([Q3(1) Q4(1)], [Q3(2), Q4(2)], 'Color', color, 'LineWidth', 5);
    plot([Q4(1) Q1(1)], [Q4(2), Q1(2)], 'Color', color, 'LineWidth', 5);
    end
    
    if(graphics)
    figure();
    imagesc(Response);
    axis([90 210 20 130])
    hold on;
    end
    %sub corners
    Q_r1 = refine_corner(Q1,s,Response,0.4);
    Q_r2 = refine_corner(Q2,s,Response,0.4);
    Q_r3 = refine_corner(Q3,s,Response,0.4);
    Q_r4 = refine_corner(Q4,s,Response,0.4);
    
    gate_corners_x = [Q_r1(1) Q_r2(1) Q_r3(1) Q_r4(1)];
    gate_corners_y = [Q_r1(2) Q_r2(2) Q_r3(2) Q_r4(2)];
    
    
    if(graphics)
    figure();
    imagesc(Response);
    axis([90 210 20 130])
    hold on;
    color = [1 0 0];
    plot([Q_r1(1) Q_r2(1)], [Q_r1(2), Q_r2(2)], 'Color', color, 'LineWidth', 5);
    plot([Q_r2(1) Q_r3(1)], [Q_r2(2), Q_r3(2)], 'Color', color, 'LineWidth', 5);
    plot([Q_r3(1) Q_r4(1)], [Q_r3(2), Q_r4(2)], 'Color', color, 'LineWidth', 5);
    plot([Q_r4(1) Q_r1(1)], [Q_r4(2), Q_r1(2)], 'Color', color, 'LineWidth', 5);
    end

    n_gates

end

if size(x)>0
% remember gates for returning
%     gates_in_image{im}.x = x(1);
%     gates_in_image{im}.y = y(1);
%     gates_in_image{im}.s = s(1);
end
%close all;

% if(graphics)
%     waitforbuttonpress;
%     %     close all;
% end
%close all;

function [refined_corner] = refine_corner(corner,size,Response,s_factor)
    
    x_round_l = round(corner(1) - size * s_factor);
    x_round_h = round(corner(1) + size * s_factor);
    y_round_l = round(corner(2) - size * s_factor);
    y_round_h = round(corner(2) + size * s_factor);
    
    [x_l, y_l] = check_coordinate(x_round_l, y_round_l, 315, 160);
    [x_h, y_h] = check_coordinate(x_round_h, y_round_h, 315, 160);
    
    Q1_s1 = [x_l; y_l];
    Q1_s2 = [x_h; y_l];
    Q1_s3 = [x_h; y_h];
    Q1_s4 = [x_l; y_h];
    color = [1 0 0];
    plot([Q1_s1(1) Q1_s2(1)], [Q1_s1(2), Q1_s2(2)], 'Color', color, 'LineWidth', 2);
    plot([Q1_s2(1) Q1_s3(1)], [Q1_s2(2), Q1_s3(2)], 'Color', color, 'LineWidth', 2);
    plot([Q1_s3(1) Q1_s4(1)], [Q1_s3(2), Q1_s4(2)], 'Color', color, 'LineWidth', 2);
    plot([Q1_s4(1) Q1_s1(1)], [Q1_s4(2), Q1_s1(2)], 'Color', color, 'LineWidth', 2);
    
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


function [x, y] = check_coordinate(x, y, W, H)
% function [x, y] = check_coordinate(x, y, W, H)

x = max([1,x]);
x = min([W,x]);
y = max([1,y]);
y = min([H,y]);

function Response = filter_HSV(HSV, H_ref, H_std_var, S_thresh)
% function Response = filter_HSV(HSV, H_ref, H_std_var, S_thresh)

% determine distance to mean, bending around 0 / 1:
H = HSV(:,:,1);
width = size(H, 2); height = size(H, 1);
H1 = H - H_ref;
H2 = ones(height, width) - H1;
H = min(H1, H2);

% filter on saturation:
S = HSV(:,:, 2);
S_Filter = S <= S_thresh;
H = H + 1000 * S_Filter; % will get 0 probability

% get the response:
Response = normpdf(H, H_ref, H_std_var);