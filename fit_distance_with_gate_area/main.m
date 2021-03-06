close all;
clear all

%  dir_name = 'cyberzoo_distance';
% % 
%  [ GT_gate ] = find_corners_manually( dir_name,0,1000 );

load('4_16_cyberzoo_dis');

area_distance = zeros(size(GT_gate,1),2);

for i = 1:size(GT_gate,1)
    if i <= 11
        area_distance(i,2) = 6;
    elseif i <= 21
        area_distance(i,2) = 5;
    elseif i <= 31
        area_distance(i,2) = 4;
    elseif i <= 41
        area_distance(i,2) = 3;
    elseif i <= 51
        area_distance(i,2) = 2;
    end
    area_distance(i,1) = polyarea(GT_gate(i,2:5),GT_gate(i,6:9));
    
end

figure(1)
hold on
plot(area_distance(:,1),area_distance(:,2),'*');

p = polyfit(area_distance(:,1),area_distance(:,2),5);
x1 = linspace(0,8000);
y1 = polyval(p,x1);
figure(1)
plot(x1,y1);
temp = 1;