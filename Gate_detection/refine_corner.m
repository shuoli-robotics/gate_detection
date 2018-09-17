function [refined_corner] = refine_corner(corner,sz,Response,s_factor,graphics)
% function [refined_corner] = refine_corner(corner,sz,Response,s_factor,graphics)

if(~exist('graphics', 'var') || ~isempty(graphics))
    graphics = false;
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

x_size = x_h-x_l+1;
y_size = y_h-y_l+1;

x_hist = zeros(1,x_size);
y_hist = zeros(1,y_size);

%Response(50,200)
best_x = 0;
best_x_loc = x_l;
x_best_start = x_l;
best_y = 0;
best_y_loc = y_l;
y_best_start = y_l;

% just take the highest peak:
for y_pix = y_l:y_h
    for x_pix = x_l:x_h
        if(Response(y_pix,x_pix)>0)
            
            cur_x = x_hist(x_pix-x_l+1);
            cur_y = y_hist(y_pix-y_l+1);
            
            if(cur_x > best_x)
                best_x = cur_x;
                best_x_loc = x_pix;
                x_best_start = x_pix;
            elseif(cur_x == best_x)
                best_x_loc = round((x_pix+x_best_start)/2);
            end
            if(cur_y > best_y)
                best_y = cur_y;
                best_y_loc = y_pix;
                y_best_start = y_pix;
            elseif(cur_y == best_y)
                best_y_loc = round((y_pix+y_best_start)/2);
            end
            
            x_hist(x_pix-x_l+1) = cur_x+1;
            y_hist(y_pix-y_l+1) = cur_y+1;
        end
    end
end

refined_corner = [best_x_loc,best_y_loc];

if(graphics)
    h1 = figure()
    imagesc(Response);
    hold on;
    rectangle2(h1, x_l, y_l, x_h, y_h, [0.75 0 0.75])
    plot(best_x_loc, best_y_loc, 'x', 'Color', [0.75 0 0.75]);
end


if(graphics)
    h2 = figure();
    ROI = Response(y_l:y_h, x_l:x_h);
    hist_x = sum(ROI);
    hist_y = sum(ROI,2);
    subplot(1,2,1);
    bar(hist_x);
    title('hist_x');
    subplot(1,2,2);
    bar(hist_y);
    title('hist_y');
    waitforbuttonpress();
    close(h1); close(h2);
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

