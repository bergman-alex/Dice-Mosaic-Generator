function [output, diceIndex] = compareDice(input, database)

inputMeanL = mean(input(:,:,1), 'all');
inputMeanA = mean(input(:,:,2), 'all');
inputMeanB = mean(input(:,:,3), 'all');

%plot3(inputMeanL,inputMeanA,inputMeanB,'o');
%hold on

diffMin = 10000;

for i = 1:length(database)
    diceRegion = cell2mat(database(i));
    
    diceMeanL = mean(diceRegion(:,:,1), 'all'); % average pixel value of current dice image
    diceMeanA = mean(diceRegion(:,:,2), 'all');
    diceMeanB = mean(diceRegion(:,:,3), 'all');
    
    diffL = abs(inputMeanL - diceMeanL); % difference between the dice and the input region
    diffA = abs(inputMeanA - diceMeanA);
    diffB = abs(inputMeanB - diceMeanB);
    
    totalDiff = sqrt(diffL^2 + diffA^2 + diffB^2);
    
    if totalDiff < diffMin % find the dice with lowest difference
        diffMin = totalDiff; % store difference value
        diceIndex = i; % store index of current dice
    end
end

output = cell2mat(database(diceIndex)); % return the best dice as a 20x20 double