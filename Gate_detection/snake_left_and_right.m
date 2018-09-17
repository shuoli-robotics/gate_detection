function [x_low, y_low, x_high, y_high, Im] = snake_left_and_right(x, y, Response, graphics, Im)
% function [x_low, y_low, x_high, y_high, Im] = snake_left_and_right(x, y, Response, graphics, Im)

if(~exist('graphics', 'var') || isempty(graphics))
    graphics = false;
end
if(~exist('Im', 'var') || isempty(Im))
    if(graphics)
        Im = zeros(size(Response));
    else
        Im = [];
    end
end

y_initial = y;
y_low = y;
y_high = y;
x_low = x;
done = false;
while(x_low > 1 && ~done)
    if(graphics)
        Im(y,x_low) = 1;
    end
    if(Response(y,x_low-1) > 0)
        x_low = x_low - 1;
    elseif(x_low-2 >= 1 && Response(y,x_low-2) > 0)
        x_low = x_low - 2;
    elseif(y < size(Response,1) && Response(y+1,x_low-1) > 0)
        y = y + 1;
        x_low = x_low - 1;
    elseif(y > 1 && Response(y-1,x_low-1) > 0)
        y = y - 1;
        x_low = x_low - 1;
    else
        done = true;
        y_low = y;
    end
end
x_high = x;
y = y_initial;
done = false;
while(x_high < size(Response,2) && ~done)
    if(graphics)
        Im(y,x_high) = 1;
    end
    if(Response(y,x_high+1) > 0)
        x_high = x_high + 1;
    elseif(x_high+2 < size(Response, 2) && Response(y,x_high+2) > 0)
        x_high = x_high + 2;
    elseif(y<size(Response,1) && Response(y+1,x_high+1) > 0)
        x_high = x_high + 1;
        y = y + 1;
    elseif(y > 1 && Response(y-1,x_high+1) > 0)
        x_high = x_high + 1;
        y = y - 1;
    else
        done = true;
        y_high = y;
    end
end