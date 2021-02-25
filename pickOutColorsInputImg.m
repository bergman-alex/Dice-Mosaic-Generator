clear
clc
close all

diceSize = 20;

inputImg = rgb2lab(imread('in_img3.jpg')); % read input image (TODO: crop image)
[height, width, ~] = size(inputImg); % get image dimensions

[inputImg, height, width] = imageResize(inputImg, height, width);

f = dir('images/*.png'); % get info of database images
files = {f.name};
for k = 1:numel(files)
    database{k} = rgb2lab(imread(files{k})); % read database images into one variable
end

    octant = zeros(294, 3);

for i = 1:length(database)
    diceRegion = cell2mat(database(i));
    
    L = mean(diceRegion(:,:,1), 'all'); % average pixel value of current dice image
    A = mean(diceRegion(:,:,2), 'all');
    B = mean(diceRegion(:,:,3), 'all');
    
    labSum = sqrt((50-L)^2 + A^2 + B^2);
    
    % sort each dicecolor into an octant of the CIELAB spectrum
    if L < 50 && A < 0 && B < 0
        octant(i, 1) = 1;
    elseif L >= 50 && A < 0 && B < 0
        octant(i, 1) = 2;
    elseif L < 50 && A >= 0 && B < 0
        octant(i, 1) = 3;
    elseif L >= 50 && A >= 0 && B < 0
        octant(i, 1) = 4;
    elseif L < 50 && A < 0 && B >= 0
        octant(i, 1) = 5;
    elseif L >= 50 && A < 0 && B >= 0
        octant(i, 1) = 6;
    elseif L < 50 && A >= 0 && B >= 0
        octant(i, 1) = 7;
    elseif L >= 50 && A >= 0 && B >= 0
        octant(i, 1) = 8;
    end
    % NOTE: octant 1 only contains two dice and octant 5 contains zero.
    % unlucky.
    
    octant(i, 2) = labSum;
    octant(i, 3) = i;
end

octant = sortrows(octant);

imageOctants = analyseImageColor(inputImg, diceSize, width, height);

oct1 = octant(1:2, 3);
oct2 = sort(datasample(octant(3:36, 3),    ceil(imageOctants(2,2)*(36-2)), 'Replace', false));
oct3 = sort(datasample(octant(37:67, 3),   ceil(imageOctants(3,2)*(67-36)), 'Replace', false));
oct4 = sort(datasample(octant(68:132, 3),  ceil(imageOctants(4,2)*(132-67)), 'Replace', false));
oct6 = sort(datasample(octant(133:204, 3), ceil(imageOctants(6,2)*(204-132)), 'Replace', false));
oct7 = sort(datasample(octant(205:240, 3), ceil(imageOctants(7,2)*(240-204)), 'Replace', false));
oct8 = sort(datasample(octant(241:294, 3), ceil(imageOctants(8,2)*(294-240)), 'Replace', false));

diceIndex = [oct1; oct2; oct3; oct4; oct6; oct7; oct8];

for i = 1:size(diceIndex)
   newDiceDb(i) = database(diceIndex(i));
end








