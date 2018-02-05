function [true_true,true_false,false_true,false_false] = count_detection_result(GT_gate,DT_gate)
true_true = 0;
true_false = 0;
false_true = 0;
false_false = 0;
p = 1;
THRESH = 0.15;
for i = 1:size(GT_gate,1)
    Q1_GT = [GT_gate(i,2) GT_gate(i,6)];
    Q2_GT = [GT_gate(i,3) GT_gate(i,7)];
    Q3_GT = [GT_gate(i,4) GT_gate(i,8)];
    Q4_GT = [GT_gate(i,5) GT_gate(i,9)];
    
    Q1_DT = [DT_gate(i,2) DT_gate(i,6)];
    Q2_DT = [DT_gate(i,3) DT_gate(i,7)];
    Q3_DT = [DT_gate(i,4) DT_gate(i,8)];
    Q4_DT = [DT_gate(i,5) DT_gate(i,9)];
    
    center_error_vector = [((Q1_GT(1)+Q2_GT(1))/2+(Q3_GT(1)+Q4_GT(1))/2)/2 ...
           ((Q1_GT(2)+Q4_GT(2))/2+(Q2_GT(2)+Q3_GT(2))/2)/2] - ...
           [((Q1_DT(1)+Q2_DT(1))/2+(Q3_DT(1)+Q4_DT(1))/2)/2 ...
           ((Q1_DT(2)+Q4_DT(2))/2+(Q2_DT(2)+Q3_DT(2))/2)/2];
    center_error(p) = norm(center_error_vector);
    center_error_relative(p) = center_error(p)/abs(Q1_GT(1)-Q2_GT(1));
   if GT_gate(i,1) == 0 && DT_gate(i,1) == 0
      false_false = false_false + 1;
   elseif  GT_gate(i,1) == 0 && DT_gate(i,1) == 1
       false_true = false_true + 1;
   elseif GT_gate(i,1) == 1 && DT_gate(i,1) == 0
       true_false = true_false + 1;
   elseif GT_gate(i,1) == 1 && DT_gate(i,1) == 1
       if center_error_relative(p) < THRESH
           true_true = true_true + 1;
       else
             true_false = true_false + 1;
       end
   end
end

end