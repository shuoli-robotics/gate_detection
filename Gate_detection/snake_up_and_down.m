function [y_low, y_high] = snake_up_and_down(x, y, Response)
% function [y_low, y_high] = snake_up_and_down(x, y, Response)

x_initial = x;
y_low = y;
done = false;
x_max = 312;

   

while(y_low > 1 && ~done && x < x_max-1 && x>1)
    if(Response(y_low-1,x) > 0)
        y_low = y_low - 1;
    elseif(x < x_max && Response(y_low-1,x+1) > 0)
        x = x + 1;
        y_low = y_low - 1;
    elseif(x>1 && Response(y_low-1,x-1) > 0)
        x = x - 1;
        y_low = y_low - 1;
    else
        done = true;
    end
end
x = x_initial;
y_high = y;
done = false;
while(y_high < size(Response,1) && ~done && x < x_max-1 && x > 1)
    
    try
        temp = Response(y_high+1,x+1);
    catch
        print('aaaaaaaaaaaaaaaaa');
    end
    
    if(Response(y_high+1,x) > 0)
        y_high = y_high + 1;
    elseif(x<size(Response,2)&&Response(y_high+1,x+1) > 0)
        y_high = y_high + 1;
        x = x + 1;
    elseif(x>1&&Response(y_high+1,x-1) > 0)
        y_high = y_high + 1;
        x = x - 1;
    else
        done = true;
    end
end
