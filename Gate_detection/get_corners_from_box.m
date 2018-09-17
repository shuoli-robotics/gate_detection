function [Q1, Q2, Q3, Q4] = get_corners_from_box(box)
% function [Q1, Q2, Q3, Q4] = get_corners_from_box(box)

Q1 = [box(1), box(5)];
Q2 = [box(2), box(6)];
Q3 = [box(3), box(7)];
Q4 = [box(4), box(8)];
