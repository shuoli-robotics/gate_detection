function d = mean_distance_to_polygon_image(genome, P)

% decode the genome:
x = genome(1);
y = genome(2);
s_width = genome(3);
s_left = genome(4);
s_right = genome(5);
n_points = size(P,1);
D = zeros(n_points, 1);

% determine the four points defining the polygon:
Q1 = [x-s_width; y-s_left];
Q4 = [x-s_width; y+s_left];
Q2 = [x+s_width; y-s_right];
Q3 = [x+s_width; y+s_right];

% determine for each point the closest line:
for p = 1:n_points
    Point = P(p, :)';
    dists = zeros(4, 1);
    [dists(1), I, on_segment] = distance_to_segment(Q1, Q2, Point);
    [dists(2), I, on_segment] = distance_to_segment(Q2, Q3, Point);
    [dists(3), I, on_segment] = distance_to_segment(Q3, Q4, Point);
    [dists(4), I, on_segment] = distance_to_segment(Q4, Q1, Point);
    D(p) = min(dists);
end

% average the distance:
d = mean(D);


