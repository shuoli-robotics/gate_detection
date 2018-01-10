function [valid, height_left, height_right, angle] = angle_to_gate(x, y, s, P)
% function [valid, height_left, height_right, angle] = angle_to_gate(x, y, s, P)
n_points = size(P,1);

outlier_threshold = 20;

highest_left = 0;
lowest_left = max(P(:,2));
highest_right = 0;
lowest_right = max(P(:,2));

Q1 = [x-s; y-s];
Q2 = [x+s; y-s];
Q3 = [x+s; y+s];
Q4 = [x-s; y+s];

% the angle measurement is only valid if we have measurements of the height
% left and right of the gate:
valid = [0 0 0 0];

for p = 1:n_points
    Point = P(p, :)';
    dists = zeros(2, 1);
    [dists(1), I, on_segment] = distance_to_segment(Q2, Q3, Point);
    [dists(2), I, on_segment] = distance_to_segment(Q4, Q1, Point);
    [D(p), ind] = min(dists);
    if(ind == 1 && P(p,2) < lowest_right)
        lowest_right = P(p,2);
        valid(1) = 1;
    end
    if(ind == 1 && P(p,2) > highest_right)
        highest_right = P(p,2);
        valid(2) = 1;
    end
    if(ind == 2 && P(p,2) < lowest_left)
        lowest_left = P(p,2);
        valid(3) = 1;
    end
    if(ind == 2 && P(p,2) > highest_left)
        highest_left = P(p,2);
        valid(4) = 1;
    end
end

valid = sum(valid) == 4;
height_left = highest_left - lowest_left;
height_right = highest_right - lowest_right;
% TODO: actually calculate this mathematically:
angle = height_left / height_right;

