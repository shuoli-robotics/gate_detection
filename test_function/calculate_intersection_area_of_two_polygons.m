function [relative_intersection_area_1,relative_intersection_area_2] = calculate_intersection_area_of_two_polygons(coor1,coor2)
BW1 = poly2mask(coor1(1:4),coor1(5:8),300,300);
BW2 = poly2mask(coor2(1:4),coor2(5:8),300,300);
overlap = BW1 & BW2;

overlap_area = 0;
for i = 1:300
    for j = 1:300
        if overlap(i,j) == 1
            overlap_area = overlap_area + 1;
        end
    end
end

area_1 = polyarea(coor1(1:4),coor1(5:8));
area_2 = polyarea(coor2(1:4),coor2(5:8));
relative_intersection_area_1 = overlap_area/area_1;
relative_intersection_area_2 = overlap_area/area_2;
end