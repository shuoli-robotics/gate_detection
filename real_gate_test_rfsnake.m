close all;
clear all

dir_name = 'Basement';
% 'Cyberzoo'
% main_hall

if(strcmp(dir_name, 'Korea'))
    n = 1;
    m = 61;
elseif (strcmp(dir_name, 'Cyberzoo'))
    n = 1;
    m = 35;
    elseif (strcmp(dir_name, 'Basement'))
    n = 125;
    m = 148;
end


for c = n:m
 [image_points_x,image_points_y] = run_detection_corner_refine_img(dir_name, c);
end
