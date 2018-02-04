function [] = check_accuracy_of_manually_detection(GT,dir_name,n,m)

p = 1;

for i = 0:m
    file_name = [dir_name '/' 'img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    else
        RGB = imread(file_name);
        RGB = imrotate(RGB, 90);
        figure(1)
        imshow(RGB);
        hold on
    end
   if GT(p,1) == 1
       Q1 = [GT(p,2) GT(p,6)];
       Q2 = [GT(p,3) GT(p,7)];
       Q3 = [GT(p,4) GT(p,9)];
       Q4 = [GT(p,5) GT(p,9)];
       plot([Q1(1) Q2(1)],[Q1(2) Q2(2)],'r','LineWidth',2);
       plot([Q2(1) Q3(1)],[Q2(2) Q3(2)],'r','LineWidth',2);
       plot([Q3(1) Q4(1)],[Q3(2) Q4(2)],'r','LineWidth',2);
       plot([Q4(1) Q1(1)],[Q4(2) Q1(2)],'r','LineWidth',2);
   end
   k = waitforbuttonpress;
   close all;
   p = p+1;
end

end