function d = mean_distance_to_square(genome, P)
% function d = mean_distance_to_square(genome, P)

x = genome(1);
y = genome(2);
s = genome(3);
D = distances_to_square(x, y, s, P);
d = mean(D);
% fprintf('x, y, s, d = %f, %f, %f, %f.\n', x, y, s, d);