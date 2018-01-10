function [d, I, on_segment] = distance_to_segment(Q1, Q2, P)
% function distance_to_segment(Q1, Q2, P)
% http://mathworld.wolfram.com/Point-LineDistance2-Dimensional.html
% all points are column vectors

% Q, etc. column vectors:
% distance:
d = abs(det([Q2-Q1,P-Q1]))/norm(Q2-Q1);

% intersection point I:
r = [Q2(2)-Q1(2); -(Q2(1) - Q1(1))];
r = d * (r / norm(r));
I = r + P;
dI = abs(det([Q2-Q1,I-Q1]))/norm(Q2-Q1);
if(dI > 1e-10) % lame way of determining direction, but hey...
    I = -r + P;
end

% on segment?
d1 = norm(Q1-I);
d2 = norm(Q2-I);
d_12 = norm(Q1-Q2);
if(d1 > d_12 || d2 > d_12)
    on_segment = false;
    % not on the line segment:
    d1 = norm(Q1 - P);
    d2 = norm(Q2 - P);
    d = min([d1, d2]);
else
    on_segment = true;
end

