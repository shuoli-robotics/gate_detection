function d = mean_distance_to_squares(genome, P, W, STICK)
% function d = mean_distance_to_squares(genome, P, W, STICK)

outlier_threshold = 200;
n_genomes = length(genome) / 3;
n_points = size(P,1);
D = zeros(n_genomes, n_points);

graphics = false;
if(graphics)
    figure();
    hold on;
    for p = 1:n_points
        plot(P(p,1), P(p,2), 'x', 'Color', 'red', 'MarkerSize', W(p));
    end
end

for g = 1:n_genomes
    
    x = genome((g-1)*3+1);
    y = genome((g-1)*3+2);
    s = genome((g-1)*3+3);
    
    Q1 = [x-s; y-s];
    Q2 = [x+s; y-s];
    Q3 = [x+s; y+s];
    Q4 = [x-s; y+s];
    if(STICK)
        % stick starts at the bottom of the circle and is size s long
        stick1 = [x; y+s];
        stick2 = [x; y+2*s];
    end

    
    for p = 1:n_points
        Point = P(p, :)';
        dists = zeros(4, 1);
        [dists(1), I, on_segment] = distance_to_segment(Q1, Q2, Point);
        [dists(2), I, on_segment] = distance_to_segment(Q2, Q3, Point);
        [dists(3), I, on_segment] = distance_to_segment(Q3, Q4, Point);
        [dists(4), I, on_segment] = distance_to_segment(Q4, Q1, Point);
        D(g, p) = min(dists);
        if(STICK)
            DS = distance_to_segment(stick1, stick2, Point);
            if(D(g,p) > DS)
                D(g,p) = DS;
            end
        end
        D(g,p) = D(g,p) * W(p);
    end
end

% count the distance to the closest window:
D = min(D);
% set outliers to a fixed threshold:
inds = find(D > outlier_threshold);
if(~isempty(inds))
    D(inds) = outlier_threshold;
end
d = mean(D);