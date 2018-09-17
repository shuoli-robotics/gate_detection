function box = get_box_from_coordinates(Q1, Q2, Q3, Q4)
% function box = get_box_from_coordinates(Q1, Q2, Q3, Q4)
%
% The coordinates will be arranged as going from top left clock-wise, and
% then passed to get_box_from_corners.

C= [Q1; Q2; Q3; Q4];

% distances contains the distances to the four corners of the "image":
Distances = zeros(4,4);
image_corners = [1,1; max(C(:,1)), 1; max(C(:,1)), max(C(:,2)); 1, max(C(:,2))];
for c = 1:4
    image_corner = image_corners(c, :);
    for d = 1:4
        Distances(c, d) = pdist([image_corner; C(d, :)]);
    end
end

% get the corners from top left clock-wise:
[v,i] = min(Distances(1, :));
Q1 = C(i,:);
[v,i] = min(Distances(2, :));
Q2 = C(i,:);
[v,i] = min(Distances(3, :));
Q3 = C(i,:);
[v,i] = min(Distances(4, :));
Q4 = C(i,:);
% transform them in box format:
box = get_box_from_corners(Q1, Q2, Q3, Q4);
