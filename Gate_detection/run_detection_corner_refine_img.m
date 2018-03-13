function [corners,gates_candidate_corners] = run_detection_corner_refine_img(dir_name, frame_nr,p)
global color_fitness_threshold

FIGURE = 0;
WAIT_FOR_CLICK = 0;
% THRESH = color_fitness_threshold;
THRESH = 0.45;

RGB = imread([dir_name '/' 'img_' sprintf('%05d',frame_nr) '.jpg']);

RGB = double(RGB) ./ 255;
RGB = imrotate(RGB, 90);

if FIGURE == 1
figure(1)
imshow(RGB);
hold on
end
SUB_SAMPLING_SNAKE = true;

[Response,maskedRGBImage] = createMask_basement(RGB);


if FIGURE == 1
    figure(1);
    imagesc(Response);
    title(p);
    hold on;
end
if(SUB_SAMPLING_SNAKE)

    SQUARE = 1;
    shape = SQUARE;

    [x,y,s,n_gates] = sub_sampling_snake(Response); 
    if n_gates < 1
        corners = zeros(1,9);
        gates_candidate_corners = [];
        if WAIT_FOR_CLICK == 1
            waitforbuttonpress;
        end
        close all
        return;
    end
    
    %---------------------------------------------------------------------
    %                 refine corners of all gates founded
    if FIGURE == 1
       figure(2)
       imshow(RGB);
       hold on
       title('Gates candidate');
    end
    gates_candidate_corners = zeros(n_gates,8);
    
    p = 1;
    for i = 1:n_gates
        Q1 = [x(i)-s(i); y(i)-s(i)];
        Q2 = [x(i)+s(i); y(i)-s(i)];
        Q3 = [x(i)+s(i); y(i)+s(i)];
        Q4 = [x(i)-s(i); y(i)+s(i)];
        
        Q_r1 = refine_corner(Q1,s(i),Response,0.4,FIGURE);
        Q_r2 = refine_corner(Q2,s(i),Response,0.4,FIGURE);
        Q_r3 = refine_corner(Q3,s(i),Response,0.4,FIGURE);
        Q_r4 = refine_corner(Q4,s(i),Response,0.4,FIGURE);
        
        Corner_vector = [Q_r1 Q_r2 Q_r3 Q_r4];
        
        [color_fitness] = get_coulor_fitness_of_polygon(Response,Corner_vector);
        if color_fitness > THRESH
            gates_candidate_corners(p,1) = Q_r1(1);
            gates_candidate_corners(p,2) = Q_r2(1);
            gates_candidate_corners(p,3) = Q_r3(1);
            gates_candidate_corners(p,4) = Q_r4(1);
            gates_candidate_corners(p,5) = Q_r1(2);
            gates_candidate_corners(p,6) = Q_r2(2);
            gates_candidate_corners(p,7) = Q_r3(2);
            gates_candidate_corners(p,8) = Q_r4(2);
            p = p + 1;
            
        else
            temp = 1;
        end
        
        
        
        if FIGURE == 1
            figure(2)
            plot([Q1(1) Q2(1)], [Q1(2), Q2(2)], 'g');
            plot([Q2(1) Q3(1)], [Q2(2), Q3(2)], 'g');
            plot([Q3(1) Q4(1)], [Q3(2), Q4(2)], 'g');
            plot([Q4(1) Q1(1)], [Q4(2), Q1(2)], 'g');
            
            plot([Q_r1(1) Q_r2(1)], [Q_r1(2), Q_r2(2)], 'r');
            plot([Q_r2(1) Q_r3(1)], [Q_r2(2), Q_r3(2)], 'r');
            plot([Q_r3(1) Q_r4(1)], [Q_r3(2), Q_r4(2)], 'r');
            plot([Q_r4(1) Q_r1(1)], [Q_r4(2), Q_r1(2)], 'r');

        end
    end
    
    %---------------------------------------------------------------------
    
    
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
    


    color = [0 1 0];
    if FIGURE == 1
        figure(1)
        plot([Q1(1) Q2(1)], [Q1(2), Q2(2)], 'Color', color, 'LineWidth', 5);
        plot([Q2(1) Q3(1)], [Q2(2), Q3(2)], 'Color', color, 'LineWidth', 5);
        plot([Q3(1) Q4(1)], [Q3(2), Q4(2)], 'Color', color, 'LineWidth', 5);
        plot([Q4(1) Q1(1)], [Q4(2), Q1(2)], 'Color', color, 'LineWidth', 5);
    end
    %sub corners
    Q_r1 = refine_corner(Q1,s,Response,0.4,FIGURE);
    Q_r2 = refine_corner(Q2,s,Response,0.4,FIGURE);
    Q_r3 = refine_corner(Q3,s,Response,0.4,FIGURE);
    Q_r4 = refine_corner(Q4,s,Response,0.4,FIGURE);
    
%     gate_corners_x = [Q_r1(1) Q_r2(1) Q_r3(1) Q_r4(1)];
%     gate_corners_y = [Q_r1(2) Q_r2(2) Q_r3(2) Q_r4(2)];

    color = [1 0 0];
    if FIGURE == 1
        plot([Q_r1(1) Q_r2(1)], [Q_r1(2), Q_r2(2)], 'Color', color, 'LineWidth', 5);
        plot([Q_r2(1) Q_r3(1)], [Q_r2(2), Q_r3(2)], 'Color', color, 'LineWidth', 5);
        plot([Q_r3(1) Q_r4(1)], [Q_r3(2), Q_r4(2)], 'Color', color, 'LineWidth', 5);
        plot([Q_r4(1) Q_r1(1)], [Q_r4(2), Q_r1(2)], 'Color', color, 'LineWidth', 5);
    end
    corners = [1 Q_r1(1) Q_r2(1) Q_r3(1) Q_r4(1) Q_r1(2) Q_r2(2) Q_r3(2) Q_r4(2)];
    if WAIT_FOR_CLICK == 1
            waitforbuttonpress;
    end
    close all
end
end



function [refined_corner] = refine_corner(corner,size,Response,s_factor,FIGURE)
    
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
    
    if FIGURE == 1
        plot([Q1_s1(1) Q1_s2(1)], [Q1_s1(2), Q1_s2(2)], 'Color', color, 'LineWidth', 2);
        plot([Q1_s2(1) Q1_s3(1)], [Q1_s2(2), Q1_s3(2)], 'Color', color, 'LineWidth', 2);
        plot([Q1_s3(1) Q1_s4(1)], [Q1_s3(2), Q1_s4(2)], 'Color', color, 'LineWidth', 2);
        plot([Q1_s4(1) Q1_s1(1)], [Q1_s4(2), Q1_s1(2)], 'Color', color, 'LineWidth', 2);
    end
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



function [BW,maskedRGBImage] = createMask_basement(RGB)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder App. The colorspace and
%  minimum/maximum values for each channel of the colorspace were set in the
%  App and result in a binary mask BW and a composite image maskedRGBImage,
%  which shows the original RGB image values under the mask BW.

% Auto-generated by colorThresholder app on 12-Jan-2018
%------------------------------------------------------

% Convert RGB image to chosen color space
I = rgb2ycbcr(RGB);
I = I.*255;
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 255.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.000;
channel2Max = 175.000;

% Define thresholds for channel 3 based on histogram settings
 channel3Min = 134.000;
channel3Max = 255.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
end


function [color_fitness] = get_coulor_fitness_of_polygon(Response,Q)
FIGURE = 1;

Q1 = Q(1:2);
Q2 = Q(3:4);
Q3 = Q(5:6);
Q4 = Q(7:8);

% mask for lines
mask1 = mask_a_line(Q1,Q2,Response);
mask2 = mask_a_line(Q2,Q3,Response);
mask3 = mask_a_line(Q3,Q4,Response);
mask4 = mask_a_line(Q4,Q1,Response);

mask_square = mask1 | mask2 | mask3 | mask4;

% check color
mask_square_with_picture  = mask_square & Response; % how many pixels the square hit the color
color_fitness = sum(mask_square_with_picture) / sum(mask_square);


if FIGURE == 1
    figure(1)
    hold on
    imagesc(mask_square);
    imagesc(Response*50);
    figure(2)
    imagesc(mask_square_with_picture);
    close all
end
end


function [mask] = mask_a_line(Q1,Q2,pic)
% This function sets the line between Q1(x,y) and Q2(x,y) to be 1 and
% others to be 0


mask = zeros(size(pic));
x1 = Q1(1);
x2 = Q2(1);
y1 = Q1(2);
y2 = Q2(2);

% Distance (in pixels) between the two endpoints
nPoints = ceil(sqrt((x2 - x1).^2 + (y2 - y1).^2)) + 1;

% Determine x and y locations along the line
xvalues = round(linspace(x1, x2, nPoints));
yvalues = round(linspace(y1, y2, nPoints));

% Replace the relevant values within the mask
mask(sub2ind(size(mask), yvalues, xvalues)) = 1;

end

