function [refined_corner] = refine_corner_IntegralImage(corner, sz, Response, s_factor, corner_type, area_width, border_width, step, graphics)
% function [refined_corner] = refine_corner_IntegralImage(corner, sz, Response, s_factor, corner_type, area_width, border_width, step, graphics)

if(~exist('graphics', 'var') || ~isempty(graphics))
    graphics = false;
end
if(~exist('corner_type', 'var') || isempty(corner_type))
    TOP_LEFT = 1;
    corner_type = TOP_LEFT;
end

W = size(Response, 2);
H = size(Response, 1);

x_round_l = round(corner(1) - sz * s_factor);
x_round_h = round(corner(1) + sz * s_factor);
y_round_l = round(corner(2) - sz * s_factor);
y_round_h = round(corner(2) + sz * s_factor);

[x_l, y_l] = check_coordinate(x_round_l, y_round_l, W, H);
[x_h, y_h] = check_coordinate(x_round_h, y_round_h, W, H);

Q1_s1 = [x_l; y_l];
Q1_s2 = [x_h; y_l];
Q1_s3 = [x_h; y_h];
Q1_s4 = [x_l; y_h];
color = [1 0 0];

II = getIntegralImage(Response);


min_response = 1000000;
min_x = 0;
min_y = 0;
min_xx = 0;
min_yy = 0;

xx = 0;
for x = x_l:step:x_h
    xx = xx + 1;
    yy = 0;
    for y = y_l:step:y_h
        yy = yy + 1;
        if(x + area_width <= W && y + area_width <= H)
            RF(yy,xx) = get_II_corner_feature(II, x, y, corner_type, area_width, border_width);
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
end

best_x_loc = min_x;
best_y_loc = min_y;
refined_corner = [min_x,min_y];

if(graphics)
    h1 = figure();
    imagesc(RF);
    hold on;
    plot(min_xx, min_yy, 'x', 'MarkerSize', 10, 'Color', [1 1 1], 'LineWidth', 3)
    title('Local response to integral feature');
    
    h2 = figure();
    imagesc(Response);
    hold on;
    rectangle2(h2, x_l, y_l, x_h, y_h, [0.75 0 0.75])
    plot(best_x_loc, best_y_loc, 'x', 'MarkerSize', 10, 'Color', [1 1 1], 'LineWidth', 3);
    title('Location of the corner in the image');
    waitforbuttonpress();
    close(h1);  close(h2);
end


%    color = [0 1 0];
%     plot([Q1_s1(1) Q1_s2(1)], [best_y_loc, best_y_loc], 'Color', color, 'LineWidth', 2);
%     plot([best_x_loc, best_x_loc], [Q1_s2(2), Q1_s3(2)], 'Color', color, 'LineWidth', 2);
%
%     plot([Q1_s1(1) Q1_s2(1)], [Q1_s1(2), Q1_s2(2)], 'Color', color, 'LineWidth', 2);
%     plot([Q1_s2(1) Q1_s3(1)], [Q1_s2(2), Q1_s3(2)], 'Color', color, 'LineWidth', 2);
%     plot([Q1_s3(1) Q1_s4(1)], [Q1_s3(2), Q1_s4(2)], 'Color', color, 'LineWidth', 2);
%     plot([Q1_s4(1) Q1_s1(1)], [Q1_s4(2), Q1_s1(2)], 'Color', color, 'LineWidth', 2);
end

