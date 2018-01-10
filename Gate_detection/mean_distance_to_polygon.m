function fit = mean_distance_to_polygon(im_coords, visible, P, weights)
% function fit = mean_distance_to_polygon(im_coords, visible, P, weights)

n_points = size(P,1);
D = zeros(n_points, 1);

Q1 = im_coords(1,:)';
Q2 = im_coords(2,:)';
Q3 = im_coords(3,:)';
Q4 = im_coords(4,:)';

for p = 1:n_points
    Point = P(p, :)';
    LARGE = 100000000;
    dists = LARGE * ones(4,1);
    if(visible(1) && visible(2))
        [dists(1), I, on_segment] = distance_to_segment(Q1, Q2, Point);
    end
    if(visible(2) && visible(3))
        [dists(2), I, on_segment] = distance_to_segment(Q2, Q3, Point);
    end
    if(visible(3) && visible(4))
        [dists(3), I, on_segment] = distance_to_segment(Q3, Q4, Point);
    end
    if(visible(4) && visible(1))
        [dists(4), I, on_segment] = distance_to_segment(Q4, Q1, Point);
    end
    D(p) = min(dists);
end

outlier_threshold = 20;%was 20
inds = D > outlier_threshold;
D(inds) = outlier_threshold;
D = D .* weights;
fit = mean(D);
