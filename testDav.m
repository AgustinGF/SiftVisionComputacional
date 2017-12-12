close all
Imagen=rgb2gray(imread('nutrioliN.jpg'));
[features1, featurelocations1] = obtenerSift(Imagen);
Imagen2=rgb2gray(imread('nutrioli_O.jpg'));
[features2, featurelocations2] = obtenerSift(Imagen2);
indexPairs = compareSIFTDescriptors(features1,features2);
%indexPairs = matchFeatures(features1,features2);
matchedPoints1 = featurelocations1(indexPairs(:,1),:);
matchedPoints2 = featurelocations2(indexPairs(:,2),:);
figure; ax = axes;
showMatchedFeatures(Imagen,Imagen2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');