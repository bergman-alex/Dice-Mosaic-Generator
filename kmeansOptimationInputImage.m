clear
clc
close all

diceSize = 20;

inputImg = rgb2lab(imread('in_img8.jpg')); % read input image (TODO: crop image)
[height, width, ~] = size(inputImg); % get image dimensions

[inputImg, height, width] = imageResize(inputImg, height, width);

f = dir('images/*.png'); % get info of database images
files = {f.name};
for k = 1:numel(files)
    database{k} = rgb2lab(imread(files{k})); % read database images into one variable
end

uniqueDice = zeros(1);

loading = waitbar(0, 'Processing image...');
i = 0;

for w = 1:diceSize:width % loop through each section
    for h = 1:diceSize:height
        waitbar((w/width), loading, sprintf('Parting image... %.0f%%', (w/width)*100));
        
        imgSection = inputImg(h:h+diceSize-1, w:w+diceSize-1, :);
        i = i+1;
        imgSections(i,1) = mean(imgSection(:,:,1), 'all'); %L
        imgSections(i,2) = mean(imgSection(:,:,2), 'all'); %a
        imgSections(i,3) = mean(imgSection(:,:,3), 'all'); %b
        
    end
    clear h;
end
clear w;

% Close the progressbar
close(loading)

%% K-means
clc
clearvars -except imgSections database

[cidx2,cmeans2] = kmeans(imgSections,19,'dist','sqeuclidean');
%[silh2,h] = silhouette(imgSections,cidx2,'sqeuclidean');

faktor = 0.5;
counter = 1;

for i = 1:19
    clust = find(cidx2==i);
    plot3(imgSections(clust,1),imgSections(clust,2),imgSections(clust,3), '.');
    hold on
    
    number = ceil(faktor*length(clust));
    counter = length(number);
    
    if i >= 2
        counter = length(diceIndex);
    end
    diceIndex(counter : counter+number-1) = datasample(clust, number, 'Replace', false);
end

diceIndex = diceIndex'; 

plot3(cmeans2(:,1),cmeans2(:,2),cmeans2(:,3),'ko');
plot3(cmeans2(:,1),cmeans2(:,2),cmeans2(:,3),'kx');
hold off
xlabel('L');
ylabel('a');
zlabel('b');
view(-137,10);
grid on

%% Create new database

clc
clearvars -except imgSections database diceIndex

totalDiff = 0;
dbIndex = [];
iCounter = 1;
loading = waitbar(0, 'Comparing Lab values...');

for i = 1:length(diceIndex)
    
    diffMin = 10000;
    inputMeanL = imgSections(diceIndex(i,1),1);
    inputMeanA = imgSections(diceIndex(i,1),2);
    inputMeanB = imgSections(diceIndex(i,1),3);
    waitbar((i/length(diceIndex)), loading, sprintf('Comparing Lab values... %.0f%%', (i/length(diceIndex))*100));
    
    for j = 1:length(database)        
        diceRegion = cell2mat(database(j));

        diceMeanL = mean(diceRegion(:,:,1), 'all'); % average pixel value of current dice image
        diceMeanA = mean(diceRegion(:,:,2), 'all');
        diceMeanB = mean(diceRegion(:,:,3), 'all');

        diffL = abs(inputMeanL - diceMeanL); % difference between the dice and the input region
        diffA = abs(inputMeanA - diceMeanA);
        diffB = abs(inputMeanB - diceMeanB);

        totalDiff = sqrt(diffL^2 + diffA^2 + diffB^2);

        if totalDiff < diffMin % find the dice with lowest difference
            diffMin = totalDiff; % store difference value
            counter = j;
        end
    end
    
    if ismember(counter, dbIndex) == 0
        newDbInputOpt(iCounter) = database(counter);
        dbIndex(iCounter) = counter;
        iCounter = iCounter + 1; % Keep track of dices in new dB
    end
end

% Close the progressbar
close(loading)

