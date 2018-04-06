function [TP,TN,FP,FN] = count_ROC_with_onboard_detection_algorithm(detected_gates,GT_gate)
TN = 0;
TP = 0;
FN = 0;
FP = 0;
THRESH = 0.3;
for i = 1:size(detected_gates,1)
   if detected_gates(i,1) == 1 && GT_gate(i,1) == 1 &&  is_two_polygon_similar(GT_gate(i,2:9),detected_gates(i,2:9),THRESH) 
      TP = TP + 1; 
   elseif detected_gates(i,1) == 1 && GT_gate(i,1) == 1 &&  ~is_two_polygon_similar(GT_gate(i,2:9),detected_gates(i,2:9),THRESH)
       FP = FP + 1;
       FN = FN + 1;
   elseif detected_gates(i,1) == 1 && GT_gate(i,1) == 0
       FP = FP + 1;
   elseif detected_gates(i,1) == 0 && GT_gate(i,1) == 1
       FN = FN + 1;
   elseif detected_gates(i,1) == 0 && GT_gate(i,1) == 0
       TN = TN + 1;
   end
end


end