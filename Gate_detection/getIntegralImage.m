function II = getIntegralImage(Im)
% function II = getIntegralImage(Im)

II = zeros(size(Im,1), size(Im,2));
for x = 1:size(Im,2)
    for y = 1:size(Im,1)
        if(x-1 > 0 && y-1 > 0)
            II(y,x) = II(y,x-1) + II(y-1,x) - II(y-1,x-1) + Im(y,x);
        elseif(x-1 > 0)
            II(y,x) = II(y,x-1) + Im(y,x);
        elseif(y-1 > 0)
            II(y,x) = II(y-1,x) + Im(y,x);
        else
            II(y,x) = Im(y,x);
        end
    end
end