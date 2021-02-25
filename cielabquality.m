%% S-CIELab quality check
% Full-reference: the complete reference and the reproduction
% are available

%Load image
imgInput = imread('inputimage.jpg');
imgOutput = imread('outputimage.jpg');

%Convert to XYZ
imgInputXYZ = rgb2xyz(imgInput);
imgOutputXYZ = rgb2xyz(imgOutput);

%Scielab
%Sample
% 50/2.5 = 50 cm
sampDegree = visualAngle(-1,50/2.5,72,1);
whitePoint = [95.05,100,108.9];

sclab = scielab(sampDegree,imgInputXYZ,imgOutputXYZ,whitePoint,'xyz');

sclabMean = mean(mean(sclab))

imshow(imgInput);
figure
imshow(imgOutput);

