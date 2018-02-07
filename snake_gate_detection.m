function [detected_gate,gates_candidate_corners] = snake_gate_detection(dir_name,n,m)

p = 1;

for i = n:m
     file_name = [dir_name '/' 'img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        [detected_gate(p,:),gates_candidate_corners{p}] = run_detection_corner_refine_img(dir_name, i,p);
        
    end
 p = p+1;
end
end