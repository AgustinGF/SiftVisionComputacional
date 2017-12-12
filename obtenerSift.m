function [featuredescriptions,featurelocations]= obtenerSift(Imagen)
    
tic;

    %Valores independientes
    sigma=1.6;
    kvalue=sqrt(2);
    minlevel=1;
    levels = 2;
    octavas=5;
    
    %Valores dependientes
    sigmaValue=sigma;
    maxlevel=minlevel+levels;
    
    F=Imagen;
    [H,W]=size(F);
    featuredescriptions=[];
    Locaciones=[];
    numGaussianas = maxlevel+2;
    numLaplacianos = maxlevel+1;
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
    for i=1:maxlevel
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
    for i=1:maxlevel
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
    for i=1:maxlevel
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
    for i=1:maxlevel
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
    for i=1:maxlevel
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

KP={LL1KP,LL2KP,LL3KP,LL4KP,LL5KP};
LLA={LL1,LL2,LL3,LL4,LL5};
GLA={GL1,GL2,GL3,GL4,GL5};
%% Codigo para obtener nuestros puntos
% KP={};
% for octave = 1 : octavas   
%     array = LLA{octave};
%     [~,HL,WL]=size(array);
%     LLKP=zeros(HL,WL,levels);
%                 
%     for centerlevel = minlevel+1 : maxlevel
%         for i = 2: HL - 1
%             for j = 2: WL -1
%                 if findextrema2(LL1, i, j, centerlevel) == 1
%                     LLKP(i,j, centerlevel) = 1;
%                 end
%             end
%         end
%     end
%     KP{end+1}=LLKP;
% end
% 
% tiempo = toc;
% disp(['Tiempo en keypoints = ' num2str(tiempo)]);


% 
% %---------------------------------------------------------------
% % Outlier rejection
% %-------------------------------------------------------

% 
% 
%[KP] = harrisCornerRejection(LLA,octavas,KP,minlevel);
%tiempo = toc;
%disp(['Tiempo en harris = ' num2str(tiempo)]);
% 
% displayKeypoints(imagenes, Locaciones, octavas,minlevel,maxlevel,length1);

% [dominantDirections, Locaciones]= calculateDominantOrientation(octavas,minlevel,GLA,KP);
% tiempo = toc;
% disp(['Tiempo en orientacion = ' num2str(tiempo)]);

% displayKeypointsDirections(F,dominantDirections,Locaciones);
% toc
%  [featuredescriptions, featurelocations] = calculateSIFTDescriptor(GLA,Locaciones,dominantDirections);
% tiempo = toc;
% disp(['Tiempo en descriptores = ' num2str(tiempo)]);

c1=mostrarLL1KP.Count;
c2=mostrarLL2KP.Count;
c3=mostrarLL3KP.Count;
c4=mostrarLL4KP.Count;
c5=mostrarLL5KP.Count;

Locaciones= [mostrarLL1KP(2:c1).Location;
             mostrarLL2KP(2:c2).Location*2; 
             mostrarLL3KP(2:c3).Location*4; 
             mostrarLL4KP(2:c4).Location*8;
             mostrarLL5KP(2:c5).Location*16];
 [cuenta,~]=size(Locaciones);
 
 
 [featuredescriptions, featurelocations] =extractFeatures(Imagen,Locaciones);

 figure
 imshow(Imagen)
%% Codigo para mostrar nuestros puntos
%  for octava=1:octavas
%       P=KP{octava};
%       
%      for level=minlevel+1:maxlevel
%          
%             [~,~,numLevels]=size(P);
%             if level > numLevels
%                 break;
%             end
%          
%           [r,c]=find(P(:,:,level));
%           [length1,~] = size(r);
%             
%             for k = 1 : length1
%                 y = r(k);
%                 x = c(k);
%                 hold on
%                 plot(x,y,'r*') 
%             end
%      end
%  end

%% Codigo para mostrar los puntos de surf
 
 for a=1:cuenta  
     hold on
 plot(Locaciones(a,1),Locaciones(a,2),'r*')
 end
    toc
end