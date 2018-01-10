function [x, y, s, best_fit] = fit_2windows_to_points(points, x0, y0, size0, weights, shape)

n_points = size(points, 1);

if(~exist('weights', 'var') || isempty(weights))
    weights = ones(n_points, 1);
end

SQUARE = 1;
CIRCLE = 2;
if(~exist('shape', 'var') || isempty(shape))
    shape = SQUARE;
end

% if STICK == true, there will be a stick attached to the square / circle
STICK = true;

genome0 = [0.5*x0, y0, size0, 1.5*x0, y0, size0];
n_genomes = length(genome0) / 3;
params = points;

n_individuals = 10;
Population = repmat(genome0, [n_individuals, 1]) + 5 * rand(n_individuals, n_genomes*3) - 2.5;
n_generations = 30;
best_fit = 1000000000;
best_genome = Population(1, :);
for g = 1:n_generations
    for i = 1:n_individuals
        if(shape == SQUARE)
            fits(i) = mean_distance_to_squares(Population(i, :), params, weights, STICK);
        else
            outlier_threshold = 20;
            fits(i) = mean_distance_to_circle(Population(i, :), points, weights, STICK, outlier_threshold);
        end
    end
    [v, ind] = min(fits);
    fprintf('Generation %d, best fit = %f\n', g, v);
    if(v < best_fit)
        best_genome = Population(ind, :);
        best_fit = v;
    end
    if(g < n_generations)
        Population = repmat(Population(ind, :), [n_individuals, 1]);
        Mutation = 5 * rand(n_individuals, n_genomes*3) - 2.5;
        Population = Population + Mutation;
    end
end
% options = optimoptions(@fmincon, 'FiniteDifferenceStepSize', 0.1);
% [x, fval] = fmincon(@(x)mean_distance_to_square(genome0, params), genome0, [],[],[],[],[],[],[],options);
best_fit = best_fit / sum(weights);
x = best_genome(1:3:end); 
y = best_genome(2:3:end);
s = best_genome(3:3:end);