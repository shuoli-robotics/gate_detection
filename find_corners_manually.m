function [ GT ] = find_corners_manually( dir_name,n,m )
% This function is used to find gate's corners my hand
%   dir_name is the directory's name of pictures
%   n is the id of the first picture and m is the id of the last picture
%   Shuo Li 2018.1.16  ls90911@gmail.com 

% the first coloum stores bool values of whether there is a gate in the 
% picture. 1:there is   0: there is not

GT = zeros(m-n+1,9);
p = 1;

% ------------------------
n = 1;
m = 10;
% ------------------------

for i = n:m
    
    file_name = [dir_name '/' 'img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    end
    RGB = imread(file_name);
    RGB = imrotate(RGB, 90);
   
    figure(2)
    [Response,~] = createMask_basement(RGB);
     imagesc(Response);
    
    figure(1)
    imshow(RGB);
    title(i);
    
    flag_gate = input('Is there a gate? 1:Yes 0:No'  );
    if flag_gate ~= 1
        flag_gate = 0;
    end
    
    if flag_gate == 1
    [x,y] = ginput(4);
    GT(p,1) = flag_gate;
    GT(p,2:5) = x';
    GT(p,6:9) = y';
    end
    p = p+1;    
end

GT = GT(1:p-1,:);

end

