
function [x_low, x_high] = snake_left_and_right(x, y, Response)
% function [x_low, x_high] = snake_left_and_right(x, y, Response)

y_initial = y;
x_low = x;
done = false;
while(x_low > 1 && ~done)
    if(Response(y,x_low-1) > 0)
        x_low = x_low - 1;
    elseif(y < size(Response,1) && Response(y+1,x_low-1) > 0)
        y = y + 1;
        x_low = x_low - 1;
    elseif(y > 1 && Response(y-1,x_low-1) > 0)
        y = y - 1;
        x_low = x_low - 1;
    else
        done = true;
    end
end
x_high = x;
y = y_initial;
done = false;
while(x_high < size(Response,2) && ~done)
    if(Response(y,x_high+1) > 0)
        x_high = x_high + 1;
    elseif(y<size(Response,1) && Response(y+1,x_high+1) > 0)
        x_high = x_high + 1;
        y = y + 1;
    elseif(y > 1 && Response(y-1,x_high+1) > 0)
        x_high = x_high + 1;
        y = y - 1;
    else
        done = true;
    end
end