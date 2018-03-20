function [group_id,distance] = calculate_distance_and_group_id(GT)
distance =  polyarea(GT(2:5),GT(6:9))/(315*160);
for i = 1:10
   if distance < i*0.02
      group_id = i;
      return;
   end
end
group_id = 11;
end