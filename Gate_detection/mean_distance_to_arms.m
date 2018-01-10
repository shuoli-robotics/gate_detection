function fit = mean_distance_to_arms(genome, params, x, y)
% function fit = mean_distance_to_arms(genome, params, x, y)

angle(1) = genome(1);
angle(2) = genome(2);

n_arms = size(genome, 2);
n_points = size(params,1);

length_arm = 150; % in pixels
Q1 = [x;y];
Q2 = Q1 + length_arm * [cos(angle(1)); sin(angle(1))];
Q3 = Q1 + length_arm * [cos(angle(2)); sin(angle(2))];

D1 = distances_to_segment(Q1, Q2, params);
D2 = distances_to_segment(Q1, Q3, params);
D = min([D1 D2], [], 2);

outlier_threshold = 20;
inds = find(D > outlier_threshold);
D(inds) = outlier_threshold;

fit = mean(D);