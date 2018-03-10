close all;
clear all
global sample_num FIGURE minimun_length

dir_name = 'pic_cyberzoo';
FIGURE = 0;
% [ GT_gate ] = find_corners_manually( dir_name,0,1000 );
 load('2018_2_2_ground_truth_gate_selection');
%check_accuracy_of_manually_detection(GT_gate,dir_name,0,1000);
p = 1;
%check_accuracy_of_manually_detection(GT,dir_name,n,m)
%[corner_error_relative,center_error_relative] = check_max_error_of_automatic_detection(GT,detected_gate);
%load('2018_2_5_GT_with_SG');

n = 1;
m = 20;

TP_rate_mean = zeros(m-n+1,1);
FP_rate_mean = zeros(m-n+1,1);
TP_rate_std = zeros(m-n+1,1);
FP_rate_std = zeros(m-n+1,1);

ROC_statistic = cell(m-n+1,1);

max_iter = 20;

%minimun_length = (i-1)*5;
sample_num = 1000;
%[detected_gate,gates_candidate_corners] = snake_gate_detection(dir_name,0,1000);

load('2018_3_8_raw_detection');

refined_gate_candidates = refine_gate_candidates(gates_candidate_corners);

temp = 1;
% [True_Positive,False_Positive, False_Negative,True_Negative] =...
%     count_4_category(dir_name,0,1000,GT_gate,gates_candidate_corners,detected_gate);



% figure(10)
% grid on
% errorbar(FP_rate_mean,TP_rate_mean,...
%     TP_rate_std,TP_rate_std,FP_rate_std,FP_rate_std,'o')
% xlabel('False Positive rate');
% ylabel('True Positive rate');
% temp = 1;
