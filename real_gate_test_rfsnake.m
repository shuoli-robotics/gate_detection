close all;
clear all
global sample_num FIGURE minimun_length color_fitness_threshold

dir_name = 'basement';
FIGURE = 0;
% [ GT_gate ] = find_corners_manually( dir_name,0,1000 );
 load('3_19_GT_gate');
% load('GT_basement');
%check_accuracy_of_manually_detection(GT_gate,dir_name,0,1000);

%check_accuracy_of_manually_detection(GT,dir_name,n,m)
%[corner_error_relative,center_error_relative] = check_max_error_of_automatic_detection(GT,detected_gate);
%load('2018_2_5_GT_with_SG');

n = 1;
m = 20;

TP_rate_mean = zeros(m-n+1,1);
FP_rate_mean = zeros(m-n+1,1);
TP_rate_std = zeros(m-n+1,1);
FP_rate_std = zeros(m-n+1,1);
FP_per_imag_mean = zeros(m-n+1,1);
FP_per_imag_std = zeros(m-n+1,1);
ROC_statistic = cell(m-n+1,1);

max_iter = 10;

for i = n:m
    i

%     minimun_length = (i-1)*5;
%     %minimun_length = 25;
% 
% %     color_fitness_threshold = (i-1)*0.05;
%     color_fitness_threshold = 0.7;
%     sample_num = 1000;
%     p = 1;
%     while p <= max_iter
%         [detected_gate,gates_candidate_corners] = snake_gate_detection(dir_name,0,1000);
%         [refined_gate_candidates,refined_gate_candidates_cf] = refine_gate_candidates(gates_candidate_corners);
%         [TP,TN,FP,FN] = count_ROC_term_with_refined_candidates(GT_gate,refined_gate_candidates,...
%             refined_gate_candidates_cf,gates_candidate_corners);
% %         [TP,TN,FP,FN] = count_ROC_with_onboard_detection_algorithm(detected_gate,GT_gate);
%         ROC_statistic{i}(p,1) = TP;
%         ROC_statistic{i}(p,2) = TN;
%         ROC_statistic{i}(p,3) = FP;
%         ROC_statistic{i}(p,4) = FN;
%         ROC_statistic{i}(p,5) = TP/(TP + FN);
%         ROC_statistic{i}(p,6) = FP/(FP + TN);
%         ROC_statistic{i}(p,7) = FP/ size(GT_gate,1) ;
%         p = p+1;
%     end
%     TP_rate_mean(i) = mean(ROC_statistic{i}(:,5));
%     FP_rate_mean(i) = mean(ROC_statistic{i}(:,6));
%     TP_rate_std(i) = std(ROC_statistic{i}(:,5));
%     FP_rate_std(i) = std(ROC_statistic{i}(:,6));
%     FP_per_imag_mean(i) = mean(ROC_statistic{i}(:,7));
%     FP_per_imag_std(i) = std(ROC_statistic{i}(:,7));
end

%  load('3_24_desktop');
 load('3_24_laptop');

figure(10)
hAx=axes;
%  hAx.XScale='log';
% xlim([10^-2 20]);
hold all

errorbar(FP_per_imag_mean,TP_rate_mean,...
    TP_rate_std,TP_rate_std,FP_per_imag_std,FP_per_imag_std,'o')

fig.real_race = plot(0.07,0.4476,'o','MarkerSize',10);
grid on
legend(fig.real_race,'Algorithm used in drone race 2017')
x = [0.19 0.34];
y = [0.486 0.43];
annotation('textarrow',x,y,'String','y = x ')
xlabel('# FPs/image');
ylabel('True Positive rate');
temp = 1;
