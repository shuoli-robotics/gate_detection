function d = mean_distance_to_circle(genome, P, W, STICK, outlier_threshold)
% function d = mean_distance_to_circle(genome, P, W, STICK, outlier_threshold)

x = genome(1);
y = genome(2);
s = genome(3);
DC = distances_to_circle(x, y, s, P);
if(STICK)
    % stick starts at the bottom of the circle and is size s long
    stick1 = [x; y+s];
    stick2 = [x; y+2*s];
    DS = distances_to_segment(stick1, stick2, P);
    D = min([DC, DS], [], 2);
else
    % no stick:
    D = DC;
end

inds = find(D > outlier_threshold);
D(inds) = outlier_threshold;

d = mean(D .* W);