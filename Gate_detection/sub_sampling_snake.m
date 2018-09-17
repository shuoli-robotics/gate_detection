function [xs,ys,ss,n_gates, boxes] = sub_sampling_snake(Response, sample_num, minimum_length, graphics)
% function [xs,ys,ss,n_gates, boxes] = sub_sampling_snake(Response, sample_num, minimum_length, graphics)
%
% Two phases:
% 1) take random samples
% 2) if a hit, snake:
%    (a) up and down. If long enough, test two hypotheses with color
%    fitness.
%    (b) left and right. If long enough test two hypotheses with color
%    fitness.

if(~exist('sample_num', 'var') || isempty(sample_num))
    sample_num = 5000;
end
if(~exist('minimum_length', 'var') || isempty(minimum_length))
    minimum_length = 30;
end
if(~exist('graphics', 'var') || isempty(graphics))
    graphics = true;
end

DEBUG = false;

MAX_SAMPLES = sample_num; 
W = size(Response,2);
H = size(Response,1);
xs = []; ys = []; ss = []; boxes = [];
min_pixel_size = minimum_length;
%min_pixel_size = 25;

if(graphics)
    imagesc(Response);
    hold on;
end

for s = 1:MAX_SAMPLES
    
    x = 3 + floor(rand(1)*(W-8));
    y = 3 + floor(rand(1)*(H-8));
    %x = 1 + floor(rand(1)*(W-1));
    %y = 1 + floor(rand(1)*(H-1));
    
    if(Response(y,x) > 0 && y > 2 && x > 2 && x < W-2 && y < H-2)
        % only up and down:
        
        if(DEBUG)
            Im = zeros(size(Response));
            % fprintf('Initial: (%d, %d)\n', x, y);
            [x_low, y_low, x_high, y_high, Im] = snake_up_and_down(x, y, Response, true, Im);
            
            h_snake = figure();
            imagesc(Response + Im);
            hold on;
            plot(x,y, 'x','MarkerSize', 10, 'Color', [1 1 1])
            title('snaking - just up and down')
            waitforbuttonpress();
            close(h_snake);
        else 
            [x_low, y_low, x_high, y_high] = snake_up_and_down(x, y, Response);
        end
        sz = (y_high - y_low);
        y = (y_high + y_low) / 2;
        
%         if(graphics)
%             if(sz < min_pixel_size) % || y_high < size(Response,1)/2)
%                 plot([x, x], [y_low, y_high], 'Color', 'red');
%             else
%                 % plot([x, x], [y_low, y_high], 'Color', 'green', 'LineWidth', 1);
%             end
%         end
        % check if the vertical stretch is long enough:
        if(sz > min_pixel_size)
            % snake left and right:
            if(DEBUG)
                [x_low1, y_low1, x_high1, y_high1, Im] = snake_left_and_right(x_low, y_low, Response, true, Im);
                [x_low2, y_low2, x_high2, y_high2, Im] = snake_left_and_right(x_high, y_high, Response, true, Im);
            else
                [x_low1, y_low1, x_high1, y_high1] = snake_left_and_right(x_low, y_low, Response);
                [x_low2, y_low2, x_high2, y_high2] = snake_left_and_right(x_high, y_high, Response);
            end
            
            szx1 = x_high1-x_low1;
            szx2 = x_high2-x_low2;
            
            
            if(szx1 > min_pixel_size) || (szx2 > min_pixel_size)
                Q1 = [x_low1, y_low1];
                Q2 = [x_high1, y_high1];
                Q3 = [x_high2, y_high2];
                Q4 = [x_low2, y_low2];
                boxes = [boxes; get_box_from_corners(Q1, Q2, Q3, Q4)];
                
                if(DEBUG)
                    h_snake = figure();
                    imagesc(Response + Im);
                    hold on;
                    plot(x_low,y_low, 'x','MarkerSize', 10, 'Color', [1 1 1])
                    plot(x_high,y_high, 'x','MarkerSize', 10, 'Color', [1 1 1])
                    plot(Q1(1), Q1(2), 'o', 'MarkerSize', 5, 'Color', [1 0 0]);
                    plot(Q2(1), Q2(2), 'o', 'MarkerSize', 5, 'Color', [1 0 0]);
                    plot(Q3(1), Q3(2), 'o', 'MarkerSize', 5, 'Color', [1 0 0]);
                    plot(Q4(1), Q4(2), 'o', 'MarkerSize', 5, 'Color', [1 0 0]);
                    plot_square(boxes(end, :), [1 1 1], 1);
                    title('snaking')
                    waitforbuttonpress();
                    close(h_snake);
                end
            end
%             if(graphics)
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
            
%             if(szx1 > min_pixel_size)
%                 x = (x_high1 + x_low1) / 2;
%                 sz = max([sz, szx1]);%(szx1 + sz) / 2;
%                 xs = [xs; x];
%                 ys = [ys; y];
%                 ss = [ss; sz/2];
%             elseif(szx2 > min_pixel_size)
%                 x = (x_high2 + x_low2) / 2;
%                 sz = max([szx2, sz]);%(szx2 + sz) / 2;
%                 xs = [xs; x];
%                 ys = [ys; y];
%                 ss = [ss; sz/2];
%             end
              if(szx1 > min_pixel_size) && (szx2 > min_pixel_size)
                  if szx1 > szx2
                      x = (x_high1 + x_low1) / 2;
                      sz = max([sz, szx1]);%(szx1 + sz) / 2;
                      xs = [xs; x];
                      ys = [ys; y];
                      ss = [ss; sz/2];
                  else
                      x = (x_high2 + x_low2) / 2;
                      sz = max([szx2, sz]);%(szx2 + sz) / 2;
                      xs = [xs; x];
                      ys = [ys; y];
                      ss = [ss; sz/2];
                  end
              elseif (szx1 > min_pixel_size) && (szx2 < min_pixel_size)
                  x = (x_high1 + x_low1) / 2;
                  sz = max([sz, szx1]);%(szx1 + sz) / 2;
                  xs = [xs; x];
                  ys = [ys; y];
                  ss = [ss; sz/2];
              elseif (szx1 < min_pixel_size) && (szx2 > min_pixel_size)
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
     plot_square(boxes(i,:),'r',1);
%     Q1 =  [xs(i)-ss(i) ys(i)+ss(i)];
%     Q2 =  [xs(i)+ss(i) ys(i)+ss(i)];
%     Q3 =  [xs(i)+ss(i) ys(i)-ss(i)];
%     Q4 =  [xs(i)-ss(i) ys(i)-ss(i)];
%     
%     if(graphics)
%         plot([Q1(1) Q2(1)],[Q1(2) Q2(2)],'Color','r');
%         plot([Q2(1) Q3(1)],[Q2(2) Q3(2)],'Color','r');
%         plot([Q3(1) Q4(1)],[Q3(2) Q4(2)],'Color','r');
%         plot([Q4(1) Q1(1)],[Q4(2) Q1(2)],'Color','r');
%     end
end