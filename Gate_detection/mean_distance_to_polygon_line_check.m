function d = mean_distance_to_polygon_line_check(genome, P, Response)

% decode the genome:
% x = genome(1);
% y = genome(2);
% s_width = genome(3);
% s_left = genome(4);
% s_right = genome(5);
n_points = size(P,1);
D = zeros(n_points, 1);

% determine the four points defining the polygon:
% Q1 = [x-s_width; y-s_left];
% Q4 = [x-s_width; y+s_left];
% Q2 = [x+s_width; y-s_right];
% Q3 = [x+s_width; y+s_right];

Q1 = [genome(1); genome(2)];
Q2 = [genome(3); genome(4)];
Q3 = [genome(5); genome(6)];
Q4 = [genome(7); genome(8)];

% determine for each point the closest line:
% for p = 1:n_points
%     Point = P(p, :)';
%     dists = zeros(4, 1);
%     [dists(1), I, on_segment] = distance_to_segment(Q1, Q2, Point);
%     [dists(2), I, on_segment] = distance_to_segment(Q2, Q3, Point);
%     [dists(3), I, on_segment] = distance_to_segment(Q3, Q4, Point);
%     [dists(4), I, on_segment] = distance_to_segment(Q4, Q1, Point);
%     D(p) = min(dists);
% end
% 
% % average the distance:
% d = mean(D);
cf = 0;
 [s_cf, p] = check_color_fitness_segment(Q1, Q2, Response);
    cf = cf + s_cf;
    n_points = n_points + p;
    [s_cf, p] = check_color_fitness_segment(Q2, Q3, Response);
    cf = cf + s_cf;
    n_points = n_points + p;
    [s_cf, p] = check_color_fitness_segment(Q3, Q4, Response);
    cf = cf + s_cf;
    n_points = n_points + p;
    [s_cf, p] = check_color_fitness_segment(Q4, Q1, Response);
    cf = cf + s_cf;
    n_points = n_points + p;
    d = cf%;/n_points;

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
