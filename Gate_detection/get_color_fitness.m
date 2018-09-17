function cf = get_color_fitness(genome, Response, STICK, SHAPE)
% function cf = get_color_fitness(genome, Response, STICK, SHAPE)

min_size = 20;

SQUARE = 1;
CIRCLE = 2;
POLYGON = 3;

x = genome(1);
y = genome(2);
r = genome(3);

% We go over the shape and determine what portion of points is colored in
% the image:

cf = 0;
n_points = 0;

if(SHAPE == CIRCLE)
    for t = 0:0.01:2*pi
        xx = round(x + cos(t) * r);
        yy = round(y + sin(t) * r);
        if(xx >= 1 && xx <= size(Response, 2) && yy >= 1 && yy <= size(Response, 1))
            n_points = n_points + 1;
            if(Response(yy,xx) > 0)
                cf = cf + 1;
            end
        end
    end
else
    if(SHAPE == SQUARE)
        % all corner points:
        Q1 = [x-r; y-r];
        Q2 = [x+r; y-r];
        Q3 = [x+r; y+r];
        Q4 = [x-r; y+r];
    else
       % genome is now organized as a box:
       Q1 = [genome(1), genome(5)];
       Q2 = [genome(2), genome(6)];
       Q3 = [genome(3), genome(7)];
       Q4 = [genome(4), genome(8)];
    end
    
    [s_cf, p] = check_color_fitness_segment(Q1, Q2, Response);
    cf = cf + s_cf;
    n_points = n_points + p;
    [s_cf, p] = check_color_fitness_segment(Q2, Q3, Response);
    cf = cf + s_cf;
    n_points = n_points + p;
    [s_cf, p] = check_color_fitness_segment(Q3, Q4, Response);
    cf = cf + s_cf;
    n_points = n_points + p;
    [s_cf, p] = check_color_fitness_segment(Q4, Q1, Response);
    cf = cf + s_cf;
    n_points = n_points + p;
end

% if(r < min_size)
%     cf = 0;
% end

if(STICK)
    Q1 = [x; y-r];
    Q2 = [x; y-2*r];
    [s_cf, p] = check_color_fitness_segment(Q1, Q2, Response);
    cf = cf + s_cf;
    n_points = n_points + p;
end

% ratio of colored points:
cf = cf / n_points;

