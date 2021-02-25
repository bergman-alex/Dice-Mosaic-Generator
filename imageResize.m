function [newImg, newH, newW] = imageResize(img, h, w)

heightRest = mod(h, 20);
widthRest = mod(w, 20);

if heightRest > 0 || widthRest > 0
    img = imresize(img, [h-heightRest w-widthRest]);
    disp('Image dimensions not divisible by 20. Resizing...');
end

newImg = img;
[newH, newW, ~] = size(newImg); % get resized image dimensions

end

