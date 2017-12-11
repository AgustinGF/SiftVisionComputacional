%Proyecto Final Visión Computacional, deteccion de objetos 
%utilizando una transformada SIFT. 
%Creado por Agustín Gallo Fernández.

%Tomar 1 imagen, sacarle 5 filtros gaussianos, cada uno de los cuales
%tendra un incremento de k SIGMA, sigma=1.6 y k=sqrt(2). s, ks,kks,kkks y
%asi.
% Restar cada para de filtro para sacar el laplaciano de Gausiano,-:Octava
%Hacer el resample de la imagen y hacer lo mismo otra vez pero esta vez
%empezando en k^2, luego seguiria k^4, 3 escalas para cada octava.
clc
close all
Imagen = imread('nutrioli.jpg');
Imagen=imresize(Imagen,.5);
[~,~,plane]=size(Imagen);
if plane==3
Imagen=rgb2gray(Imagen);
end

Imagen2=imread('estantemod.png');
Imagen2=imresize(Imagen2,1);
[~,~,plane]=size(Imagen2);
if plane==3
Imagen2=rgb2gray(Imagen2);
end

%  [descriptores1,location1]=obtenerSift(Imagen);
%  size(descriptores1)
%  size(location1);
%  location1;
% % location1;
% 
%  [descriptores2,location2]=obtenerSift(Imagen2);
%  size(descriptores2)
%  size(location2);
%  location2;
 
%  points1=detectSURFFeatures(Imagen);
%  points2=detectSURFFeatures(Imagen2);
%  
%  [descriptores1,location1]=extractFeatures(Imagen,points1);
%  [descriptores2,location2]=extractFeatures(Imagen2,points2);
 
 points1=detectFASTFeatures(Imagen,'MinContrast',.2);
 points2=detectFASTFeatures(Imagen2,'MinContrast',.2);
 [descriptores1,location1]=extractFeatures(Imagen,points1);
 [descriptores2,location2]=extractFeatures(Imagen2,points2);
 
 indexPairs=matchFeatures(descriptores1,descriptores2,'Unique',0,'MaxRatio',.6,'MatchThreshold',10);
 size(indexPairs)
%  indexPairs = compareSIFTDescriptors(descriptores1,descriptores2); 
 matchedPoints1 = location1(indexPairs(:,1),:);
 matchedPoints2 = location2(indexPairs(:,2),:);
 
descriptores1(2,:);
descriptores2(2,:);
 
 figure; 
 showMatchedFeatures(Imagen,Imagen2,matchedPoints1,matchedPoints2,'montage','Parent',axes);
