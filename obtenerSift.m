function [featuredescriptions,featurelocations]= obtenerSift(Imagen)
    
tic;
    sigma=1.6;
    sigmaValue=sigma;
    kvalue=sqrt(2);
    minlevel=1;
    maxlevel=4;
    octavas=4;
    length1=3;
    F=Imagen;
    [H,W]=size(F);
    featuredescriptions=[];
    Locaciones=[];
    %Obteniendo la Primera Octava
    GL1=zeros(5,H,W);
   
    for i=1:5
        GL1(i,:,:)= imgaussfilt(F,(kvalue^i)*sigma);
    end
    GL1min=min(min(min(GL1)));
    GL1max=max(max(max(GL1)));
    GL1=(1/(GL1max-GL1min))*(GL1-GL1min);
    
    %Laplacianos de primera Octava
    LL1=zeros(4,H,W);
    for i=1:4
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
    GL2=zeros(5,H2,W2);
    for i=1:5
        GL2(i,:,:)= imgaussfilt(F2,(kvalue^i)*sigma);
    end
     GL2min=min(min(min(GL2)));
    GL2max=max(max(max(GL2)));
    GL2=(1/(GL2max-GL2min))*(GL2-GL2min);
    
%   Laplacianos de Segunda Octava
    LL2=zeros(4,H2,W2);
    for i=1:4
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
    GL3=zeros(5,H3,W3);
    for i=1:5
        GL3(i,:,:)= imgaussfilt(F3,(kvalue^i)*sigma);
    end
    GL3min=min(min(min(GL3)));
    GL3max=max(max(max(GL3)));
    GL3=(1/(GL3max-GL3min))*(GL3-GL3min);
    
%   Laplacianos de Tercera Octava
    LL3=zeros(4,H3,W3);
    for i=1:4
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
    GL4=zeros(5,H4,W4);
    for i=1:5
        GL4(i,:,:)= imgaussfilt(F4,(kvalue^i)*sigma);
    end
    GL4min=min(min(min(GL4)));
    GL4max=max(max(max(GL4)));
    GL4=(1/(GL4max-GL4min))*(GL4-GL4min);
    
%   Laplacianos de Cuarta Octava
    LL4=zeros(4,H4,W4);
    for i=1:4
        LL4(i,:,:)= GL4(i,:,:)-GL4(i+1,:,:);
    end
%-------------------------------------------------------------
%   Obteniendo los puntos de inter?s
%---------------------------------------------------------------
minContrast=.015;
minQuality=.3;
%1ra Octava
%-------------------------------------------------------
%     LLmin=min(min(min(LL1)));
%     LLmax=max(max(max(LL1)));
%     LL1=(1/(LLmax-LLmin))*(LL1-LLmin);
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
% 
% %-------------------------------------------------------
% %   2da Octava
% %------------------------------------------------------
%     LLmin=min(min(min(LL2)));
%     LLmax=max(max(max(LL2)));
%     LL2=(1/(LLmax-LLmin))*(LL2-LLmin);
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
% %-------------------------------------------------------
% %   3ra Octava
% %-------------------------------------------------------
%     LLmin=min(min(min(LL3)));
%     LLmax=max(max(max(LL3)));
%     LL3=(1/(LLmax-LLmin))*(LL3-LLmin);
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
% 
% %-------------------------------------------------------
% %   4ra Octava
% %-------------------------------------------------------
%     LLmin=min(min(min(LL4)));
%     LLmax=max(max(max(LL4)));
%     LL4=(1/(LLmax-LLmin))*(LL4-LLmin);
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
% octava=1;
% for centerlevel = minlevel+1 : maxlevel-1
%     [x,y] = findExtremaFast(LL1,WL1,HL1,centerlevel);
%     for i=1 :size(x,1)
%         locations(x(i,1),y(i,1),centerlevel,octava)=1;
%     end
% end
% 
% [~,HL2,WL2]=size(LL2);
% octava=2;
% for centerlevel = minlevel+1 : maxlevel-1
%     [x,y] = findExtremaFast(LL2,WL2,HL2,centerlevel);
%     for i=1 :size(x,1)
%         locations(x(i,1),y(i,1),centerlevel,octava)=1;
%     end
% end
% 
% [~,HL3,WL3]=size(LL3);
% octava=3;
% for centerlevel = minlevel+1 : maxlevel-1
%     [x,y] = findExtremaFast(LL3,WL3,HL3,centerlevel);
%     for i=1 :size(x,1)
%         locations(x(i,1),y(i,1),centerlevel,octava)=1;
%     end
% end
% 
% [~,HL4,WL4]=size(LL4);
% octava=4;
% for centerlevel = minlevel+1 : maxlevel-1
%     [x,y] = findExtremaFast(LL4,WL4,HL4,centerlevel);
%     for i=1 :size(x,1)
%         locations(x(i,1),y(i,1),centerlevel,octava)=1;
%     end
% end
% 
% imagenes={F, F2, F3, F4};
% displayKeypoints(imagenes,locations, octavas,minlevel,maxlevel,length1);
% toc
% 
% %---------------------------------------------------------------
% % Outlier rejection
% %-------------------------------------------------------
LLA={LL1,LL2,LL3,LL4};
KP={LL1KP,LL2KP,LL3KP,LL4KP};
GLA={GL1,GL2,GL3,GL4};
% 
% 
% [Locaciones] = harrisCornerRejection(LLA,H,W,length1,octavas,locations,minlevel,maxlevel);
% 
% toc
% 
% displayKeypoints(imagenes, Locaciones, octavas,minlevel,maxlevel,length1);

[dominantDirections, Locaciones]= calculateDominantOrientation(octavas,minlevel,maxlevel,GLA,KP);
% toc
% displayKeypointsDirections(F,dominantDirections,Locaciones);
% toc
[featuredescriptions, featurelocations] = calculateSIFTDescriptor(GLA,Locaciones,dominantDirections);
% toc

% c1=mostrarLL1KP.Count;
% c2=mostrarLL2KP.Count;
% c3=mostrarLL3KP.Count;
% c4=mostrarLL4KP.Count;
% 
% Locaciones= [mostrarLL1KP(2:c1).Location;
%              mostrarLL2KP(2:c2).Location*2; 
%              mostrarLL3KP(2:c3).Location*4; 
%              mostrarLL4KP(2:c4).Location*8];
%  [cuenta,~]=size(Locaciones);
 
 
 %[featuredescriptions, featurelocations] =extractFeatures(Imagen,Locaciones);
% 
%  figure
%  imshow(Imagen)
%  for a=1:cuenta  
%      hold on
%  plot(Locaciones(a,1),Locaciones(a,2),'r*')
%  end

end