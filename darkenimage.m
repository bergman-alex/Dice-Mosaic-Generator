clear;
clc;
close all;

f = dir('images/*.png'); % get info of database images
files = {f.name};
for k = 1:numel(files)
    diceDb{k} = im2double(imread(files{k})); % read database images into one variable
end

for i = 1:108
   A = cell2mat(diceDb(i));
   B = A > 0.9999;
   B = double(B);
   B(B<0.5) = 1.6;
   A = A .* B;
   
   filename = ['light_' cell2mat(files(i))];
   imwrite(A, filename);
end