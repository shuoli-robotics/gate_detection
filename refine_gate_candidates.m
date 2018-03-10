function [refined_gate_candidates] = refine_gate_candidates(gate_candidates_raw)

dir_name = 'pic_cyberzoo';

p = 1;

FIGURE = 0;

THRESH = 0.2;

refined_gate_candidates = cell(size(gate_candidates_raw));
for i = 0:1000
     file_name = [dir_name '/' 'img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        if ~isempty(gate_candidates_raw{p})
             refined_gate_candidates{p} = group_gate_candidates(gate_candidates_raw{p},THRESH);
        end
        
        if FIGURE == 1
            plot_raw_and_refined_gates(gate_candidates_raw{p},refined_gate_candidates{p},file_name)
        end
    end
 p = p+1;
end
end

function [similar] = is_two_polygon_similar(coor1,coor2,THRESH)

% To do : change 500
BW1 = poly2mask(coor1(1:4),coor1(5:8),500,500);
BW2 = poly2mask(coor2(1:4),coor2(5:8),500,500);
overlap = BW1 & BW2;

overlap_area = 0;
for i = 1:500
    for j = 1:500
        if overlap(i,j) == 1
            overlap_area = overlap_area + 1;
        end
    end
end

area_1 = polyarea(coor1(1:4),coor1(5:8));
area_2 = polyarea(coor2(1:4),coor2(5:8));
r1= overlap_area/area_1; % relative_intersection_area_1 
r2 = overlap_area/area_2; % relative_intersection_area_2

if  (1-THRESH<r1) &&(r1 <1+THRESH) && (1-THRESH< r2) && (r2 <1+THRESH)
    similar = 1;
else
    similar = 0;
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
           temp =  is_two_polygon_similar(candidates(i,:),group(j,:),THRESH);
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

function [] = plot_raw_and_refined_gates(raw,refined,file_name)
% This function is used to plot raw gates candidates and
% gates after clustering
linewidth = 1;
color = 'r';
figure_num = 1;
figure(figure_num)
RGB = imread(file_name);
RGB = double(RGB) ./ 255;
RGB = imrotate(RGB, 90);
imshow(RGB);
hold on
for i = 1:size(raw)
    plot_square(raw(i,:),color,linewidth,figure_num);
end

linewidth = 2;
color = 'b';
figure_num = 2;
figure(figure_num)
RGB = imread(file_name);
RGB = double(RGB) ./ 255;
RGB = imrotate(RGB, 90);
imshow(RGB);
hold on
for i = 1:size(refined)
    plot_square(refined(i,:),color,linewidth,figure_num);
end
end

function [] = plot_square(coor,color,linewidth,figure_num)
figure(figure_num)
plot([coor(1) coor(2)],[coor(5) coor(6)],color,'LineWidth',linewidth);
plot([coor(2) coor(3)],[coor(6) coor(7)],color,'LineWidth',linewidth);
plot([coor(3) coor(4)],[coor(7) coor(8)],color,'LineWidth',linewidth);
plot([coor(4) coor(1)],[coor(8) coor(5)],color,'LineWidth',linewidth);
end
