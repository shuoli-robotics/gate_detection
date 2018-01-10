function [P,W] = convert_response_to_points(R)
% function [P, W] = convert_response_to_points(R)

P = [];
W = [];

for y = 1:size(R,1)
    for x = 1:size(R, 2);
        if(R(y,x) > 0)
            P = [P; [x, y]];
            weight = R(y,x);
            W = [W; weight];
        end
    end
end