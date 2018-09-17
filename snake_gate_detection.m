function [detected_gate,gates_candidate_corners] = snake_gate_detection(dir_name,first_im_number,last_im_number, graphics)
% function [detected_gate,gates_candidate_corners] = snake_gate_detection(dir_name,first_im_number,last_im_number, graphics)
%
% Run snake gate on a directory, from the image with first_im_number to the
% one of last_im_number.

ROTATE = false; % whether to add a random rotation
ROTATE_90 = false; % Bebop images have to be rotated 90 degrees

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
        if(ROTATE)
           rotation = 30; %rand(1) * 45; 
           fprintf('rotation = %f\n', rotation);
        else
            rotation = [];
        end
        [detected_gate(p,:),gates_candidate_corners{p}, cf{p}] = run_detection_corner_refine_img(dir_name, i, graphics, ROTATE_90, rotation);
        if graphics
            minimal_fitness_for_plotting = 0.0;
            h = figure();
            RGB = imread([dir_name '/' 'img_' sprintf('%05d',i) '.jpg']);
            RGB = double(RGB) ./ 255;
            if(ROTATE_90)
                RGB = imrotate(RGB, 90);
            end
            if(ROTATE)
                RGB = imrotate(RGB, rotation);
            end
            imshow(RGB);
            if ~isempty(gates_candidate_corners{p})
                line_width = 3;
                plot_gates_candidates(gates_candidate_corners{p}, [], line_width, cf{p}, [], minimal_fitness_for_plotting);
            end
            waitforbuttonpress;
            close(h);
        end
        
    end
    p = p+1;
end
end