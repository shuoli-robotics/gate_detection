function [gate_corners_x,gate_corners_y, x, y, s, best_fit, valid, height_left, height_right, angle, arm_angle_1, arm_angle_2, s_left, s_right] ...
            = fit_window_to_points_free(points, x0, y0, size0, weights,Response)
gate_corners = 0;
gate_corners_x = [0 0 0 0];
gate_corners_y = [0 0 0 0];
n_points = size(points, 1);

if(~exist('weights', 'var') || isempty(weights))
    weights = ones(n_points, 1);
end

% position, half-size, and the half-sizes of the two sides of the polygon:
%genome0 = [x0, y0, size0, size0, size0];
% should be initial point locations
%1 corner_left_top = [x-s y-s];
%2 corner_right_top = [x+s y-s];
%3 corner_right_low = [x+s y+s];
%4 corner_left_low = [x-s y+s];
genome0 = [x0-size0, y0-size0, x0+size0, y0-size0, x0+size0, y0+size0, x0-size0, y0+size0];


genome_length = length(genome0);
params = points;

n_individuals = 20;
% Population = repmat(genome0, [n_individuals, 1]) + 5 * rand(n_individuals, genome_length) - 2.5;
Population = repmat(genome0, [n_individuals, 1]) + 3 * rand(n_individuals, genome_length) - 1.5;
n_generations = 90;%was 30
best_fit = 1000000000;
best_genome = Population(1, :);
for g = 1:n_generations
    fits = zeros(1,n_individuals);
    for i = 1:n_individuals
        %fits(i) = mean_distance_to_polygon_image(Population(i, :), params);
        fits(i) = mean_distance_to_polygon_full(Population(i, :), params);
    end
    [v, ind] = min(fits);
    if(v < best_fit)
        best_genome = Population(ind, :);
        best_fit = v;
    end
    if(g < n_generations)
        Population = repmat(Population(ind, :), [n_individuals, 1]);
        %Mutation = 5 * rand(n_individuals, genome_length) - 2.5;
        Mutation = 3 * rand(n_individuals, genome_length) - 1.5;
        Population = Population + Mutation;
    end
end

% options = optimoptions(@fmincon, 'FiniteDifferenceStepSize', 0.1);
% [x, fval] = fmincon(@(x)mean_distance_to_square(genome0, params), genome0, [],[],[],[],[],[],[],options);
best_fit = best_fit / sum(weights);
x = best_genome(1);
y = best_genome(2);
s = best_genome(3);

s_left = best_genome(4);
s_right = best_genome(5);

% %1 corner_left_top = [x-s y-s];
% gate_corners_x(1) = x-s_left;
% gate_corners_y(1) = y-s_left;
% 
%  %2 corner_right_top = [x+s y-s];
% gate_corners_x(2) = x+s_right;
% gate_corners_y(2) = y-s_right;
% 
%  %3 corner_right_low = [x+s y+s];
% gate_corners_x(3) = x+s_right;
% gate_corners_y(3) = y+s_right;
% 
%  %4 corner_left_low = [x-s y+s];
% gate_corners_x(4) = x-s_left;
% gate_corners_y(4) = y+s_left;

%1 corner_left_top = [x-s y-s];
gate_corners_x(1) = best_genome(1);
gate_corners_y(1) = best_genome(2);

 %2 corner_right_top = [x+s y-s];
gate_corners_x(2) = best_genome(3);
gate_corners_y(2) = best_genome(4);

 %3 corner_right_low = [x+s y+s];
gate_corners_x(3) = best_genome(5);
gate_corners_y(3) = best_genome(6);

 %4 corner_left_low = [x-s y+s];
gate_corners_x(4) = best_genome(7);
gate_corners_y(4) = best_genome(8);
   
valid = false;
height_left = 0;
height_right = 0;
angle = 0;


arm_angle_1 = [];
arm_angle_2 = [];


