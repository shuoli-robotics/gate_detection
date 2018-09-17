function box = get_box_from_corners(Q1, Q2, Q3, Q4)
% function box = get_box_from_corners(Q1, Q2, Q3, Q4)
%
% These corners have to be ordered from top-left clock-wise

box = [Q1(1) Q2(1) Q3(1) Q4(1) Q1(2) Q2(2) Q3(2) Q4(2)];