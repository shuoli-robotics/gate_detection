function [color_fitness] = get_coulor_fitness_of_polygon(Response,Q)
FIGURE = 0;

Q1 = Q(1:2);
Q2 = Q(3:4);
Q3 = Q(5:6);
Q4 = Q(7:8);

% mask for lines
mask1 = mask_a_line(Q1,Q2,Response);
mask2 = mask_a_line(Q2,Q3,Response);
mask3 = mask_a_line(Q3,Q4,Response);
mask4 = mask_a_line(Q4,Q1,Response);

mask_square = mask1 | mask2 | mask3 | mask4;

% check color
mask_square_with_picture  = mask_square & Response; % how many pixels the square hit the color
color_fitness = sum(mask_square_with_picture) / sum(mask_square);


if FIGURE == 1
    figure(1)
    hold on
    imagesc(mask_square);
    imagesc(Response*50);
    figure(2)
    imagesc(mask_square_with_picture);
    close all
end
end


function [mask] = mask_a_line(Q1,Q2,pic)
% This function sets the line between Q1(x,y) and Q2(x,y) to be 1 and
% others to be 0


mask = zeros(size(pic));
x1 = Q1(1);
x2 = Q2(1);
y1 = Q1(2);
y2 = Q2(2);

% Distance (in pixels) between the two endpoints
nPoints = ceil(sqrt((x2 - x1).^2 + (y2 - y1).^2)) + 1;

% Determine x and y locations along the line
xvalues = round(linspace(x1, x2, nPoints));
yvalues = round(linspace(y1, y2, nPoints));

% Replace the relevant values within the mask
mask(sub2ind(size(mask), yvalues, xvalues)) = 1;

end