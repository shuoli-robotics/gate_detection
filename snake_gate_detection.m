function [detected_gate] = snake_gate_detection(dir_name)

p = 1;

for i = 1:1000
     file_name = [dir_name '/' 'img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        detected_gate(p,:) = run_detection_corner_refine_img(dir_name, i,p);
    end
 p = p+1;
end
end