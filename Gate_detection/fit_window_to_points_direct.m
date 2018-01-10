function [X, Y, Z, psi, best_fit] = fit_window_to_points_direct(points, X0, Y0, Z0, psi0, weights, Response)

n_points = size(points, 1);

if(~exist('weights', 'var') || isempty(weights))
    weights = ones(n_points, 1);
end

DISTANCE_FIT = 1;
COLOR_FIT = 2;
fit_func = DISTANCE_FIT;

SQUARE = 1;
if(~exist('shape', 'var') || isempty(shape))
    shape = SQUARE;
end

% if STICK == true, there will be a stick attached to the square / circle
STICK = false;

genome0 = [X0, Y0, Z0, psi0];
genome_length = length(genome0);
params = points;

EVOLUTION = 1;
GRADIENT = 2;
METHOD = GRADIENT;

if(METHOD == EVOLUTION)
    n_individuals = 30;
    % Population = repmat(genome0, [n_individuals, 1]) + repmat(change_range, [n_individuals,1]) .* rand(n_individuals, genome_length) - 0.5 * repmat(change_range, [n_individuals,1]);
    Population = repmat(genome0, [n_individuals, 1]);
    Population = mutate_population(Population);
    n_generations = 30;
    best_fit = 1000000000;
    best_genome = Population(1, :);
    for g = 1:n_generations
        for i = 1:n_individuals
            if(fit_func == COLOR_FIT)
                fits(i) = 0; % 1-get_color_fitness(Population(i, :), Response, STICK, shape);
            else
                fits(i) = mean_distance_to_polygon_direct(Population(i,:), params, weights);
            end
        end
        [v, ind] = min(fits);
        fprintf('Generation %d, fitness %f\n', g, v);
        if(v < best_fit)
            best_genome = Population(ind, :);
            best_fit = v;
        end
        if(g < n_generations)
            Population = mutate_population(Population);
            %             Population = repmat(Population(ind, :), [n_individuals, 1]);
            %             Mutation = repmat(change_range, [n_individuals,1]) .* rand(n_individuals, genome_length) - 0.5 * repmat(change_range, [n_individuals,1]);
            %             Population = Population + Mutation;
        end
    end
else
    it = 0;
    dx = 0.1; dy = 0.1; dz = 0.1; dpsi = 0.05 * pi;
    genome = genome0;
    fit_genome = mean_distance_to_polygon_direct(genome, params, weights);
    best_genome = genome;
    best_fit = fit_genome;
    norm_limit = 1; % the estimate should at least get norm_limit better
    step_size = 0.5 * [0.1, 0.1, 0.1, 0.05*pi];
    % we only do gradient search as long as it is faster than evolution:
    while(it < floor(300 / 4 / 5) )
        
        fprintf('Iteration %d, fitness %f\n', it, fit_genome);
        
        if(false)%mod(it,2) == 0)
            genome_dx = genome + [dx, 0, 0, 0];
            genome_dy = genome + [0, dy, 0, 0];
            genome_dz = genome + [0, 0, dz, 0];
            genome_dpsi = genome + [0, 0, 0, dpsi];
            
            fit_dx = mean_distance_to_polygon_direct(genome_dx, params, weights);
            fit_dy = mean_distance_to_polygon_direct(genome_dy, params, weights);
            fit_dz = mean_distance_to_polygon_direct(genome_dz, params, weights);
            fit_dpsi = mean_distance_to_polygon_direct(genome_dpsi, params, weights);
            fdx = fit_dx - fit_genome; % fitness change in positive direction (fitness = error)
            fdy = fit_dy - fit_genome;
            fdz = fit_dz - fit_genome;
            fdpsi = fit_dpsi - fit_genome;
            
            v = [fdx, fdy, fdz, fdpsi];
            if(norm(v) > norm_limit)
                step = -sign(v) .* step_size;
                genome = genome + step;
                fit_genome = mean_distance_to_polygon_direct(genome, params, weights);
            else
                genome = genome + step_size .* rand(1, genome_length) - 0.5 * step_size;
            end
        else
            step_beta = 0.01*pi;
            d_beta = step_beta;
            % X_new = -cos(rotation)* BX;
            X_new = -cos(d_beta)* -genome(1);
            % DY = sin(rotation) * BX;
            DY = sin(d_beta) * -genome(1);
            Y_new = genome(2) + DY;
            % tan(psi) = (Y_old - Y_new) / (-X_new)
            genome_dbeta(4) = atan2(genome(2)-Y_new, -X_new);
            genome_dbeta(1) = X_new;
            genome_dbeta(2) = Y_new;
            genome_dbeta(3) = genome(3);
            fit_dbeta = mean_distance_to_polygon_direct(genome_dbeta, params, weights);
            fdbeta = fit_dbeta - fit_genome; 
            step = -sign(fdbeta) .* step_beta;
            genome = genome + step;
            fit_genome = mean_distance_to_polygon_direct(genome, params, weights);
        end
        if(fit_genome < best_fit)
            best_genome = genome;
            best_fit = fit_genome;
        end
        
        it = it + 1;
    end
end
% options = optimoptions(@fmincon, 'FiniteDifferenceStepSize', 0.1);
% [x, fval] = fmincon(@(x)mean_distance_to_square(genome0, params), genome0, [],[],[],[],[],[],[],options);
best_fit = best_fit / sum(weights);
X = best_genome(1); 
Y = best_genome(2);
Z = best_genome(3);
psi = best_genome(4);


figure();
plot(points(:,1), points(:,2), 'x');
hold on;
[im_coords, visible] = translate_direct_genome_to_image_coords(best_genome);
plot_im_coords(im_coords);

function Population = mutate_population(Population)
% function Population = mutate_population(Population)

change_range = [0.5, 0.5, 0.5, 0.5*pi];
p1 = 0.01;
for i = 1:size(Population,1)
    r = rand(1);
    if(r < p1)
        % change in the "normal" way
        Population(i,:) = Population(i,:) + rand(1,4) .* change_range - 0.5 .* change_range;
    else
        % rotate it around a point that keeps the gate in the same
        % location:
        rotation = rand(1) * change_range(4) - 0.5 * change_range(4);
        % X_new = -cos(rotation)* BX;
        X_new = -cos(rotation)* -Population(i,1);
        % DY = sin(rotation) * BX;
        DY = sin(rotation) * -Population(i,1);
        Y_new = Population(i,2) + DY;
        % tan(psi) = (Y_old - Y_new) / (-X_new)
        Population(i,4) = atan2(Population(i,2)-Y_new, -X_new);
        Population(i,1) = X_new;
        Population(i,2) = Y_new;
    end
end

