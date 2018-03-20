function [distance] = distribution_of_distance_from_gate(GT)

p = 1;
for i = 1:size(GT)
    if GT(i,1) == 1
       distance(p) =  polyarea(GT(i,2:5),GT(i,6:9))/(315*160);
       p = p + 1;
    end
end

figure(1)
histogram(distance)
close all
end