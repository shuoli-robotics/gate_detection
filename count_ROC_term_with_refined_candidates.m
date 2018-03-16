function [TP,FP,FN] = count_ROC_term_with_refined_candidates(GT,detected,group_num)
% This function is used to count 4 terms for ROC curve

THRESH = 0.3;
FIGURE = 0;
color = 'r';
p = 1;
TP = 0;
TN = 0;
FP = 0;
FN = 0;

dir_name = 'pic_cyberzoo';
for k = 0:1000
    file_name = [dir_name '/' 'img_' sprintf('%05d',k) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        if FIGURE == 1
            figure(1)
            RGB = imread(file_name);
            RGB = double(RGB) ./ 255;
            RGB = imrotate(RGB, 90);
            imshow(RGB);
            hold on
            plot_square(GT(p,2:9),'b',1,1)
            for j = 1:size(detected{p},1)
              plot_and_label_candidates(detected{p}(j,:),'',1,color)
            end
        end
        
        if  ~isempty(detected{p})
            flag_already_TP = 0;  % there is already a TP
            for j = 1:size(detected{p},1)
                if is_two_polygon_similar(GT(p,2:9),RF2{p}(j,:),THRESH)
                    if flag_already_TP == 0
                        TP = TP+1;
                        flag_already_TP = 1;
                    end
                    if FIGURE == 1
                        plot_and_label_candidates(RF2{p}(j,:),'TP',3,color)
                    end
                else
                    FP = FP + 1;
                    if FIGURE == 1
                        plot_and_label_candidates(RF2{p}(j,:),'FP',3,color)
                    end
                end
            end
            if  flag_already_TP == 0
                FN = FN + 1;
                if FIGURE == 1
                    plot_and_label_candidates(GT(p,2:9),'FN',3,'b');
                end
            end
        elseif isempty(detected{p})
            FN = FN + 1;
            if FIGURE == 1
                plot_and_label_candidates(zeros(1,8),'FN',3,color)
            end
        end
        close all;
        p = p+ 1;
    end
end
end

function [] = plot_and_label_candidates(coor,label,figure_num,color)
% This function is used to plot raw gates candidates and
% gates after clustering
linewidth = 1;
%color = 'r';
figure(figure_num)

[x_center,y_center] = polyxpoly([coor(1) coor(3)],[coor(5) coor(7)], ...
    [coor(2) coor(4)],[coor(6) coor(8)]);

plot_square(coor,color,linewidth,figure_num);
text(x_center,y_center,label);
end

function [] = plot_square(coor,color,linewidth,figure_num)
figure(figure_num)
plot([coor(1) coor(2)],[coor(5) coor(6)],color,'LineWidth',linewidth);
plot([coor(2) coor(3)],[coor(6) coor(7)],color,'LineWidth',linewidth);
plot([coor(3) coor(4)],[coor(7) coor(8)],color,'LineWidth',linewidth);
plot([coor(4) coor(1)],[coor(8) coor(5)],color,'LineWidth',linewidth);
end
