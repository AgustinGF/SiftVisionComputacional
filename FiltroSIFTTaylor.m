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
tic

sigma=1.6;
k=sqrt(2);
Imagen=imread('C:\Users\Agustin\Documents\Agustin\Tareas\Visión Computacional\ProyectoFinal\penafiel.jpg');
%F=rgb2gray(Imagen);
F=Imagen;
[H,W]=size(F);

%Obteniendo la Primera Octava
GL1=zeros(5,H,W);
for i=1:5
GL1(i,:,:)= imgaussfilt(F,(k^i)*sigma);
end
%Laplacianos de primera Octava
LL1=zeros(4,H,W);
for i=1:4
LL1(i,:,:)= GL1(i,:,:)-GL1(i+1,:,:);
end
%-------------------------------------------------
%Reescalamiento de la imagen
Z2=griddedInterpolant(double(F));
xQ=1:2:W;
yQ=1:2:H;
F2=uint8(Z2({yQ,xQ}));
[H2,W2]=size(F2);
%Obteniendo la Segunda Octava
GL2=zeros(5,H2,W2);
for i=1:5
GL2(i,:,:)= imgaussfilt(F2,(k^i)*sigma);
end
%Laplacianos de Segunda Octava
LL2=zeros(4,H2,W2);
for i=1:4
LL2(i,:,:)= GL2(i,:,:)-GL2(i+1,:,:);
end
%-----------------------------------------------------
%Reescalamiento de la imagen
Z3=griddedInterpolant(double(F2));
xQ=1:2:W2;
yQ=1:2:H2;
F3=uint8(Z3({yQ,xQ}));
[H3,W3]=size(F3);
%Obteniendo la Tercera Octava
GL3=zeros(5,H3,W3);
for i=1:5
GL3(i,:,:)= imgaussfilt(F3,(k^i)*sigma);
end
%Laplacianos de Tercera Octava
LL3=zeros(4,H3,W3);
for i=1:4
LL3(i,:,:)= GL3(i,:,:)-GL3(i+1,:,:);
end
%-----------------------------------------------------------
%Reescalamiento de la imagen
Z4=griddedInterpolant(double(F3));
xQ=1:2:W3;
yQ=1:2:H3;
F4=uint8(Z4({yQ,xQ}));
[H4,W4]=size(F4);
%Obteniendo la Cuarta Octava
GL4=zeros(5,H4,W4);
for i=1:5
GL4(i,:,:)= imgaussfilt(F4,(k^i)*sigma);
end
%Laplacianos de Cuarta Octava
LL4=zeros(4,H4,W4);
for i=1:4
LL4(i,:,:)= GL4(i,:,:)-GL4(i+1,:,:);
end

tiempo = toc;
disp(['Tiempo para hacer laplacianos ' num2str(tiempo)]);
%-------------------------------------------------------------
%Obteniendo los puntos de interés
%---------------------------------------------------------------

%% stores the potential key points
        octavecount = 4;
        locations = [];
        finalpositions = [];
        minlevel=1;
        maxlevel=4;
        length1 = 3;%maxlevel - minlevel;
%---------------------------------------------------------------
%Scale Space Peak Detection
%-------------------------------------------------------

[~,HL1,WL1]=size(LL1);
octava=1;
for centerlevel = minlevel+1 : maxlevel-1
    [x,y] = findExtremaFast(LL1,WL1,HL1,centerlevel);
    for i=1 :size(x,1)
        locations(x(i,1),y(i,1),centerlevel,octava)=1;
    end
end

[niveles,HL2,WL2]=size(LL2);
octava=2;
for centerlevel = minlevel+1 : maxlevel-1
    [x,y] = findExtremaFast(LL2,WL2,HL2,centerlevel);
    for i=1 :size(x,1)
        locations(x(i,1),y(i,1),centerlevel,octava)=1;
    end
end

[niveles,HL3,WL3]=size(LL3);
octava=3;
for centerlevel = minlevel+1 : maxlevel-1
    [x,y] = findExtremaFast(LL3,WL3,HL3,centerlevel);
    for i=1 :size(x,1)
        locations(x(i,1),y(i,1),centerlevel,octava)=1;
    end
end

[niveles,HL4,WL4]=size(LL4);
octava=4;
for centerlevel = minlevel+1 : maxlevel-1
    [x,y] = findExtremaFast(LL4,WL4,HL4,centerlevel);
    for i=1 :size(x,1)
        locations(x(i,1),y(i,1),centerlevel,octava)=1;
    end
end

tiempo = toc;
disp(['Tiempo para peak detection ' num2str(tiempo)]);

imagenes = {F,F2,F3,F4};
%displayKeypoints(imagenes, locations, octavecount,minlevel,maxlevel,length1);
%size(locations)
%---------------------------------------------------------------
% Outlier rejection
%-------------------------------------------------------

LLA={LL1,LL2,LL3,LL4};
[finalpositions]= harrisCornerRejection(LLA,H,W,length1,octavecount,locations,minlevel,maxlevel);

tiempo = toc;
disp(['Tiempo para hacer harris ' num2str(tiempo)]);
displayKeypoints(imagenes, finalpositions, octavecount,minlevel,maxlevel,length1);
%size(finalpositions)

toc
