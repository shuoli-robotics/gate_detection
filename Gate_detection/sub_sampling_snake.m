function [xs,ys,ss,n_gates] = sub_sampling_snake(Response)
% function [xs,ys,ss,n_gates] = sub_sampling_snake(Response)
%
% Two phases:
% 1) take random samples
% 2) if a hit, snake:
%    (a) up and down. If long enough, test two hypotheses with color
%    fitness.
%    (b) left and right. If long enough test two hypotheses with color
%    fitness.

global sample_num FIGURE minimun_length

SQUARE = 1;

MAX_SAMPLES = sample_num; %5000
W = size(Response,2);
H = size(Response,1);
xs = []; ys = []; ss = [];
min_pixel_size = minimun_length;
%min_pixel_size = 25;

% if(graphics)
%     figure();
%     imagesc(Response);
%     axis([90 210 20 130])
%     hold on;
% end

for s = 1:MAX_SAMPLES
    
    x = 3 + floor(rand(1)*(W-8));
    y = 3 + floor(rand(1)*(H-8));
    %x = 1 + floor(rand(1)*(W-1));
    %y = 1 + floor(rand(1)*(H-1));
    
    if(Response(y,x) > 0 && y > 2 && x > 2 && x < W-2 && y < H-2)
        % only up and down:
        [y_low, y_high] = snake_up_and_down(x, y, Response);
        sz = (y_high - y_low);
        y = (y_high + y_low) / 2;
        
%         if(graphics)
%             if(sz < min_pixel_size) % || y_high < size(Response,1)/2)
%                % plot([x, x], [y_low, y_high], 'Color', 'red');
%             else
% %                 plot([x, x], [y_low, y_high], 'Color', 'green', 'LineWidth', 1);
%                   plot([x, x], [y_low, y_high], 'Color', 'red', 'LineWidth', 1);
%             end
%         end
        % check if the vertical stretch is long enough:
        if(sz > min_pixel_size)
            % snake left and right:
            [x_low1, x_high1] = snake_left_and_right(x, y_low, Response);
            [x_low2, x_high2] = snake_left_and_right(x, y_high, Response);
            szx1 = x_high1-x_low1;
            szx2 = x_high2-x_low2;
%             if(1&&graphics)
%                 if(szx1 < min_pixel_size) % || y_high < size(Response,1)/2)
%                     plot([x_low1, x_high1], [y_low, y_low], 'Color', 'red');
%                 else
%                     plot([x_low1, x_high1], [y_low, y_low], 'Color', 'green', 'LineWidth', 1);
%                 end
%                 if(szx2 < min_pixel_size) % || y_high < size(Response,1)/2)
%                     plot([x_low2, x_high2], [y_high, y_high], 'Color', 'red');
%                 else
%                     plot([x_low2, x_high2], [y_high, y_high], 'Color', 'green', 'LineWidth', 1);
%                 end
%             end
            
            if(szx1 > min_pixel_size)
                x = (x_high1 + x_low1) / 2;
                sz = max([sz, szx1]);%(szx1 + sz) / 2;
                xs = [xs; x];
                ys = [ys; y];
                ss = [ss; sz/2];
            elseif(szx2 > min_pixel_size)
                x = (x_high2 + x_low2) / 2;
                sz = max([szx2, sz]);%(szx2 + sz) / 2;
                xs = [xs; x];
                ys = [ys; y];
                ss = [ss; sz/2];
            end
        end
    end
end

n_gates = length(xs);

for i = 1:n_gates
    Q1 =  [xs(i)-ss(i) ys(i)+ss(i)];
    Q2 =  [xs(i)+ss(i) ys(i)+ss(i)];
    Q3 =  [xs(i)+ss(i) ys(i)-ss(i)];
    Q4 =  [xs(i)-ss(i) ys(i)-ss(i)];
    
    if FIGURE == 1
        figure(1)
        plot([Q1(1) Q2(1)],[Q1(2) Q2(2)],'Color','r');
        plot([Q2(1) Q3(1)],[Q2(2) Q3(2)],'Color','r');
        plot([Q3(1) Q4(1)],[Q3(2) Q4(2)],'Color','r');
        plot([Q4(1) Q1(1)],[Q4(2) Q1(2)],'Color','r');
    end
end