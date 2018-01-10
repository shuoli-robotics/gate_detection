function search_for_QR_corners(QR_file_name, QR_Im)
% function search_for_QR_corners(QR_file_name, QR_Im)

if(exist('QR_file_name', 'var') && ~isempty(QR_file_name))
    QR_Im = imread(QR_file_name);
    QR_Im = double(rgb2gray(QR_Im)) ./ 255;
end
if(size(QR_Im, 3) == 3)
    QR_Im = rgb2gray(QR_Im);
end
QR_Im = imresize(QR_Im, [63, 63]);
inds = find(QR_Im == 0);
QR_Im(inds) = -1;
H = size(QR_Im, 1);
W = size(QR_Im, 2);
avg_ill = 1.5 * mean(QR_Im(:));

Corner = imread('QR_corner.png');
Corner = double(rgb2gray(Corner)) ./ 255;
Corner = imresize(Corner, [21, 21]);
inds = find(Corner == 0);
Corner(inds) = -1;
%
NCC_QR = normxcorr2(Corner, QR_Im);
figure();
subplot(1,2,1); imagesc(NCC_QR);
subplot(1,2,2); imagesc(QR_Im > avg_ill);
% CCQR = conv2(QR_Im, Corner);
%
% [DX, DY] = gradient(QR_Im);
%
% figure();
% %subplot(2,2,1); imshow(QR_Im);
% %subplot(2,2,2); imagesc(CCQR);
% %subplot(2,2,3); imagesc(sqrt(DX.*DX+DY.*DY));

% problems:
% if it starts with black, it will not work
% if it is stuck in a state > 1 when it should actually be in 0 it will
% miss the code
% The precise pixel counts can be off more than we think

detection = [];
deviation_ratio = 0.6;
state = 0; % start the search
for y = 1:H
    x = 0;
    state = 0;
    while x <= W-1
        x = x + 1;
        switch state
            case 0
                % starting the search
                if(QR_Im(y,x) > avg_ill)
                    x_white_left = x;
                    n_white_left = 1;
                    state = 1;
                end
            case 1
                % white pixels
                if(QR_Im(y,x) > avg_ill)
                    n_white_left = n_white_left + 1;
                else
                    x_black_inner = x;
                    n_black_inner = 1;
                    state = 2;
                end
            case 2
                % black, inner pixels
                if(QR_Im(y,x) < avg_ill)
                    n_black_inner = n_black_inner + 1;
                else
                    ratio = n_black_inner / n_white_left;
                    if(ratio < 3- deviation_ratio || ratio > 3 + deviation_ratio)
                        % This is not it, start over:
                        state = 0;
                        x = x_black_inner;
                    else
                        n_white_right = 1;
                        state = 3;
                    end
                end
            case 3
                % white pixels
                if(QR_Im(y,x) > avg_ill)
                    n_white_right = n_white_right + 1;
                else
                    %                     ratio = n_white_right / n_white_left;
                    %                     if(ratio < 1- deviation_ratio || ratio > 1 + deviation_ratio)
                    ratio = n_black_inner / n_white_right;
                    if(ratio < 3- deviation_ratio || ratio > 3 + deviation_ratio)
                        % This is not it, start over:
                        state = 0;
                        x = x_black_inner; % else we may miss the start
                    else
                        n_black_right = 1;
                        state = 4;
                    end
                end
            case 4
                % black pixels
                if(QR_Im(y,x) < avg_ill)
                    n_black_right = n_black_right + 1;
                else
                    ratio = n_black_right / n_white_right;
                    if(ratio < 1- deviation_ratio || ratio > 1 + deviation_ratio)
                        % This is not it, start over:
                        state = 0;
                        x = x_black_inner; % else we may miss the start
                    else
                        % detection!!!
                        detection = [detection; y, x_white_left];
                    end
                end
        end
    end
end

figure();
imshow(QR_Im > avg_ill);
hold on;
if(~isempty(detection))
    plot(detection(:,2), detection(:,1), 'x', 'Color', 'red');
end

%
% switch state
%             case 0
%                 % starting the search
%                 if(QR_Im(y,x) < avg_ill)
%                     x_start = x;
%                     n_black_left = 1;
%                     state = 1;
%                 end
%             case 1
%                 % black pixels
%                 if(QR_Im(y,x) < avg_ill)
%                     n_black_left = n_black_left + 1;
%                 else
%                     n_white_left = 1;
%                     state = 2;
%                 end
%             case 2
%                 % white pixels
%                 if(QR_Im(y,x) > avg_ill)
%                     n_white_left = n_white_left + 1;
%                 else
%                     ratio = n_black_left / n_white_left;
%                     if(ratio < 1- deviation_ratio || ratio > 1 + deviation_ratio)
%                         % This is not it, start over:
%                         state = 0;
%                     else
%                         n_black_inner = 1;
%                         state = 3;
%                     end
%                 end
%             case 3
%                 % black, inner pixels
%                 if(QR_Im(y,x) < avg_ill)
%                     n_black_inner = n_black_inner + 1;
%                 else
%                     ratio = n_black_inner / n_white_left;
%                     if(ratio < 3- deviation_ratio || ratio > 3 + deviation_ratio)
%                         % This is not it, start over:
%                         state = 0;
%                     else
%                         n_white_right = 1;
%                         state = 4;
%                     end
%                 end
%             case 4
%                 % white pixels
%                 if(QR_Im(y,x) > avg_ill)
%                     n_white_right = n_white_right + 1;
%                 else
%                     ratio = n_white_right / n_white_left;
%                     if(ratio < 1- deviation_ratio || ratio > 1 + deviation_ratio)
%                         % This is not it, start over:
%                         state = 0;
%                     else
%                         n_black_right = 1;
%                         state = 5;
%                     end
%                 end
%             case 5
%                 % black pixels
%                 if(QR_Im(y,x) < avg_ill)
%                     n_black_right = n_black_right + 1;
%                 else
%                     ratio = n_black_right / n_black_left;
%                     if(ratio < 1- deviation_ratio || ratio > 1 + deviation_ratio)
%                         % This is not it, start over:
%                         state = 0;
%                     else
%                         % detection!!!
%                         detection = [detection; y, x_start];
%                     end
%                 end
%         end