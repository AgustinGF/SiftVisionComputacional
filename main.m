%%%%%%%%%% PROGRAMA PRINCIPAL %%%%%%%%%%
%Proyecto Final Visión Computacional, deteccion de objetos 
%utilizando una transformada SIFT. 
%Creado por Agustín Gallo, Daniel Vargaz y David Herrera

%Tomar 1 imagen, sacarle 5 filtros gaussianos, cada uno de los cuales
%tendra un incremento de k SIGMA, sigma=1.6 y k=sqrt(2). s, ks,kks,kkks y
%asi.
% Restar cada para de filtro para sacar el laplaciano de Gausiano,-:Octava
%Hacer el resample de la imagen y hacer lo mismo otra vez pero esta vez
%empezando en k^2, luego seguiria k^4, 3 escalas para cada octava.
clc
close all
tic
ImagenE = imread('0grados_no_luz.jpg');
ImagenE=imresize(ImagenE,1);
[~,~,plane]=size(ImagenE);
if plane==3
ImagenE=rgb2gray(ImagenE);
end

ImagenNut1=imread('nutrioli-pt1.jpg');
[~,~,plane]=size(ImagenNut1);
if plane==3
ImagenNut1=rgb2gray(ImagenNut1);
end

ImagenNut2=imread('nutrioli-pt2.jpg');
[~,~,plane]=size(ImagenNut2);
if plane==3
ImagenNut2=rgb2gray(ImagenNut2);
end

ImagenPen1=imread('penafiel-pt1.jpg');
ImagenPen1=imresize(ImagenPen1,1);
[~,~,plane]=size(ImagenPen1);
if plane==3
ImagenPen1=rgb2gray(ImagenPen1);
end

ImagenPen2=imread('penafiel-pt2.jpg');
[~,~,plane]=size(ImagenPen2);
if plane==3
ImagenPen2=rgb2gray(ImagenPen2);
end

ImagenJum1=imread('jumex-pt1.jpg');
[~,~,plane]=size(ImagenJum1);
if plane==3
ImagenJum1=rgb2gray(ImagenJum1);
end

ImagenJum2=imread('jumex-pt2.jpg');
[~,~,plane]=size(ImagenJum2);
if plane==3
ImagenJum2=rgb2gray(ImagenJum2);
end

Originales={ImagenNut1,ImagenNut2,ImagenPen1,ImagenPen2,ImagenJum1,ImagenJum2};
%Obtener puntos caracteristicos del producto
featuresOriginal={};
featuresLocationsOriginal={};
for i=1:length(Originales)
    [featuresOriginal{i}, featuresLocationsOriginal{i}] = obtenerSift(Originales{i});
end
toc
[Shelfs,posshelf] = splitByShelf(ImagenE,0);

[productos,posProductos]=splitByProduct(Shelfs,0);

figure;
for i = 1:length(Shelfs)
    subplot(length(Shelfs),1,i);
    imshow(Shelfs{i});
end

featuresProducto={};
featureLocationsProducto={};
for i =1:length(productos)

    producto = productos{i};
    [PH,PW] = size(productos{i});
    if PW <150
        producto = imresize(productos{i},1.4);
    end
    [featuresProducto{i}, featureLocationsProducto{i}] = obtenerSift(producto);
    [cantidad,~] = size(featureLocationsProducto{i})
    toc
end
index = zeros(1,length(productos));
max = zeros(1,length(productos));
for j=1:2:length(Originales)
    for i =1:length(productos)
        if isempty(featuresProducto{i})
            continue;
        end
        indexPairs = matchFeatures(featuresOriginal{j},featuresProducto{i},'Unique',1,'MaxRatio',.8);
        indexPairs2 = matchFeatures(featuresOriginal{j+1},featuresProducto{i},'Unique',1,'MaxRatio',.8);
        [matched1,~] = size(indexPairs);
        [matched2,~] = size(indexPairs2);
        matched=matched1+matched2;
        if matched==0
            continue;
        end

        if matched>max(1,i) && matched > 2
            max(1,i) = matched;
            index(1,i) = ceil(j/2) ;
            disp(['Numero de Matches ',num2str(matched),' Color ',num2str(ceil(j/2)),' Prod: ',num2str(i)]);
            
        end
    end
end
toc
figure;
imshow(ImagenE);
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
    
 %Rojo Nutrioli, Verde Penafiel, Azul Jumex
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
toc
hold off;
    
