function [detected_gate,gates_candidate_corners] = snake_gate_detection(dir_name,n,m)

p = 1;
FIGURE = 0;

for i = n:m
     file_name = [dir_name '/' 'img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        [detected_gate(p,:),gates_candidate_corners{p}] = run_detection_corner_refine_img(dir_name, i,p);
        if FIGURE == 1
            figure(1)
            RGB = imread([dir_name '/' 'img_' sprintf('%05d',i) '.jpg']);
            RGB = double(RGB) ./ 255;
            RGB = imrotate(RGB, 90);
            imshow(RGB);
             if ~isempty(gates_candidate_corners{p})
                 plot_gates_candidates(gates_candidate_corners{p},'r',1,1);
             end
            close all;
        end
        
    end
 p = p+1;
end
end