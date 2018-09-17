function [s_cf, p] = check_color_fitness_segment(Q1, Q2, Response)
% function [s_cf, p] = check_color_fitness_segment(Q1, Q2, Response)
s_cf = 0;
p = 0;
for t = 0:0.01:1
    xx = round(t*Q1(1) + (1-t)*Q2(1));
    yy = round(t*Q1(2) + (1-t)*Q2(2));
    if(xx >= 1 && xx <= size(Response, 2) && yy >= 1 && yy <= size(Response, 1))
        p = p + 1;
        if(Response(yy,xx) > 0)
            s_cf = s_cf + 1;
        end
    end
end
