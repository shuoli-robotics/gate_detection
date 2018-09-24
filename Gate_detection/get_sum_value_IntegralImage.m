function sum_val = get_sum_value_IntegralImage(II, x, y, sz_x, sz_y)
% function sum_val = get_sum_value_IntegralImage(II, x, y, sz_x, sz_y)
sum_val = II(y+sz_y, x+sz_x) + II(y,x) - II(y, x+sz_x) - II(y+sz_y, x);
