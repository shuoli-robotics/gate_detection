function response = get_II_corner_feature(II, x, y, type, area_width, border_width)
% function response = get_II_corner_feature(II, x, y, type, area_width, border_width)

TOP_LEFT = 1;
TOP_RIGHT = 2;

response = 0;

half_area_width = round(area_width / 2);
half_border_width = round(border_width / 2);

sum_total_area = get_sum_value_IntegralImage(II, x, y, area_width, area_width);
if(type == TOP_LEFT || type == TOP_RIGHT)
    sum_vertical = get_sum_value_IntegralImage(II, x+half_area_width-half_border_width, ...
        y+half_area_width-half_border_width, border_width, half_area_width+half_border_width);
    if(type == TOP_LEFT)
        sum_horizontal = get_sum_value_IntegralImage(II, x+half_area_width+half_border_width, ...
            y+half_area_width-half_border_width, half_area_width-half_border_width, border_width);
        response = sum_total_area - 2 * (sum_horizontal + sum_vertical);
    end
end
