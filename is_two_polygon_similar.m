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