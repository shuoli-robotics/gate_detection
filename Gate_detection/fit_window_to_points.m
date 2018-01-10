function [gate_corners_x,gate_corners_y, x, y, s, best_fit, valid, height_left, height_right, angle, arm_angle_1, arm_angle_2, s_left, s_right] ...
            = fit_window_to_points(points, x0, y0, size0, weights, shape, Response)
gate_corners = 0;
gate_corners_x = [0 0 0 0];
gate_corners_y = [0 0 0 0];
n_points = size(points, 1);

if(~exist('weights', 'var') || isempty(weights))
    weights = ones(n_points, 1);
end

DISTANCE_FIT = 1;
COLOR_FIT = 2;
fit_func = DISTANCE_FIT;

SQUARE = 1;
CIRCLE = 2;
POLYGON = 3;
if(~exist('shape', 'var') || isempty(shape))
    shape = POLYGON;%SQUARE;
end

% if STICK == true, there will be a stick attached to the square / circle
STICK = false;

% if CLOCK_ARMS == true, we will search for the angles of the arms:
CLOCK_ARMS = false;

s_left = [];
s_right = [];
if(shape==POLYGON)
    % position, half-size, and the half-sizes of the two sides of the polygon:
    genome0 = [x0, y0, size0, size0, size0];
else
    % position and radius / half-size are enough:
    genome0 = [x0, y0, size0];
end
genome_length = length(genome0);
params = points;

EVOLUTION = 1;
GRADIENT = 2;
METHOD = EVOLUTION;

if(METHOD == EVOLUTION)
    n_individuals = 10;
    Population = repmat(genome0, [n_individuals, 1]) + 5 * rand(n_individuals, genome_length) - 2.5;
    n_generations = 30;%was 30
    best_fit = 1000000000;
    best_genome = Population(1, :);
    for g = 1:n_generations
        for i = 1:n_individuals
            if(fit_func == COLOR_FIT)
                fits(i) = 1-get_color_fitness(Population(i, :), Response, STICK, shape);
            else
                if(shape == SQUARE)
                    fits(i) = mean_distance_to_square(Population(i, :), params);
                elseif(shape==CIRCLE)
                    outlier_threshold = 20;
                    fits(i) = mean_distance_to_circle(Population(i, :), points, weights, STICK, outlier_threshold);
                else
                    fits(i) = mean_distance_to_polygon_image(Population(i, :), params);
                end
            end
        end
        [v, ind] = min(fits);
        if(v < best_fit)
            best_genome = Population(ind, :);
            best_fit = v;
        end
        if(g < n_generations)
            Population = repmat(Population(ind, :), [n_individuals, 1]);
            Mutation = 5 * rand(n_individuals, genome_length) - 2.5;
            Population = Population + Mutation;
        end
    end
else
    it = 0;
    dx = 2; dy = 2; ds = 2;
    genome = genome0;
    fit_genome = mean_distance_to_square(genome, params);
    best_genome = genome;
    best_fit = fit_genome;
    norm_limit = 1; % the estimate should at least get norm_limit better
    step_size = 2;
    % we only do gradient search as long as it is faster than evolution:
    while(it < floor(300 / 4 / 5) )
        
        fprintf('Iteration %d, fitness %f\n', it, fit_genome);
        
        genome_dx = genome + [dx, 0, 0];
        genome_dy = genome + [0, dy, 0];
        genome_ds = genome + [0, 0, ds];
        if(fit_func == COLOR_FIT)
            fit_dx = 1-get_color_fitness(genome_dx, Response, STICK, shape);
            fit_dy = 1-get_color_fitness(genome_dy, Response, STICK, shape);
            fit_ds = 1-get_color_fitness(genome_ds, Response, STICK, shape);
        else
            if(shape == SQUARE)
                fit_dx = mean_distance_to_square(genome_dx, params);
                fit_dy = mean_distance_to_square(genome_dy, params);
                fit_ds = mean_distance_to_square(genome_ds, params);
            else
                outlier_threshold = 20;
                fit_dx = mean_distance_to_circle(genome_dx, points, weights, STICK, outlier_threshold);
                fit_dy = mean_distance_to_circle(genome_dy, points, weights, STICK, outlier_threshold);
                fit_ds = mean_distance_to_circle(genome_ds, points, weights, STICK, outlier_threshold);
            end
        end
        fdx = fit_dx - fit_genome; % fitness change in positive direction (fitness = error)
        fdy = fit_dy - fit_genome;
        fds = fit_ds - fit_genome;
        
        v = [fdx, fdy, fds];
        if(norm(v) > norm_limit)
            step = -sign(v) * step_size;
            genome = genome + step;
            if(fit_func == COLOR_FIT)
                fit_genome = 1-get_color_fitness(genome, Response, STICK, shape);
            else
                fit_genome = mean_distance_to_square(genome, params);
            end
        else
            genome = genome + 10 * rand(1, 3) - 5;
            %             break;
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
x = best_genome(1);
y = best_genome(2);
s = best_genome(3);
if(shape == POLYGON)
    s_left = best_genome(4);
    s_right = best_genome(5);
    
    %corner_left_top = [x-s y-s];
    gate_corners_x(1) = x-s_left;
    gate_corners_y(1) = y-s_left;
    
     %corner_right_top = [x+s y-s];
    gate_corners_x(2) = x+s_right;
    gate_corners_y(2) = y-s_right;
    
     %corner_right_low = [x+s y+s];
    gate_corners_x(3) = x+s_right;
    gate_corners_y(3) = y+s_right;
    
     %corner_left_low = [x-s y+s];
    gate_corners_x(4) = x-s_left;
    gate_corners_y(4) = y+s_left;
   
        
end

if(shape == SQUARE)
    % determine the angles of the final genome:
    [valid, height_left, height_right, angle] = angle_to_gate(x, y, s, params);
else
    valid = false;
    height_left = 0;
    height_right = 0;
    angle = 0;
end

if(CLOCK_ARMS)
    % downselect the points to fall inside the detected square:
    factor = 0.6;
    x_inds = find(params(:,1) > (x - factor * s) & params(:,1) < (x + factor * s));
    y_inds = find(params(:,2) > (y - factor * s) & params(:,2) < (y + factor * s));
    inds = intersect(x_inds, y_inds);
    params = params(inds, :);
    
    % fit the clock arms:
    [arm_angle_1, arm_angle_2] = fit_clock_arms(params, x, y);
else
    arm_angle_1 = [];
    arm_angle_2 = [];
end

