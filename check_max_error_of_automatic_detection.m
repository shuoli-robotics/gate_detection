function [corner_error_mean,corner_error_relative] = check_max_error_of_automatic_detection(GT_gate,DT_gate)
[m,n] = size(GT_gate);
p = 1;
for i = 1:m
   if GT_gate(i,1) == 1
       Q1_GT = [GT_gate(i,2) GT_gate(i,6)];
       Q2_GT = [GT_gate(i,3) GT_gate(i,7)];
       Q3_GT = [GT_gate(i,4) GT_gate(i,8)];
       Q4_GT = [GT_gate(i,5) GT_gate(i,9)];
       
       Q1_DT = [DT_gate(i,2) DT_gate(i,6)];
       Q2_DT = [DT_gate(i,3) DT_gate(i,7)];
       Q3_DT = [DT_gate(i,4) DT_gate(i,8)];
       Q4_DT = [DT_gate(i,5) DT_gate(i,9)];
       
       corner_error_mean(p) = mean([norm(Q1_GT-Q1_DT) norm(Q2_GT-Q2_DT) ...
           norm(Q3_GT-Q3_DT) norm(Q4_GT-Q4_DT)]);
       corner_error_relative(p) = corner_error_mean(p)/norm(Q1_GT-Q2_GT);
       p = p+1;
   end
end


end