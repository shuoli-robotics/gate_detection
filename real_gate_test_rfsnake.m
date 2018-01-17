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
    n = 1;
    m = 300;
end

% [ GT_gate ] = find_corners_manually( dir_name,n,m );
load('detection_manually_1_16');
load('detected_gate_1_17');
[corner_error_mean,corner_error_relative] = check_max_error_of_automatic_detection(GT,detected_gate);
% check_accuracy_of_manually_detection(GT,dir_name,n,m)
p = 1;
detected_gate = zeros(m-n+1,9);
for i = n:m
     file_name = [dir_name '/' 'img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        detected_gate(p,:) = run_detection_corner_refine_img(dir_name, i);
    end
 p = p+1;
end
detected_gate = detected_gate(1:p-1,:);