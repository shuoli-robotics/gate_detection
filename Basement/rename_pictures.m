clear
clc

p = 1;
for i = 1:1000
     file_name = ['img_' sprintf('%05d',i) '.jpg'];
    if ~exist(file_name, 'file')
        continue;
    end
    dir_name = 'temp';
    new_file = [dir_name '/' 'img_' sprintf('%05d',p) '.jpg'];
    movefile(file_name,new_file);
    p = p+1;
end
temp = 1;