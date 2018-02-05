function [Ture_Positive,False_Positive, False_Negative,True_Negative] = check_auto_detection_accuracy(dir_name,n,m,GT,SG)
% This function is used to check how accurate snake gate detection
% algorithm works. It print manually detection and SG detection on one
% single image

p = 1;
THRESH = 0.15;
WAIT_FOR_CLICK = 1;

Ture_Positive = 0;
True_Negative = 0;
False_Positive = 0;
False_Negative = 0;

for i = n:m
     file_name = [dir_name '/' 'img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        frame_nr = i;
        RGB = imread([dir_name '/' 'img_' sprintf('%05d',frame_nr) '.jpg']);
        RGB = imrotate(RGB, 90);
        figure(1)
        imshow(RGB);
        hold on
        
        Q1_GT = [GT(p,2) GT(p,6)];
        Q2_GT = [GT(p,3) GT(p,7)];
        Q3_GT = [GT(p,4) GT(p,8)];
        Q4_GT = [GT(p,5) GT(p,9)];
        
        Q1_DT = [SG(p,2) SG(p,6)];
        Q2_DT = [SG(p,3) SG(p,7)];
        Q3_DT = [SG(p,4) SG(p,8)];
        Q4_DT = [SG(p,5) SG(p,9)];
        
        center_error_vector = [((Q1_GT(1)+Q2_GT(1))/2+(Q3_GT(1)+Q4_GT(1))/2)/2 ...
            ((Q1_GT(2)+Q4_GT(2))/2+(Q2_GT(2)+Q3_GT(2))/2)/2] - ...
            [((Q1_DT(1)+Q2_DT(1))/2+(Q3_DT(1)+Q4_DT(1))/2)/2 ...
            ((Q1_DT(2)+Q4_DT(2))/2+(Q2_DT(2)+Q3_DT(2))/2)/2];
        center_error(p) = norm(center_error_vector);
        center_error_relative(p) = center_error(p)/abs(Q1_GT(1)-Q2_GT(1));

        if GT(p,1) == 1 && SG(p,1) == 1 && center_error_relative(p) < THRESH
            Ture_Positive = Ture_Positive + 1;
            plot_square(GT(p,:),'r');
            plot_square(SG(p,:),'g');
            figure(1)
            s1 = 'True-Positive';
            s2 = num2str(center_error_relative(p));
            ss = strcat(s1,s2);
            title(ss);
        elseif GT(p,1) == 1 && SG(p,1) == 1 && center_error_relative(p) > THRESH
            False_Positive = False_Positive + 1;
            plot_square(GT(p,:),'r');
            plot_square(SG(p,:),'g');
            figure(1)
            s1 = 'False-Positive';
            s2 = num2str(center_error_relative(p));
            ss = strcat(s1,s2);
            title(ss);
        elseif GT(p,1) == 1 && SG(p,1) == 0
            False_Positive = False_Positive + 1;
            plot_square(GT(p,:),'r');
            figure(1)
             s1 = 'False-Positive';
            s2 = num2str(center_error_relative(p));
            ss = strcat(s1,s2);
             title(ss);
        elseif GT(p,1) == 0 && SG(p,1) == 1
            False_Negative = False_Negative + 1;
            plot_square(SG(p,:),'g');
            figure(1)
            s1 = 'False-Negative';
            s2 = num2str(center_error_relative(p));
            ss = strcat(s1,s2);
             title(ss);
        else
            True_Negative = True_Negative + 1;
            s1 = 'True-Negative';
            s2 = num2str(center_error_relative(p));
            ss = strcat(s1,s2);
            title(ss);
        end
        if WAIT_FOR_CLICK == 1
            waitforbuttonpress;
        end
        close all
    end
 p = p+1;
end


end


function [] = plot_square(corner_coor,color)
figure(1)
Q1 = [corner_coor(2) corner_coor(6)];
Q2 = [corner_coor(3) corner_coor(7)];
Q3 = [corner_coor(4) corner_coor(8)];
Q4 = [corner_coor(5) corner_coor(9)];
plot([Q1(1) Q2(1)],[Q1(2) Q2(2)],color,'LineWidth',2);
plot([Q2(1) Q3(1)],[Q2(2) Q3(2)],color,'LineWidth',2);
plot([Q3(1) Q4(1)],[Q3(2) Q4(2)],color,'LineWidth',2);
plot([Q4(1) Q1(1)],[Q4(2) Q1(2)],color,'LineWidth',2);
end
