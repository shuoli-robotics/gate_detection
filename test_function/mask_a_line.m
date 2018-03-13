function [mask] = mask_a_line(Q1,Q2)
%MAKE_A_LINE Summary of this function goes here
%   Detailed explanation goes here

mask = zeros(30,30);
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

