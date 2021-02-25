clc
clearvars -except newDbInputOpt newDbColorSpaceOpt

diceSize = 20;

inputImg = rgb2lab(imread('in_img8.jpg')); % read input image (TODO: crop image)
[height, width, ~] = size(inputImg); % get image dimensions

[inputImg, height, width] = imageResize(inputImg, height, width);

f = dir('images/*.png'); % get info of database images
files = {f.name};
for k = 1:numel(files)
    diceDb{k} = rgb2lab(imread(files{k})); % read database images into one variable
end

database = diceDb;

uniqueDice = zeros(1);
loading = waitbar(0, 'Processing image...');

for w = 1:diceSize:width % loop through each section
    for h = 1:diceSize:height
        waitbar((w/width), loading, sprintf('Processing image... %.0f%%', (w/width)*100));
        
        imgSection = inputImg(h:h+diceSize-1, w:w+diceSize-1, :);
        [replacementDice, diceIndex] = compareDice(imgSection, database);
        
        outputImg(h:h+19, w:w+19, :) = replacementDice;
        
        if ~ismember(diceIndex, uniqueDice)
            uniqueDice = [uniqueDice diceIndex];
        end
    end
    clear h;
end
clear w;

close(loading);

outputImg = lab2rgb(outputImg);
inputImg = lab2rgb(inputImg);

SNR_value = snr(inputImg, inputImg-outputImg);
MSE_value = immse(inputImg, outputImg);

imshow(inputImg);
figure;
imshow(outputImg);

imwrite(outputImg, 'outputimage.jpg');
imwrite(inputImg, 'inputimage.jpg');

