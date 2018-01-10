function [HSV_pixels, Y] = sample_HSV_pixels(HSV, n_pixels_image)
% function [HSV_pixels, Y] = sample_HSV_pixels(HSV, n_pixels_image)

W = size(HSV,2);
H = size(HSV,1);
HSV_pixels = zeros(n_pixels_image, 3);
Y = zeros(n_pixels_image, 1);
for p = 1:n_pixels_image
    x = 1 + floor(rand(1) * (W-1));
    y = 1 + floor(rand(1) * (H-1));
    Y(p) = y;
    HSV_pixels(p, :) = HSV(y,x,:);
end