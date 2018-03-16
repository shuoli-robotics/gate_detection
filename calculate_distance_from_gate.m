function [distance] = calculate_distance_from_gate(coor,file_name)
% This function calculate how much is the area of the gate
RGB = imread(file_name);
RGB = double(RGB) ./ 255;
RGB = imrotate(RGB, 90);
[Response,~] = createMask_basement(RGB);

[m,n] = size(Response);

mask_GT_gate = poly2mask(coor1(1:4),coor1(5:8),m,n);

distance = sum(mask_GT_gate)/(m*n);

end