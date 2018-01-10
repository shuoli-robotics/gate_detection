function D = distances_to_circle(x, y, r, points)
% function D = distances_to_circle(x, y, r, points)

n_points = size(points, 1);
D = zeros(n_points, 1);
for p = 1:n_points
    dx = points(p,1) - x;
    dy = points(p,2) - y;
    dist_center = sqrt(dx*dx+dy*dy);
    D(p) = abs(dist_center - r);
end