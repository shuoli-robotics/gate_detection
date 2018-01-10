function D = distances_to_square(x, y, s, P)
% function D = distances_to_square(x, y, s, P)
n_points = size(P,1);
D = zeros(n_points, 1);

Q1 = [x-s; y-s];
Q2 = [x+s; y-s];
Q3 = [x+s; y+s];
Q4 = [x-s; y+s];

for p = 1:n_points
    Point = P(p, :)';
    dists = zeros(4, 1);
    [dists(1), I, on_segment] = distance_to_segment(Q1, Q2, Point);
    [dists(2), I, on_segment] = distance_to_segment(Q2, Q3, Point);
    [dists(3), I, on_segment] = distance_to_segment(Q3, Q4, Point);
    [dists(4), I, on_segment] = distance_to_segment(Q4, Q1, Point);
    D(p) = min(dists);
end



