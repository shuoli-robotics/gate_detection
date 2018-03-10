clear
close all
clc

for i = 1:30
    center1 = round(300*rand(2));
    center2 = round(300*rand(2));
    [coor1] = generate_polygon(center1);
    [coor2] = generate_polygon(center2);
    
    [intersection_area,relative_intersection_area_1,elative_intersection_area_2] = ...
        calculate_intersection_area_of_two_polygons(coor1,coor2)
    
    figure(1)
    hold on
    fill(coor1(1:4),coor1(5:8),'r');
    fill(coor2(1:4),coor2(5:8),'g');
    %waitforbuttonpress();
    close 
end

function [coor] = generate_polygon(center)
x1 = center(1);
x2 = 300 - center(1);
y1 = center(2);
y2 = 300 - center(2);

max_radius = min([x1 x2 y1 y2]);
coor = zeros(1,8);
angle = 360*rand()/180*pi;
%angle = 0;
%radius = round(max_radius * rand());
for i = 1:4
     radius = round(max_radius * rand());
    angle = angle + 90/180*pi;
    coor(i) = center(1)+radius*cos(angle);
    coor(i+4) =  center(2)+radius*sin(angle);
end

end