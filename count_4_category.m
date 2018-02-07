function [True_Positive,False_Positive, False_Negative,True_Negative] = count_4_category(dir_name,n,m,GT,gates_candidate_corners,best_gate)
% This function is used to check how accurate snake gate detection
% algorithm works. It print manually detection and SG detection on one
% single image



p = 1;
THRESH = 0.15;
FIGURE = 0;
WAIT_FOR_CLICK = 0;

True_Positive = 0;
True_Negative = 0;
False_Positive = 0;
False_Negative = 0;

 relative_corner_error = zeros(size(gates_candidate_corners{p},1),1);
 corner_error_temp = zeros(size(gates_candidate_corners{p},1),4);
for i = n:m
    file_name = [dir_name '/' 'img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        frame_nr = i;
        RGB = imread([dir_name '/' 'img_' sprintf('%05d',frame_nr) '.jpg']);
        RGB = imrotate(RGB, 90);
        
        if FIGURE == 1
            figure(3)
            imshow(RGB);
            hold on
        end
        
        if size(gates_candidate_corners{p},1) == 0  % no gate is detected
            if GT(p,1) == 0     % GT: no gate
                True_Negative = True_Negative + 1;
                if FIGURE == 1
                    s1 = 'True-Negative';
                    s2 = num2str(0);
                    ss = strcat(s1,s2);
                    title(ss);
                end
                
            elseif GT(p,1) == 1  % GT: gate exist
                False_Negative = False_Negative + 1;
                if FIGURE == 1
                    s1 = 'False-Negative';
                    figure(3)
                    plot_square_GT(GT(p,:),'r',FIGURE)
                    s2 = num2str(0);
                    ss = strcat(s1,s2);
                    title(ss);
                end
            end
        else                                      % gate is detected
            if GT(p,1) == 0    % GT: no gate
                False_Positive = False_Positive + 1;
                if FIGURE == 1
                    figure(3)
                    for j = 1:size(gates_candidate_corners{p},1)
                        plot_square(gates_candidate_corners{p}(j,:),'g',FIGURE);
                    end
                    s1 = 'False-Positive';
                    s2 = num2str(0);
                    ss = strcat(s1,s2);
                    title(ss);
                end
            else               % GT: gate exists
                relative_corner_error = zeros(size(gates_candidate_corners{p},1),1);
                Q1_GT = [GT(p,5) GT(p,9)];
                Q2_GT = [GT(p,4) GT(p,8)];
                Q3_GT = [GT(p,3) GT(p,7)];
                Q4_GT = [GT(p,2) GT(p,6)];
                Q1_best = [best_gate(p,2) best_gate(p,6)];
                Q2_best = [best_gate(p,3) best_gate(p,7)];
                Q3_best = [best_gate(p,4) best_gate(p,8)];
                Q4_best = [best_gate(p,5) best_gate(p,9)];
                relative_corner_error_best = calculate_relative_corner_error...
                        (Q1_GT,Q2_GT,Q3_GT,Q4_GT,Q1_best,Q2_best,Q3_best,Q4_best);
                for j = 1:size(gates_candidate_corners{p},1)
                    Q1_DT = [gates_candidate_corners{p}(j,1) gates_candidate_corners{p}(j,5)];
                    Q2_DT = [gates_candidate_corners{p}(j,2) gates_candidate_corners{p}(j,6)];
                    Q3_DT = [gates_candidate_corners{p}(j,3) gates_candidate_corners{p}(j,7)];
                    Q4_DT = [gates_candidate_corners{p}(j,4) gates_candidate_corners{p}(j,8)];
                    
                    
                    center_error_relative = calculate_relative_center_error...
                        (Q1_GT,Q2_GT,Q3_GT,Q4_GT,Q1_DT,Q2_DT,Q3_DT,Q4_DT);
                    relative_corner_error(j) = calculate_relative_corner_error...
                        (Q1_GT,Q2_GT,Q3_GT,Q4_GT,Q1_DT,Q2_DT,Q3_DT,Q4_DT);
                   
                     if FIGURE == 1
                        figure(3)
                        if relative_corner_error(j) < 0.15
                            plot_square(gates_candidate_corners{p}(j,:),'g',FIGURE);
                        else
                            plot_square(gates_candidate_corners{p}(j,:),'b',FIGURE);
                        end
                        plot_square_GT(GT(p,:),'r',FIGURE);
                        plot_square_GT(best_gate(p,:),'m:',FIGURE);
                     end
                end
                if min(relative_corner_error) < THRESH
                    True_Positive = True_Positive + 1;
                    if FIGURE ==1
                        s1 = 'True-Positive';
                        s2 = num2str(min(relative_corner_error));
                        title(strcat(s1,s2));
                    end
                else
                     False_Positive = False_Positive + 1;
                     False_Negative = False_Negative + 1;
                     if FIGURE == 1
                        figure(3)
                        s1 = 'False-Positive & False-Negative';
                        s2 = num2str(min(relative_corner_error));
                        ss = strcat(s1,s2);
                        title(ss);
                    end 
                end
            end   
        end
        if WAIT_FOR_CLICK == 1
            waitforbuttonpress;
        end
        p = p+1;
    end
    
end

end
        
       


function [] = plot_square(corner_coor,color,FIGURE)


if FIGURE == 1
    Q1 = [corner_coor(1) corner_coor(5)];
    Q2 = [corner_coor(2) corner_coor(6)];
    Q3 = [corner_coor(3) corner_coor(7)];
    Q4 = [corner_coor(4) corner_coor(8)];
    plot([Q1(1) Q2(1)],[Q1(2) Q2(2)],color,'LineWidth',1);
    plot([Q2(1) Q3(1)],[Q2(2) Q3(2)],color,'LineWidth',1);
    plot([Q3(1) Q4(1)],[Q3(2) Q4(2)],color,'LineWidth',1);
    plot([Q4(1) Q1(1)],[Q4(2) Q1(2)],color,'LineWidth',1);
end
end

function [] = plot_square_GT(corner_coor,color,FIGURE)
if FIGURE == 1
    Q1 = [corner_coor(2) corner_coor(6)];
    Q2 = [corner_coor(3) corner_coor(7)];
    Q3 = [corner_coor(4) corner_coor(8)];
    Q4 = [corner_coor(5) corner_coor(9)];
    plot([Q1(1) Q2(1)],[Q1(2) Q2(2)],color,'LineWidth',1);
    plot([Q2(1) Q3(1)],[Q2(2) Q3(2)],color,'LineWidth',1);
    plot([Q3(1) Q4(1)],[Q3(2) Q4(2)],color,'LineWidth',1);
    plot([Q4(1) Q1(1)],[Q4(2) Q1(2)],color,'LineWidth',1);
end
end

function relative_corner_error = calculate_relative_corner_error(Q1_GT,Q2_GT,Q3_GT,Q4_GT,...
    Q1_DT,Q2_DT,Q3_DT,Q4_DT)
corner_error_1 = norm(Q1_GT-Q1_DT);
                    corner_error_2 = norm(Q2_GT-Q2_DT);
                    corner_error_3 = norm(Q3_GT-Q3_DT);
                    corner_error_4 = norm(Q4_GT-Q4_DT);

                    edge_length_1 = norm(Q1_GT-Q2_GT);
                    edge_length_2 = norm(Q3_GT-Q2_GT);
                    edge_length_3 = norm(Q3_GT-Q4_GT);
                    edge_length_4 = norm(Q1_GT-Q4_GT);
                    
                    average_length_of_gate = (edge_length_1+edge_length_2+...
                        edge_length_3+edge_length_4)/4;
                    
                    corner_error = (corner_error_1 + corner_error_2 + ...
                        corner_error_3 + corner_error_4)/4;
                     relative_corner_error = corner_error/average_length_of_gate;
end

function center_error_relative = calculate_relative_center_error(Q1_GT,Q2_GT,Q3_GT,Q4_GT,...
    Q1_DT,Q2_DT,Q3_DT,Q4_DT)
center_error_vector = [((Q1_GT(1)+Q2_GT(1))/2+(Q3_GT(1)+Q4_GT(1))/2)/2 ...
                        ((Q1_GT(2)+Q4_GT(2))/2+(Q2_GT(2)+Q3_GT(2))/2)/2] - ...
                        [((Q1_DT(1)+Q2_DT(1))/2+(Q3_DT(1)+Q4_DT(1))/2)/2 ...
                        ((Q1_DT(2)+Q4_DT(2))/2+(Q2_DT(2)+Q3_DT(2))/2)/2];
                    
                    center_error = norm(center_error_vector);
                    center_error_relative = center_error/abs(Q1_GT(1)-Q2_GT(1));
end