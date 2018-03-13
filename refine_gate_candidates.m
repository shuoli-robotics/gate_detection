function [refined_gate_candidates,gate_candidates_color_fitness] = refine_gate_candidates(gate_candidates_raw)
global color_fitness_threshold

dir_name = 'pic_cyberzoo';

p = 1;

FIGURE = 0;
CF_FIGURE = 0;

THRESH = 0.2;

Color_fitness = 1;
cf_thresh = color_fitness_threshold;

refined_gate_candidates = cell(size(gate_candidates_raw));
gate_candidates_color_fitness = cell(size(gate_candidates_raw));
for i = 0:1000
     file_name = [dir_name '/' 'img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        if ~isempty(gate_candidates_raw{p})
             refined_gate_candidates{p} = group_gate_candidates(gate_candidates_raw{p},THRESH);
             if Color_fitness == 0
                 RGB = imread([dir_name '/' 'img_' sprintf('%05d',i) '.jpg']);
                 RGB = double(RGB) ./ 255;
                 RGB = imrotate(RGB, 90);
                 [Response,~] = createMask_basement(RGB);
                 gate_candidates_color_fitness{p} = refined_gate_candidates{p};
             else
                 RGB = imread([dir_name '/' 'img_' sprintf('%05d',i) '.jpg']);
                 RGB = double(RGB) ./ 255;
                 RGB = imrotate(RGB, 90);
                 [Response,~] = createMask_basement(RGB);
                 gate_candidates_color_fitness{p} = filter_gates_with_color(refined_gate_candidates{p},Response,cf_thresh);
             end
        end
        
        if FIGURE == 1
            plot_raw_and_refined_gates(gate_candidates_raw{p},refined_gate_candidates{p},file_name)
        end
        
        if CF_FIGURE == 1
            figure(1)
            imagesc(Response);
            hold on
            plot_gates_candidates(refined_gate_candidates{p},'r',1,1);
            
            figure(2)
            imagesc(Response);
            hold on
            plot_gates_candidates( gate_candidates_color_fitness{p},'r',1,2);
            close all;
        end
    end
 p = p+1;
end
end



function [group] = group_gate_candidates(candidates,THRESH)
% This function is used to put raw gate candidates
% into several groups. candidates is a n*8 matrix

for i = 1:size(candidates,1)
    if i == 1
        group = candidates(1,:);
    else
        flag_find_one_group = 0;
        for j = 1:size(group,1)
            if is_two_polygon_similar(candidates(i,:),group(j,:),THRESH)
                group(j,:) = (group(j,:) + candidates(i,:))/2;
                flag_find_one_group = 1;
                break;
            end
        end
        if j == size(group,1) && flag_find_one_group == 0
            group = [group;candidates(i,:)];
        end
    end
end
end





function [filtered_gates] = filter_gates_with_color(gates_candidates,Response,cf_thresh)
filtered_gates = [];
p = 1;

FIGURE_DEBUG = 1

for i = 1:size(gates_candidates,1)
    Q = [gates_candidates(i,1) gates_candidates(i,5) ...
        gates_candidates(i,2) gates_candidates(i,6) ...
        gates_candidates(i,3) gates_candidates(i,7) ...
        gates_candidates(i,4) gates_candidates(i,8)];
    color_fitness = get_coulor_fitness_of_polygon(Response,Q);
    
    if FIGURE_DEBUG == 1
        figure(1)
         imagesc(Response);
         hold on
          plot_square(gates_candidates(i,:),'r',1,1);
          title(color_fitness)
          close all
          
    end
    
    if color_fitness > cf_thresh
        filtered_gates(p,:) = gates_candidates(i,:);
        p = p+1;
    end
end
end

