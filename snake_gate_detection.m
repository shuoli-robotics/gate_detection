function [detected_gate,gates_candidate_corners] = snake_gate_detection(dir_name,first_im_number,last_im_number, graphics)
% function [detected_gate,gates_candidate_corners] = snake_gate_detection(dir_name,first_im_number,last_im_number, graphics)
%
% Run snake gate on a directory, from the image with first_im_number to the
% one of last_im_number.

addpath('Gate_detection');
addpath('plot_function');

if(~exist('graphics', 'var') || isempty(graphics))
    graphics = false;
end

p = 1;
for i = first_im_number:last_im_number
    file_name = [dir_name '/' 'img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        [detected_gate(p,:),gates_candidate_corners{p}, cf{p}] = run_detection_corner_refine_img(dir_name, i);
        if graphics
            h = figure();
            RGB = imread([dir_name '/' 'img_' sprintf('%05d',i) '.jpg']);
            RGB = double(RGB) ./ 255;
            RGB = imrotate(RGB, 90);
            imshow(RGB);
            if ~isempty(gates_candidate_corners{p})
                plot_gates_candidates(gates_candidate_corners{p}, [], 1, cf{p});
            end
            waitforbuttonpress;
            close(h);
        end
        
    end
    p = p+1;
end
end