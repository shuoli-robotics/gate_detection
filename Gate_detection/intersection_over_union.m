function iou = intersection_over_union(box1, box2)
% function iou = intersection_over_union(box1, box2)
%
% box = [x1, x2, x3, x4, y1, y2, y3, y4]
%
% Where the indices indicate the following corners:
% Q1 = [x-s; y-s];
% Q2 = [x+s; y-s];
% Q3 = [x+s; y+s];
% Q4 = [x-s; y+s];

% calculate the intersection:
is = intersection(box1, box2);

% calculate the union:
w1 = box1(2) - box1(1);
h1 = box1(7) - box1(5);
w2 = box2(2) - box2(1);
h2 = box2(7) - box2(5);
un = w1*h1 + w2*h2 - is;

if(un == 0)
    iou = 1;
else
    iou = is / un;
end

end

function is = intersection(box1, box2)
% function is = intersection(box1, box2)

width = overlap([box1_x_min, box1_x_max], [box2_x_min, box2_x_max]);
height = overlap([box1_y_min, box1_y_max], [box2_y_min, box2_y_max]);

is = width * height;

end

function ol = overlap(interval_1, interval_2)
% function ol = overlap(interval_1, interval_2)

if(interval_2(1) < interval_1(1))
    if(interval_2(2) < interval_1(1))
        ol = 0;
    else
        ol = min([interval_1(2), interval_2(2)]) - interval_1(1);
    end
else
    if(interval_1(2) < interval_2(1))
        ol = 0;
    else
        ol = min([interval_1(2), interval_2(2)]) - interval_2(1);
    end
end

end