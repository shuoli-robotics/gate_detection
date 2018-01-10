function detectWindow(D, Im, xc, yc)
% function detectWindow(D, Im, xc, yc)

DETECTION_THRESHOLD = 0.90;
DETERMINE_SIZE = false; % does not really work

W = size(D,2); H = size(D,1);

II = getIntegralImage(D);

% get dominant disparity:
dd = getAvgDisparity(10, 10, size(D,2)-10, size(D,1)-10, II);
% disp: window size
% 4.0: 30 x 30
% 4.5: 40 x 40
% 5.0: 50 x 50

if(~exist('xc'))
    window_sizes = [50, 100, 150, 200];
else
    window_sizes = 50:50:500;
end
colors = {'red', 'white', 'green', 'magenta'};
feature_sizes = floor(1.3 * window_sizes);
n_sizes = length(window_sizes);
Response = cell(n_sizes, 1);
for s = 1:n_sizes
    fs = feature_sizes(s);
    ws = window_sizes(s);
    border = floor(0.15 * fs);
    response_offset = floor(border + 0.5 * fs);
    if(~exist('xc', 'var'))
        Response{s} = ones(H, W);
        for x = 1:W-fs-2*border
            for y = 1:H-fs-2*border
                Response{s}(y+response_offset,x+response_offset) = getWindowResponse(x, y, feature_sizes(s), II);
                %             % Response{s}(y,x) = getAvgDisparity(x, y, x+feature_sizes(s), y+feature_sizes(s), II);
                if(Response{s}(y+response_offset,x+response_offset) < 1)
                    % check other features:
                    Response{s}(y+response_offset,x+response_offset) = getBorderResponse(x, y, feature_sizes(s), ws,  border, II);
                end
            end
        end
    else
        feature_sizes(s) = min([H-1, W-1, feature_sizes(s)])
        x = max([xc - round(feature_sizes(s) / 2), 1]);
        y = max([yc - round(feature_sizes(s) / 2), 1]);
        
        Response{s} = getWindowResponse(x, y, feature_sizes(s), II);
        if(Response{s} < 1)
            % check other features:
            Response{s} = getBorderResponse(x, y, feature_sizes(s), ws,  border, II);
        end
    end
end


min_responses = zeros(n_sizes, 1);
if(~exist('xc', 'var'))
    coordinates = zeros(n_sizes, 2);
    for s = 1:n_sizes
        [v, row] = min(Response{s});
        [vv, col] = min(v);
        coordinates(s, 1) = col;
        coordinates(s, 2) = row(col);
        min_responses(s) = vv;
    end
else
    coordinates = repmat([xc, yc], [n_sizes, 1]);
    for s = 1:n_sizes
        min_responses(s) = Response{s};
    end
end


if(DETERMINE_SIZE)
    [best_val, best_ind] = min(min_responses);
    if(best_val < DETECTION_THRESHOLD)
        % window detected, determine size:
        
        % determine threshold:
        feature_size = feature_sizes(best_ind);
        border = floor(0.15 * feature_size);
        response_offset = floor(border + 0.5 * feature_size);
        x = coordinates(best_ind,1);
        y = coordinates(best_ind,2);
        whole_area = getSumDisparity(x-response_offset, y-response_offset, x-response_offset+feature_size, y-response_offset+feature_size, II);
        px_whole = feature_size * feature_size;
        inner_area = getSumDisparity(x-response_offset+border, y-response_offset+border, x-response_offset+feature_size-border, y-response_offset+feature_size-border, II);
        px_inner = feature_size-2*border;
        px_inner = px_inner * px_inner;
        px_border = px_whole - px_inner;
        % average of the average inner and border disparity:
        % threshold = 0.8 * ((whole_area - inner_area) / px_border) + 0.2 * (inner_area / px_inner);
        % threshold = (whole_area - inner_area) / px_border;
        threshold = 6;
        
        % ends of the window size search:
        min_x = max([1, x - border - feature_size]);
        max_x = min([W, x + border + feature_size]);
        min_y = max([1, y - border - feature_size]);
        max_y = min([H, y + border + feature_size]);
        
        % left:
        left = 0;
        for xx = x:-1:min_x
            %fprintf('R(%d,%d) = %f <= %f\n', y, xx, Response{best_ind}(y, xx), threshold)
            if(D(y, xx) > threshold)
                % border found!
                left = xx;
                break;
            end
        end
        % right:
        right = 0;
        for xx = x:max_x
            if(D(y, xx) > threshold)
                % border found!
                right = xx;
                break;
            end
        end
        % up:
        up = 0;
        for yy = y:max_y
            if(D(yy, x) > threshold)
                % border found!
                up = yy;
                break;
            end
        end
        % down:
        down = 0;
        for yy = y:-1:min_y
            if(D(yy, x) > threshold)
                % border found!
                down = yy;
                break;
            end
        end
    end
end
% show the disparity image:
h = figure();
subplot(1,2,1); 
imshow(Im); 
hold on;
for s = 1:n_sizes
    plot(coordinates(s, 1), coordinates(s, 2), 'x', 'Color', 'red', 'MarkerSize', 3 * s);
    rectangle2(h, coordinates(s, 1)-window_sizes(s)/2, coordinates(s, 2)-window_sizes(s)/2, coordinates(s, 1)+window_sizes(s)/2, coordinates(s, 2)+window_sizes(s)/2, colors{s});
end
if(DETERMINE_SIZE && best_val < DETECTION_THRESHOLD)
    rectangle2(h,left,up,right,down,[1 0 0])
end
subplot(1,2,2); 
imagesc(D);
title(num2str(dd));
hh = figure();
for s = 1:n_sizes
    subplot(1, n_sizes, s);
    imagesc(Response{s});
    hold on;
    plot(coordinates(s, 1), coordinates(s, 2), 'x', 'Color', [1 1 1]);
    title(num2str(min(Response{s}(:))));
end
waitforbuttonpress();
close(h); close(hh);

function resp = getBorderResponse(x, y, feature_size, window_size, border, II)
% inner area:
inner_area = getSumDisparity(x+border, y+border, x+feature_size-border, y+feature_size-border, II);
px_inner = feature_size-2*border;
px_inner = px_inner * px_inner;
avg_inner = inner_area / px_inner;
% outer areas:
left_area = getSumDisparity(x, y+border, x+border, y+border+window_size, II);
right_area = getSumDisparity(x+border+window_size, y+border, x+2*border+window_size, y+border+window_size, II);
up_area = getSumDisparity(x+border, y, x+border+window_size, y+border, II);
down_area = getSumDisparity(x+border, y+border+window_size, x+border+window_size, y+2*border+window_size, II);
px_outer = border * window_size;
% darkest outer area:
darkest = min([left_area, right_area, up_area, down_area]);
avg_dark = darkest / px_outer;
% TODO: uncomment
if(avg_dark <= avg_inner || abs(avg_dark) < eps)
% if(avg_dark <= 1.5 || avg_dark <= avg_inner || abs(avg_dark) < eps)
    resp = 1;
else
    resp = avg_inner / avg_dark;
end

function resp = getWindowResponse(x, y, feature_size, II)
border = floor(0.15 * feature_size);
whole_area = getSumDisparity(x, y, x+feature_size, y+feature_size, II);
px_whole = feature_size * feature_size;
inner_area = getSumDisparity(x+border, y+border, x+feature_size-border, y+feature_size-border, II);
px_inner = feature_size-2*border;
px_inner = px_inner * px_inner;
px_border = px_whole - px_inner;
if((whole_area - inner_area) / px_border < 1)
    resp = 1;
else
    resp = (inner_area/px_inner) / ((whole_area - inner_area) / px_border );
end

function sum_disparities = getSumDisparity(min_x, min_y, max_x, max_y, II)
w = max_x - min_x + 1;
h = max_y - min_y + 1;
sum_disparities = II(min_y, min_x) +  II(max_y, max_x) - II(min_y, max_x) - II(max_y, min_x);
sum_disparities = max([sum_disparities, 0]);

function dd = getAvgDisparity(min_x, min_y, max_x, max_y, II)
w = max_x - min_x + 1;
h = max_y - min_y + 1;
n_pix = w * h;
sum_disparities = II(min_y, min_x) +  II(max_y, max_x) - II(min_y, max_x) - II(max_y, min_x);
dd = sum_disparities / n_pix;