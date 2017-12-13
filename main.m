%%%%%%%%%% PROGRAMA PRINCIPAL %%%%%%%%%%

close all;
clc;
clear;

tic;

Estante = rgb2gray(imread('0grados_no_luz.jpg'));

Nutrioli=rgb2gray(imread('nutrioliO.jpg'));
Penafiel=rgb2gray(imread('penafielO.jpg'));
Jumex=rgb2gray(imread('jumexO.jpg'));

Originales={Nutrioli,Penafiel,Jumex};
%Obtener puntos caracteristicos del producto
featuresOriginal={};
featuresLocationsOriginal={};
for i=1:length(Originales)
    [featuresOriginal{i}, featuresLocationsOriginal{i}] = obtenerSift(Originales{i});
end

% Obtiene los estantes.
[shelfs,posshelf] = splitByShelf(Estante,false);

[productos,posProductos] = splitByProduct(shelfs,false);

% Dibuja estantes.
figure;
for i = 1:length(shelfs)
    subplot(length(shelfs),1,i);
    imshow(shelfs{i});
end

%Obtener puntos caracteristicos del producto

featuresProducto={};
featureLocationsProducto={};
for i =1:length(productos)

    producto = productos{i};
    [PH,PW] = size(productos{i});
    if PW <200
        producto = imresize(productos{i},2);
    end
    [featuresProducto{i}, featureLocationsProducto{i}] = obtenerSift(producto);
end

% Realizar los matches
index = zeros(1,length(productos));
max = zeros(1,length(productos));
for j=1:length(Originales)
    for i =1:length(productos)
        if isempty(featuresProducto{i})
            continue;
        end
        indexPairs = matchFeatures(featuresOriginal{j},featuresProducto{i},'Unique',true);
        %indexPairs = compareSIFTDescriptors(featuresOriginal{j},featuresProducto{i});

        [matched,~] = size(indexPairs);
        if matched==0
            continue;
        end
    %     matchedPoints1 = featuresLocationsOriginal{i}(indexPairs(:,1),:);
    %     matchedPoints2 = featureLocationsProducto{i}(indexPairs(:,2),:);
    %     figure; ax = axes;
    %     showMatchedFeatures(Producto,productos{i},matchedPoints1,matchedPoints2,'montage','Parent',ax);
    %     title(ax, 'Candidate point matches');
    %     legend(ax, 'Matched points 1','Matched points 2');

        if matched>max(1,i)
            max(1,i) = matched;
            index(1,i) = j;
        end

       end
end

% Dibuja los productos
figure;
imshow(Estante);
hold on;
for i=1:length(productos)
    shelfN1 = posProductos{i}(1);
    x1 = posProductos{i}(2);
    
    shelfN2 = posProductos{i+1}(1);
    if(shelfN1 ~= shelfN2)
        x1 = 1;
    end
    
    y1 = posshelf{shelfN2};
    
    [height,width] = size(productos{i});
    
     if index(1,i)==1
        rectangle('Position',[x1,y1,width,height/2],'FaceColor','r');
     elseif index(1,i)==2
         rectangle('Position',[x1,y1,width,height/2],'FaceColor','g');
    elseif index(1,i)==3
         rectangle('Position',[x1,y1,width,height/2],'FaceColor','b');
	else 
         rectangle('Position',[x1,y1,width,height/2],'FaceColor','y');
    end
    
end
hold off;

tiempo = toc;
disp(['Tiempo total = ' num2str(tiempo)]);
    