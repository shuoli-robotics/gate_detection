function test_integral_feature(Response, area_width, border_width, step, graphics)
% function test_integral_feature(Response, area_width, border_width, step, graphics)

if(~exist('graphics', 'var') || isempty(graphics))
    graphics = true;
end

if(length(size(Response)) >= 3)
    Response = rgb2gray(Response);
end

II = getIntegralImage(Response);

TOP_LEFT = 1;

min_response = 1000000;
min_x = 0;
min_y = 0;
min_xx = 0;
min_yy = 0;

xx = 0;
for x = 1:step:size(II,2)-area_width
    xx = xx + 1;
    yy = 0;
    for y = 1:step:size(II,1)-area_width
        yy = yy + 1;
        type = TOP_LEFT;
        RF(yy,xx) = get_II_corner_feature(II, x, y, type, area_width, border_width);
        if(RF(yy,xx) < min_response)
            fprintf('(xx,yy) = (%d, %d), (x,y) = (%d, %d), value = %f\n', xx, yy, min_x, min_y, RF(yy,xx));
            min_response = RF(yy,xx);
            min_xx = xx;
            min_yy = yy;
            min_x = x+round(area_width/2);
            min_y = y+round(area_width/2);
        end
    end
end

h = figure();
imagesc(RF);
hold on;
plot(min_xx, min_yy, 'x', 'MarkerSize', 10, 'Color', [1 1 1], 'LineWidth', 3)
waitforbuttonpress();
close(h);

h = figure();
imagesc(Response);
hold on;
plot(min_x, min_y, 'x', 'MarkerSize', 10, 'Color', [1 1 1], 'LineWidth', 3)
waitforbuttonpress();
close(h);
