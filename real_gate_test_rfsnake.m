close all;
clear all
global sample_num FIGURE minimun_length

dir_name = 'pic_cyberzoo';
FIGURE = 0;
% [ GT_gate ] = find_corners_manually( dir_name,0,1000 );
 load('2018_2_2_ground_truth_gate_selection');
%check_accuracy_of_manually_detection(GT_gate,dir_name,0,1000);

%check_accuracy_of_manually_detection(GT,dir_name,n,m)
%[corner_error_relative,center_error_relative] = check_max_error_of_automatic_detection(GT,detected_gate);
%load('2018_2_5_GT_with_SG');

n = 1;
m = 20;
max_iter = 100;
TPR = zeros(n-m+1,max_iter);
TPR_mean_std = zeros(n-m+1,2);
FPR = zeros(n-m+1,max_iter);
FPR_mean_std = zeros(n-m+1,2);
TP = zeros(m-n+1,1);
FP = zeros(m-n+1,1);
TN = zeros(m-n+1,1);
FN = zeros(m-n+1,1);
for i = n:m
    i
    iter = 1;
    
    while iter <= max_iter
        iter
        minimun_length = (i)*2;
        sample_num = 1000;
        [detected_gate,gates_candidate_corners] = snake_gate_detection(dir_name,0,1000);
        %load('2018_2_7_autonomous_detection_temp');
        %load('2018_2_7_autonomous_detection_temp_2');
        [True_Positive,False_Positive, False_Negative,True_Negative] =...
            count_4_category(dir_name,0,1000,GT_gate,gates_candidate_corners,detected_gate);
        % [True_Positive,False_Positive, False_Negative,True_Negative] = ...
        %     check_auto_detection_accuracy(dir_name,0,1000,GT_gate,detected_gate);
        % TP(i) = True_Positive
        % FP(i) = False_Positive
        % TN(i) = True_Negative
        % FN(i) =  False_Negative
        
        % temp1 = True_Positive/( True_Positive+False_Negative)
        % temp2 = False_Positive/( False_Positive+True_Negative)
        TPR(i,iter) = True_Positive/( True_Positive+False_Negative);
        FPR(i,iter) =  False_Positive/( False_Positive+True_Negative);
        iter = iter + 1;
    end
    TPR_mean_std(i,1)= mean(TPR(i,:));
    TPR_mean_std(i,2) = std(TPR(i,:));
    FPR_mean_std(i,1)= mean(FPR(i,:));
    FPR_mean_std(i,2) = std(FPR(i,:));
end

%load('2018_2_8_error_bar_2');
figure(10)
x = FPR_mean_std(:,1);
y = TPR_mean_std(:,1);
err1 = TPR_mean_std(:,2);
err2 = FPR_mean_std(:,2);

errorbar(x,y,err1,'-s','MarkerSize',5,...
    'MarkerEdgeColor','red','MarkerFaceColor','red')
%plot( FPR_mean_std(:,1), TPR_mean_std(:,1),'*');
grid on
hold on
errorbar(x,y,err2,'horizontal','-s','MarkerSize',5,...
    'MarkerEdgeColor','red','MarkerFaceColor','red')
xlabel('False Positive rate');
ylabel('True Positive rate');
temp = 1;
