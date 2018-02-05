close all;
clear all

dir_name = 'pic_cyberzoo';

% [ GT_gate ] = find_corners_manually( dir_name,0,1000 );
% load('2018_2_2_ground_truth_gate_selection');
%check_accuracy_of_manually_detection(GT_gate,dir_name,0,1000);
p = 1;

%check_accuracy_of_manually_detection(GT,dir_name,n,m)

% [detected_gate] = snake_gate_detection(dir_name,0,1000);

%[corner_error_relative,center_error_relative] = check_max_error_of_automatic_detection(GT,detected_gate);

load('2018_2_5_GT_with_SG');
[Ture_Positive,False_Positive, False_Negative,True_Negative] = ...
    check_auto_detection_accuracy(dir_name,0,1000,GT_gate,detected_gate);

[TP,FN,FP,TN] = count_detection_result(GT,detected_gate);
ROC_data(p,:) = [TP/(TP+FN) FP/(FP+TN)];
p = p + 1;

figure(10)
plot( ROC_data(:,2), ROC_data(:,1));
temp = 1;
