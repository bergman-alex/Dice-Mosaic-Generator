%% Load the database
clear
clc
close all

f = dir('images/*.png'); % get info of database images
files = {f.name};
for k = 1:numel(files)
    database{k} = rgb2lab(imread(files{k})); % read database images into one variable
end

%% Calculate Lab means in 20x20 sections
clc
clearvars -except database

loading = waitbar(0, 'Processing image...');
i = 0;

for j = 1:length(database) % loop through each section
    waitbar((j/length(database)), loading, sprintf('Parting image... %.0f%%', (j/length(database))*100));

    diceRegion = cell2mat(database(j));
    i = i+1;
    diceLab(i,1) = mean(diceRegion(:,:,1), 'all'); %L
    diceLab(i,2) = mean(diceRegion(:,:,2), 'all'); %a
    diceLab(i,3) = mean(diceRegion(:,:,3), 'all'); %b
end

% Close the progressbar
close(loading)

%% Cluster the database with k-means
clc
clearvars -except diceLab database

[cidx2,cmeans2] = kmeans(diceLab,19,'dist','sqeuclidean');
%[silh2,h] = silhouette(imgSections,cidx2,'sqeuclidean');

faktor = 0.5;
counter = 1;

for i = 1:19
    clust = find(cidx2==i);
    plot3(diceLab(clust,1),diceLab(clust,2),diceLab(clust,3),'o' );
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
clearvars -except diceLab database diceIndex

dbIndex = [];
iCounter = 1;

for i = 1:length(diceIndex)
    if ismember(i, dbIndex) == 0
        newDbColorSpaceOpt(iCounter) = database(i);
        dbIndex(iCounter) = i;
        iCounter = iCounter + 1; % Keep track of dices in new dB
    end
end

