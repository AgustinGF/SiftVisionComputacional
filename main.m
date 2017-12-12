%%%%%%%%%% PROGRAMA PRINCIPAL %%%%%%%%%%

close all;
clc;

Estante = rgb2gray(imread('0grados_no_luz.jpg'));
Producto=rgb2gray(imread('nutrioliN.jpg'));

%Obtener puntos caracteristicos del producto
[featuresOriginal, featuresLocationsOriginal] = obtenerSift(Producto);

% Obtiene los estantes.
shelfs = splitByShelf(Estante,false);

% Obtiene los productos
productos = splitByProduct(shelfs,false);

% Dibuja estantes.
figure;
for i = 1:length(shelfs)
    subplot(length(shelfs),1,i);
    imshow(shelfs{i});
end

%Obtener puntos caracteristicos del producto
for i =1:length(productos)
    [featuresProducto, featureLocationsProducto] = obtenerSift(productos{i});
 %   indexPairs = compareSIFTDescriptors(featuresProducto1,featuresProducto);
    indexPairs = matchFeatures(featuresOriginal,featuresProducto);
    [matched,~] = size(indexPairs)
    if matched==0
        continue;
    end
    matchedPoints1 = featuresLocationsOriginal(indexPairs(:,1),:);
    matchedPoints2 = featureLocationsProducto(indexPairs(:,2),:);
    figure; ax = axes;
    showMatchedFeatures(Producto,productos{i},matchedPoints1,matchedPoints2,'montage','Parent',ax);
    title(ax, 'Candidate point matches');
    legend(ax, 'Matched points 1','Matched points 2');
end

% for i = 1:1
%     figure();
%     imshow(shelf{i});
%     im = shelf{i};
%     BW = edge(im,'sobel',[],'vertical');
%     
%     figure();
%     imshow(BW);
%     
%     [H,T,R] = hough(BW,'Theta',0);
%     
%      P  = houghpeaks(H,40,'threshold',ceil(0.3*max(H(:))));
% 
%     % Encuentra líneas (divisiones de estantes).
%     lines = houghlines(BW,T,R,P,'FillGap',200,'MinLength',7);
%     
%     figure, imshow(im), hold on
%     max_len = 0;
%     for k = 1:length(lines)
%        xy = [lines(k).point1; lines(k).point2];
%        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%        % Plot beginnings and ends of lines
%        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%        % Determine the endpoints of the longest line segment
%        len = norm(lines(k).point1 - lines(k).point2);
%        if ( len > max_len)
%           max_len = len;
%           xy_long = xy;
%        end
%     end
%     
%     
% end
