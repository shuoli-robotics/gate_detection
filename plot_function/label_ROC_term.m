function [ output_args ] = label_ROC_term(TP,TN,FP,FN,fig_num,Response)
%LABEL_ROC_TERM Summary of this function goes here
%   Detailed explanation goes here

m = 0;
figure(fig_num)
TP_text = ['TP=',num2str(TP)];
text(m,1,TP_text,'HorizontalAlignment','right');
TN_text = ['TN=',num2str(TN)];
text(m,20,TN_text,'HorizontalAlignment','right');
FP_text = ['FP=',num2str(FP)];
text(m,30,FP_text,'HorizontalAlignment','right');
FN_text = ['FN=',num2str(FN)];
text(m,40,FN_text,'HorizontalAlignment','right');
end

