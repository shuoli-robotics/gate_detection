function [TP2,TN2,FP2,FN2] = count_ROC_term_with_refined_candidates(GT,RF1,RF2,Raw)
% This function is used to count 4 terms for ROC curve

THRESH = 0.3;
FIGURE = 0;
color = 'r';
p = 1;
TP1 = 0;
TN1 = 0;
FP1 = 0;
FN1 = 0;
TP2 = 0;
TN2 = 0;
FP2 = 0;
FN2 = 0;
dir_name = 'basement';
for k = 0:1000
    file_name = [dir_name '/' 'img_' sprintf('%05d',k) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        TP_per_image = 0;
        TN_per_image = 0;
        FP_per_image = 0;
        FN_per_image = 0;
        if FIGURE == 1
            figure(1)
            RGB = imread(file_name);
            RGB = double(RGB) ./ 255;
            RGB = imrotate(RGB, 90);
            imshow(RGB);
            hold on
            plot_square(GT(p,2:9),'b',1,1)
            for j = 1:size(Raw{p},1)
              plot_and_label_candidates(Raw{p}(j,:),'',1,color)
            end
            figure(2)
            imshow(RGB);
            hold on
%             figure(3) 
%             imshow(RGB);
%             hold on
        end
        
        if GT(p,1) == 1 && ~isempty(RF1{p})
            flag_already_TP = 0;  % there is already a TP
            for j = 1:size(RF1{p},1)
                if is_two_polygon_similar(GT(p,2:9),RF1{p}(j,:),THRESH)
                    if flag_already_TP == 0
                        TP1 = TP1+1;
                        TP_per_image = TP_per_image + 1;
                        flag_already_TP = 1;
                    end
                    if FIGURE == 1
                        plot_and_label_candidates(RF1{p}(j,:),'TP',2,color)
                    end
                else
                    FP1 = FP1 + 1;
                    FP_per_image = FP_per_image + 1;
                    if FIGURE == 1
                        plot_and_label_candidates(RF1{p}(j,:),'FP',2,color)
                    end
                end
            end
            if  flag_already_TP == 0
                FN1 = FN1 + 1;
                FN_per_image = FN_per_image + 1;
                if FIGURE == 1
                    plot_and_label_candidates(GT(p,2:9),'FN',2,'b');
                end
            end
        elseif GT(p,1) == 1 && isempty(RF1{p})
            FN1 = FN1 + 1;
             FN_per_image = FN_per_image + 1;
            if FIGURE == 1
                plot_and_label_candidates(zeros(1,8),'FN',2,color)
            end
        elseif GT(p,1) == 0 && ~isempty(RF1{p})
            for j = 1:size(RF1{p},1)
                FP1 = FP1 + 1;
                FP_per_image = FP_per_image + 1;
                if FIGURE == 1
                    plot_and_label_candidates(RF1{p}(j,:),'FP',2,color)
                end
            end
        elseif GT(p,1) == 0 && isempty(RF1{p})
            TN1 = TN1 + 1;
             TN_per_image =  TN_per_image + 1;
            if FIGURE == 1
                plot_and_label_candidates(zeros(1,8),'TN',2,color)
            end
        end
        
        if FIGURE == 1
           label_ROC_term(TP_per_image,TN_per_image,FP_per_image,FN_per_image,2) ;
        end
        
        if GT(p,1) == 1 && ~isempty(RF2{p})
            flag_already_TP = 0;  % there is already a TP
            for j = 1:size(RF2{p},1)
                if is_two_polygon_similar(GT(p,2:9),RF2{p}(j,:),THRESH)
                    if flag_already_TP == 0
                        TP2 = TP2+1;
                        flag_already_TP = 1;
                    end
%                     if FIGURE == 1
%                         plot_and_label_candidates(RF2{p}(j,:),'TP',3,color)
%                     end
                else
                    FP2 = FP2 + 1;
%                     if FIGURE == 1
%                         plot_and_label_candidates(RF2{p}(j,:),'FP',3,color)
%                     end
                end
            end
            if  flag_already_TP == 0
                FN2 = FN2 + 1;
%                 if FIGURE == 1
%                     plot_and_label_candidates(GT(p,2:9),'FN',3,'b');
%                 end
            end
        elseif GT(p,1) == 1 && isempty(RF2{p})
            FN2 = FN2 + 1;
%             if FIGURE == 1
%                 plot_and_label_candidates(zeros(1,8),'FN',3,color)
%             end
        elseif GT(p,1) == 0 && ~isempty(RF2{p})
            for j = 1:size(RF2{p},1)
                FP2 = FP2 + 1;
%                 if FIGURE == 1
%                     plot_and_label_candidates(RF2{p}(j,:),'FP',3,color)
%                 end
            end
        elseif GT(p,1) == 0 && isempty(RF2{p})
            TN2 = TN2 + 1;
%             if FIGURE == 1
%                 plot_and_label_candidates(zeros(1,8),'TN',3,color)
%             end
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
hold on
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
