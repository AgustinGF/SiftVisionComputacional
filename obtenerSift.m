function [featuredescriptions,featurelocations]= obtenerSift(Imagen)
    
tic;
    sigma=1.6;
    sigmaValue=sigma;
    kvalue=sqrt(2);
    minlevel=1;
    maxlevel=4;
    octavas=5;
    length1=3;
    F=Imagen;
    [H,W]=size(F);
    featuredescriptions=[];
    Locaciones=[];
    numGaussianas = maxlevel+2;
    numLaplacianos = numGaussianas-1;
    %Obteniendo la Primera Octava
    GL1=zeros(numGaussianas,H,W);
   
    for i=1:numGaussianas
        GL1(i,:,:)= imgaussfilt(F,(kvalue^i)*sigma);
    end
    %Laplacianos de primera Octava
    LL1=zeros(numLaplacianos,H,W);
    for i=1:numLaplacianos
        LL1(i,:,:)= GL1(i,:,:)-GL1(i+1,:,:);
    end
%-------------------------------------------------
%   Reescalamiento de la imagen
    Z2=griddedInterpolant(double(F));
    xQ=1:2:W;
    yQ=1:2:H;
    F2=uint8(Z2({yQ,xQ}));
    [H2,W2]=size(F2);
%   Obteniendo la Segunda Octava
    GL2=zeros(numGaussianas,H2,W2);
    for i=1:numGaussianas
        GL2(i,:,:)= imgaussfilt(F2,(kvalue^i)*sigma);
    end
%   Laplacianos de Segunda Octava
    LL2=zeros(numLaplacianos,H2,W2);
    for i=1:numLaplacianos
        LL2(i,:,:)= GL2(i,:,:)-GL2(i+1,:,:);
    end
%-----------------------------------------------------
%   Reescalamiento de la imagen
    Z3=griddedInterpolant(double(F2));
    xQ=1:2:W2;
    yQ=1:2:H2;
    F3=uint8(Z3({yQ,xQ}));
    [H3,W3]=size(F3);
%   Obteniendo la Tercera Octava
    GL3=zeros(numGaussianas,H3,W3);
    for i=1:numGaussianas
        GL3(i,:,:)= imgaussfilt(F3,(kvalue^i)*sigma);
    end
%   Laplacianos de Tercera Octava
    LL3=zeros(numLaplacianos,H3,W3);
    for i=1:numLaplacianos
        LL3(i,:,:)= GL3(i,:,:)-GL3(i+1,:,:);
    end
%-----------------------------------------------------------
%   Reescalamiento de la imagen
    Z4=griddedInterpolant(double(F3));
    xQ=1:2:W3;
    yQ=1:2:H3;
    F4=uint8(Z4({yQ,xQ}));
    [H4,W4]=size(F4);
%   Obteniendo la Cuarta Octava
    GL4=zeros(numGaussianas,H4,W4);
    for i=1:numGaussianas
        GL4(i,:,:)= imgaussfilt(F4,(kvalue^i)*sigma);
    end
%   Laplacianos de Cuarta Octava
    LL4=zeros(numLaplacianos,H4,W4);
    for i=1:numLaplacianos
        LL4(i,:,:)= GL4(i,:,:)-GL4(i+1,:,:);
    end
%-----------------------------------------------------------    
%   Reescalamiento de la imagen
    Z5=griddedInterpolant(double(F4));
    xQ=1:2:W4;
    yQ=1:2:H4;
    F5=uint8(Z5({yQ,xQ}));
    [H5,W5]=size(F5);
%   Obteniendo la Quinta Octava
    GL5=zeros(numGaussianas,H5,W5);
    for i=1:numGaussianas
        GL5(i,:,:)= imgaussfilt(F5,(kvalue^i)*sigma);
    end
%   Laplacianos de Quinta Octava
    LL5=zeros(numLaplacianos,H5,W5);
    for i=1:numLaplacianos
        LL5(i,:,:)= GL5(i,:,:)-GL5(i+1,:,:);
    end
%-------------------------------------------------------------
%   Obteniendo los puntos de interés
%---------------------------------------------------------------
minContrast=.15;
minQuality=.3;
%1ra Octava
%-------------------------------------------------------
    LLmin=min(min(min(LL1)));
    LLmax=max(max(max(LL1)));
    LL1=(1/(LLmax-LLmin))*(LL1-LLmin);
    LL1KP=zeros(H,W,4);
    mostrarLL1KP=cornerPoints([1,1]);
    for i=1:4
        aux=reshape(LL1(i,:,:),size(F));
        aux2=detectFASTFeatures(aux,'MinQuality',minQuality,'MinContrast',minContrast);
%         aux2=selectStrongest(aux2,5);   
        for j = 1 : aux2.Count
            x=aux2(j).Location;
            LL1KP(floor(x(2)),floor(x(1)),i)=1;
        end
        mostrarLL1KP=cat(2,mostrarLL1KP,aux2);
    end
    [numX,numY,~] = find(LL1KP);
    disp(['Puntos en 1ra octava = ' num2str(size(numX,1))]);
% 
% %-------------------------------------------------------
% %   2da Octava
% %------------------------------------------------------
    LLmin=min(min(min(LL2)));
    LLmax=max(max(max(LL2)));
    LL2=(1/(LLmax-LLmin))*(LL2-LLmin);
    LL2KP=zeros(H2,W2,4);
    mostrarLL2KP=cornerPoints([1,1]);
    for i=1:4
        aux=reshape(LL2(i,:,:),size(F2));
        aux2=detectFASTFeatures(aux,'MinQuality',minQuality,'MinContrast',minContrast);
%         aux2=selectStrongest(aux2,5);  
        for j = 1 : aux2.Count
            x=aux2(j).Location;
            LL2KP(floor(x(2)),floor(x(1)),i)=1;
        end
        mostrarLL2KP=cat(2,mostrarLL2KP,aux2);
    end
     [numX,numY,~] = find(LL2KP);
    disp(['Puntos en 1ra octava = ' num2str(size(numX,1))]);
    
% %-------------------------------------------------------
% %   3ra Octava
% %-------------------------------------------------------
    LLmin=min(min(min(LL3)));
    LLmax=max(max(max(LL3)));
    LL3=(1/(LLmax-LLmin))*(LL3-LLmin);
    LL3KP=zeros(H3,W3,4);
    mostrarLL3KP=cornerPoints([1,1]);
    for i=1:4
        aux=reshape(LL3(i,:,:),size(F3));
        aux2=detectFASTFeatures(aux,'MinQuality',minQuality,'MinContrast',minContrast);
%          aux2=selectStrongest(aux2,5);  
        for j = 1 : aux2.Count
            x=aux2(j).Location;
            LL3KP(floor(x(2)),floor(x(1)),i)=1;
        end
        mostrarLL3KP=cat(2,mostrarLL3KP,aux2);
    end
     [numX,numY,~] = find(LL3KP);
    disp(['Puntos en 1ra octava = ' num2str(size(numX,1))]);
% 
% %-------------------------------------------------------
% %   4ra Octava
% %-------------------------------------------------------
    LLmin=min(min(min(LL4)));
    LLmax=max(max(max(LL4)));
    LL4=(1/(LLmax-LLmin))*(LL4-LLmin);
    LL4KP=zeros(H4,W4,4);
    mostrarLL4KP=cornerPoints([1,1]);
    for i=1:4
        aux=reshape(LL4(i,:,:),size(F4));
        aux2=detectFASTFeatures(aux,'MinQuality',minQuality,'MinContrast',minContrast);
%          aux2=selectStrongest(aux2,5); 
        for j = 1 : aux2.Count
            x=aux2(j).Location;
            LL4KP(floor(x(2)),floor(x(1)),i)=1;
        end
        mostrarLL4KP=cat(2,mostrarLL4KP,aux2);
    end
     [numX,numY,~] = find(LL4KP);
    disp(['Puntos en 1ra octava = ' num2str(size(numX,1))]);
% %-------------------------------------------------------
% %   5ta Octava
% %-------------------------------------------------------
    LLmin=min(min(min(LL5)));
    LLmax=max(max(max(LL5)));
    LL5=(1/(LLmax-LLmin))*(LL5-LLmin);
    LL5KP=zeros(H5,W5,4);
    mostrarLL5KP=cornerPoints([1,1]);
    for i=1:4
        aux=reshape(LL5(i,:,:),size(F5));
        aux2=detectFASTFeatures(aux,'MinQuality',minQuality,'MinContrast',minContrast);
%          aux2=selectStrongest(aux2,5); 
        for j = 1 : aux2.Count
            x=aux2(j).Location;
            LL5KP(floor(x(2)),floor(x(1)),i)=1;
        end
        mostrarLL5KP=cat(2,mostrarLL5KP,aux2);
    end
     [numX,numY,~] = find(LL5KP);
    disp(['Puntos en 1ra octava = ' num2str(size(numX,1))]);

% Obteniendo los descriptores 
% imshow(reshape(LL4KP(:,:,1),size(F4)))
% plot(mostrarLL4KP)
% Direccion predominante

% c1=mostrarLL1KP.Count;
% c2=mostrarLL2KP.Count;
% c3=mostrarLL3KP.Count;
% c4=mostrarLL4KP.Count;
%  Puntos= [mostrarLL1KP(2:c1).Location;
%               mostrarLL2KP(2:c2).Location*2; 
%               mostrarLL3KP(2:c3).Location*4; 
%              mostrarLL4KP(2:c4).Location*8];
% 
% [featuredescriptions,Locaciones] = extractFeatures(Imagen,Puntos);

% [~,HL1,WL1]=size(LL1);
% LL1KP=zeros(HL1,WL1,3);
% octava=1;
% for centerlevel = minlevel+1 : maxlevel
%     [x,y] = findExtremaFast(LL1,WL1,HL1,centerlevel);
%     for i=1 :size(x,1)
%         LL1KP(x(i,1),y(i,1),centerlevel)=1;
%     end
% end
% 
% [~,HL2,WL2]=size(LL2);
% octava=2;
% LL2KP=zeros(HL2,WL2,3);
% for centerlevel = minlevel+1 : maxlevel
%     [x,y] = findExtremaFast(LL2,WL2,HL2,centerlevel);
%     for i=1 :size(x,1)
%         LL2KP(x(i,1),y(i,1),centerlevel)=1;
%     end
% end
% 
% [~,HL3,WL3]=size(LL3);
% octava=3;
% LL3KP=zeros(HL3,WL3,3);
% for centerlevel = minlevel+1 : maxlevel
%     [x,y] = findExtremaFast(LL3,WL3,HL3,centerlevel);
%     for i=1 :size(x,1)
%         LL3KP(x(i,1),y(i,1),centerlevel)=1;
%     end
% end
% 
% [~,HL4,WL4]=size(LL4);
% octava=4;
% LL4KP=zeros(HL4,WL4,3);
% for centerlevel = minlevel+1 : maxlevel
%     [x,y] = findExtremaFast(LL4,WL4,HL4,centerlevel);
%     for i=1 :size(x,1)
%         LL4KP(x(i,1),y(i,1),centerlevel)=1;
%     end
% end
% 
% [~,HL5,WL5]=size(LL5);
% octava=5;
% LL5KP=zeros(HL5,WL5,3);
% for centerlevel = minlevel+1 : maxlevel
%     [x,y] = findExtremaFast(LL5,WL5,HL5,centerlevel);
%     for i=1 :size(x,1)
%         LL5KP(x(i,1),y(i,1),centerlevel)=1;
%     end
% end

% imagenes={F, F2, F3, F4};
% displayKeypoints(imagenes,locations, octavas,minlevel,maxlevel,length1);
% toc
% 
% %---------------------------------------------------------------
% % Outlier rejection
% %-------------------------------------------------------
LLA={LL1,LL2,LL3,LL4,LL5};
KP={LL1KP,LL2KP,LL3KP,LL4KP,LL5KP};
GLA={GL1,GL2,GL3,GL4,GL5};
% 
% 
% [Locaciones] = harrisCornerRejection(LLA,H,W,length1,octavas,locations,minlevel,maxlevel);
% 
% toc
% 
% displayKeypoints(imagenes, Locaciones, octavas,minlevel,maxlevel,length1);

[dominantDirections, Locaciones]= calculateDominantOrientation(octavas,minlevel,maxlevel,GLA,KP);
tiempo = toc;
disp(['Tiempo en orientacion = ' num2str(tiempo)]);

% displayKeypointsDirections(F,dominantDirections,Locaciones);
% toc
[featuredescriptions, featurelocations] = calculateSIFTDescriptor(GLA,Locaciones,dominantDirections);
tiempo = toc;
disp(['Tiempo en descriptores = ' num2str(tiempo)]);

% c1=mostrarLL1KP.Count;
% c2=mostrarLL2KP.Count;
% c3=mostrarLL3KP.Count;
% c4=mostrarLL4KP.Count;
% c5=mostrarLL5KP.Count;
% 
% Locaciones= [mostrarLL1KP(2:c1).Location;
%              mostrarLL2KP(2:c2).Location*2; 
%              mostrarLL3KP(2:c3).Location*4; 
%              mostrarLL4KP(2:c4).Location*8;
%              mostrarLL5KP(2:c5).Location*16];
%  [cuenta,~]=size(Locaciones);
 
 
 %[featuredescriptions, featurelocations] =extractFeatures(Imagen,Locaciones);

%  figure
%  imshow(Imagen)
%  for a=1:cuenta  
%      hold on
%  plot(Locaciones(a,1),Locaciones(a,2),'r*')
%  end
    toc
end