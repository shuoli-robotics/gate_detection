function [intersection_area,relative_intersection_area] = calculate_intersection_area_of_two_rectangles(coor1,coor2)
% This function is used to calculate the intersection area of two
% rectangles
%   coor1 is is the coordinates of first rectangle
%  coor2 is is the coordinates of second rectangle

x_min = min([coor1(1:4) coor2(1:4)]);
x_max = max([coor1(1:4) coor2(1:4)]);
y_min = min([coor1(5:8) coor2(5:8)]);
y_max = max([coor1(5:8) coor2(5:8)]);

intersection_area = 0;
for i = x_min:x_max
    for j = y_min:y_max
        [in_1,on_1] = inpolygon(i,j,coor1(1:4),coor1(5:8));
        if in_1 || on_1
            within_first_polygon = 1;
        else
            within_first_polygon = 0;
        end
        [in_2,on_2] = inpolygon(i,j,coor1(1:4),coor1(5:8));
        if in_2 || on_2
            within_second_polygon = 1;
        else
            within_second_polygon = 0;
        end
        if within_first_polygon && within_second_polygon
            intersection_area = intersection_area + 1;
        end
    end
end

ploygon_area = polyarea(coor1(1:4),coor1(5:8));
relative_intersection_area = intersection_area/ploygon_area;

end
