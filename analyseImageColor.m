function octant = analyseImageColor(img, diceSize, width, height)

octant = zeros(8, 2);

img = rgb2lab(img); 

for w = 1:diceSize:width % loop through each section
    for h = 1:diceSize:height        
        imgSection = img(h:h+diceSize-1, w:w+diceSize-1, :);
        
        L = mean(imgSection(:,:,1), 'all'); % average pixel value of current dice image
        A = mean(imgSection(:,:,2), 'all');
        B = mean(imgSection(:,:,3), 'all');

        % sort each dicecolor into an octant of the CIELAB spectrum
        if L < 50 && A < 0 && B < 0
            octant(1, 1) = octant(1,1) + 1;
        elseif L >= 50 && A < 0 && B < 0
            octant(2, 1) = octant(2,1) + 1;
        elseif L < 50 && A >= 0 && B < 0
            octant(3, 1) = octant(3,1) + 1;
        elseif L >= 50 && A >= 0 && B < 0
            octant(4, 1) = octant(4,1) + 1;
        elseif L < 50 && A < 0 && B >= 0
            octant(5, 1) = octant(5,1) + 1;
        elseif L >= 50 && A < 0 && B >= 0
            octant(6, 1) = octant(6,1) + 1;
        elseif L < 50 && A >= 0 && B >= 0
            octant(7, 1) = octant(7,1) + 1;
        elseif L >= 50 && A >= 0 && B >= 0
            octant(8, 1) = octant(8,1) + 1;
        end
    end
end

for i=1:8
    octant(i, 2) = octant(i,1) / ((width*height)/400);
end

octant(:,2) = octant(:,2)*(1/max(octant(:,2)));

end

