function [x_low, y_low, x_high, y_high, Im] = snake_up_and_down(x, y, Response, graphics, Im)
% function [x_low, y_low, x_high, y_high, Im] = snake_up_and_down(x, y, Response, graphics, Im)

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

x_low = x;
x_high = x;

x_initial = x;
y_low = y;
done = false;
x_max = size(Response,2);   

while(y_low > 1 && ~done && x < x_max-1 && x>1)
    
    if(graphics)
        Im(y_low, x) = 1;
    end
    
    if(Response(y_low-1,x) > 0)
        y_low = y_low - 1;
    elseif(y_low-2>= 1 && Response(y_low-2,x) > 0)
        y_low = y_low - 2;
    elseif(x < x_max && Response(y_low-1,x+1) > 0)
        x = x + 1;
        y_low = y_low - 1;
    elseif(x>1 && Response(y_low-1,x-1) > 0)
        x = x - 1;
        y_low = y_low - 1;
    else
        done = true;
        x_low = x;
    end
end
x = x_initial;
y_high = y;
done = false;
while(y_high < size(Response,1) && ~done && x < x_max-1 && x > 1)
    
%     try
%         temp = Response(y_high+1,x+1);
%     catch
%         print('aaaaaaaaaaaaaaaaa');
%     end
    
    if(graphics)
        Im(y_high, x) = 1;
    end
    
    if(Response(y_high+1,x) > 0)
        y_high = y_high + 1;
    elseif(y_high+2 <= size(Response, 1) && Response(y_high+2,x) > 0)
        y_high = y_high+2;
    elseif(x<size(Response,2)&&Response(y_high+1,x+1) > 0)
        y_high = y_high + 1;
        x = x + 1;
    elseif(x>1&&Response(y_high+1,x-1) > 0)
        y_high = y_high + 1;
        x = x - 1;
    else
        done = true;
        x_high = x;
    end
end
