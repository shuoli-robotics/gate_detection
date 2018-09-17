function [Q1, Q2, Q3, Q4] = get_corners_from_initial_detection(x_center, y_center, half_size_window)
% function [Q1, Q2, Q3, Q4] = get_corners_from_initial_detection(x_center, y_center, half_size_window)
Q1 = [x_center-half_size_window; y_center-half_size_window];
Q2 = [x_center+half_size_window; y_center-half_size_window];
Q3 = [x_center+half_size_window; y_center+half_size_window];
Q4 = [x_center-half_size_window; y_center+half_size_window];