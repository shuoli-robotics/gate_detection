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
figure_num = figure_num + 1;
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