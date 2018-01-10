function D = distances_to_segment(Q1, Q2, P)
% function D = distances_to_segment(Q1, Q2, P)

n_points = size(P,1);
D = zeros(n_points, 1);
for p = 1:n_points
    [d, I, on_segment] = distance_to_segment(Q1, Q2, P(p,:)');
    D(p) = d;
end

