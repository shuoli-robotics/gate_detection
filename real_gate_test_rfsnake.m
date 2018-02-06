close all;
clear all

dir_name = 'pic_cyberzoo';

global channel3Min

 [ GT_gate ] = find_corners_manually( dir_name,0,1000 );
%load('gt_labels_base_2_1');

p = 1;
for i = 10:10
    i
    %check_accuracy_of_manually_detection(GT,dir_name,n,m)
    
    channel3Min = 120+(i-1);
    [detected_gate] = snake_gate_detection(dir_name);
    [corner_error_relative,center_error_relative] = check_max_error_of_automatic_detection(GT,detected_gate);
    
%     [TP,FN,FP,TN] = count_detection_result(GT,detected_gate);
%     ROC_data(p,:) = [TP/(TP+FN) FP/(FP+TN)];
    p = p + 1;
end
figure(10)
plot( ROC_data(:,2), ROC_data(:,1));
temp = 1;
