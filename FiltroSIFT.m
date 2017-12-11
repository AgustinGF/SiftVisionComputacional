%function [featuredescriptions,Locaciones]= obtenerSift(Imagen)
    sigma=1.6;
    sigmaValue=sigma;
    kvalue=sqrt(2);
    F=Imagen;
    [H,W]=size(F);

    %Obteniendo la Primera Octava
    GL1=zeros(5,H,W);
   
    for i=1:5
        GL1(i,:,:)= imgaussfilt(F,(kvalue^i)*sigma);
    end
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
%   Laplacianos de Cuarta Octava
    LL4=zeros(4,H4,W4);
    for i=1:4
        LL4(i,:,:)= GL4(i,:,:)-GL4(i+1,:,:);
    end
%-------------------------------------------------------------
%   Obteniendo los puntos de interés
%---------------------------------------------------------------
%1ra Octava
%-------------------------------------------------------
%     LLmin=min(min(min(LL1)));
%     LLmax=max(max(max(LL1)));
%     LL1=(1/(LLmax-LLmin))*(LL1-LLmin);
    LL1KP=zeros(H,W,4);
    mostrarLL1KP=cornerPoints([1,1]);
    for i=2:4
        aux=reshape(LL1(i,:,:),size(F));
        aux2=detectHarrisFeatures(aux,'MinQuality',0.3,'FilterSize',7);
        aux2=selectStrongest(aux2,20);   
        for j = 1 : aux2.Count
            x=aux2(j).Location;
            LL1KP(ceil(x(2)),ceil(x(1)),i)=1;
        end
        mostrarLL1KP=cat(2,mostrarLL1KP,aux2);
    end

%-------------------------------------------------------
%   2da Octava
%------------------------------------------------------
%     LLmin=min(min(min(LL2)));
%     LLmax=max(max(max(LL2)));
%     LL2=(1/(LLmax-LLmin))*(LL2-LLmin);
    LL2KP=zeros(H2,W2,4);
    mostrarLL2KP=cornerPoints([1,1]);
    for i=2:4
        aux=reshape(LL2(i,:,:),size(F2));
        aux2=detectHarrisFeatures(aux,'MinQuality',0.3,'FilterSize',7);
        aux2=selectStrongest(aux2,20);   
        for j = 1 : aux2.Count
            x=aux2(j).Location;
            LL2KP(ceil(x(2)),ceil(x(1)),i)=1;
        end
        mostrarLL2KP=cat(2,mostrarLL2KP,aux2);
    end
%-------------------------------------------------------
%   3ra Octava
%-------------------------------------------------------
%     LLmin=min(min(min(LL3)));
%     LLmax=max(max(max(LL3)));
%     LL3=(1/(LLmax-LLmin))*(LL3-LLmin);
    LL3KP=zeros(H3,W3,4);
    mostrarLL3KP=cornerPoints([1,1]);
    for i=2:4
        aux=reshape(LL3(i,:,:),size(F3));
        aux2=detectHarrisFeatures(aux,'MinQuality',0.3,'FilterSize',7);
        aux2=selectStrongest(aux2,20);  
        for j = 1 : aux2.Count
            x=aux2(j).Location;
            LL3KP(ceil(x(2)),ceil(x(1)),i)=1;
        end
        mostrarLL3KP=cat(2,mostrarLL3KP,aux2);
    end

%-------------------------------------------------------
%   4ra Octava
%-------------------------------------------------------
%     LLmin=min(min(min(LL4)));
%     LLmax=max(max(max(LL4)));
%     LL4=(1/(LLmax-LLmin))*(LL4-LLmin);
    LL4KP=zeros(H4,W4,4);
    mostrarLL4KP=cornerPoints([1,1]);
    for i=2:4
        aux=reshape(LL4(i,:,:),size(F4));
        aux2=detectHarrisFeatures(aux,'MinQuality',0.3,'FilterSize',7);
        aux2=selectStrongest(aux2,20); 
        for j = 1 : aux2.Count
            x=aux2(j).Location;
            LL4KP(ceil(x(2)),ceil(x(1)),i)=1;
        end
        mostrarLL4KP=cat(2,mostrarLL4KP,aux2);
    end

%Obteniendo los descriptores 
% imshow(reshape(LL4KP(:,:,1),size(F4)))
%plot(mostrarLL4KP)
%Direccion predominante

    featuredescriptions = [];
    dominantDirections=[];
    % magnitudes = [];
    % orientations = [];
    minlevel=1;
    maxlevel=5;
    length=maxlevel-minlevel;
    figure
    imshow(F) 
    for octave = 1 : 4    
     for centerlevel = minlevel + 1 : maxlevel - 1
         
         switch octave
             case 1
                 [r,c]=find(LL1KP(:,:,centerlevel));
                 [length1,~] = size(r);
                 [~,rows,cols]=size(GL1);
                 GL=GL1;  
                
             case 2
                 [r,c]=find(LL2KP(:,:,centerlevel));
                 [length1,~] = size(r);
                 [~,rows,cols]=size(GL2);
                 GL=GL2;
                 
             case 3
                 [r,c]=find(LL3KP(:,:,centerlevel));
                 [length1,~] = size(r);
                 [~,rows,cols]=size(GL3);
                 GL=GL3;
                
             case 4
                 [r,c]=find(LL4KP(:,:,centerlevel));
                 [length1,~] = size(r);
                 [~,rows,cols]=size(GL4);
                 GL=GL4;
         end;

            for k = 1 : length1
                 locx = ceil(r(k));
                 locy = ceil(c(k));
                       
                magnitudes = [];
                orientations = [];
                %Encontramos orientacion y magnitud en la vecindad de 4x4
                 m1 = locx - 2;
                 m2 = locx + 2;
                 n1 = locy - 2;
                 n2 = locy + 2;
                %Corrigiendo limites de la ventana para no exceder
                        if m1 < 2
                            delta = 2 - m1;
                            m2 = m2 + delta;
                            m1 = 2;
                        elseif m2 > rows - 2
                            delta = m2 - rows + 1;
                            m1 = m1 - delta;
                            m2 = rows - 1;
                        end
                        if n1 < 2
                            delta = 2 - n1;
                            n2 = n2 + delta;
                            n1 = 2;
                        elseif n2 > cols - 2
                            delta = n2 - cols + 1;
                            n1 = n1 - delta;
                            n2 = cols - 1;
                        end
                        
                for i = m1 : m2

                    magnitudes1 = [];
                    orientations1 = [];
                    for j = n1 : n2
                        %Calcular magnitud y orientacion
                        dx = GL(centerlevel,i+1,j)-GL(centerlevel,i-1,j);
                        dy = GL(centerlevel,i,j+1)-GL(centerlevel,i,j-1);
                        magnitude = sqrt(dx*dx + dy*dy);
                        magnitudes1 =[magnitudes1 magnitude];
                         if dx == 0
                                    if dy == 0
                                        orientation = 1;
                                    else
                                    dx = 1;
                                    dy = 100000;
                                    orientation = atand(dy/dx);
                                    end
                         else
                             orientation = atand(dy/dx);
                         end
                        %corrigiendo la orientacion de 0-180 a 0-360
                         if orientation > 0 && orientation < 90
                            if GL(centerlevel,i-1,j) > GL(centerlevel,i+1,j)
                                orientation = orientation + 180;
                            end
                        elseif orientation <= 0 && orientation > -90
                            if GL(centerlevel,i-1,j) > GL(centerlevel,i+1,j)
                                orientation = orientation + 360;
                            else
                                orientation = orientation + 180;
                            end
                         end
                        orientations1=[orientations1 orientation];
                    end
                    
                    magnitudes =[magnitudes ;magnitudes1];
                    orientations = [orientations; orientations1];
                            
                end

                %Encontrar histograma de orientaciones en la vecindad
                histogram = zeros(1,36);
                
                Sigma = sigmaValue * (kvalue ^ centerlevel);
                width = floor(6 * Sigma + 1);
                gfilter = fspecial('gaussian', width, Sigma);
                magnitudes = conv2(magnitudes, gfilter, 'same');
                        
                [lengtha,lengthb] = size(magnitudes);
                angle = 360/36;
                for a = 1 : lengtha
                   for b = 1 : lengthb
                       bin = ceil(orientations(a,b)/angle);
                       histogram(1,bin ) =  histogram(1,bin) + magnitudes(a,b);
                   end
                end

                 %Ejemplo para visualizar el histograma:
                 
                 figure;
                 bar(10:10:360, histogram)
                 
                 break
                 
                
                %Encontrando la direccion dominante en el histograma
                combined = [histogram; 1:36]';
                sortedvalues = sortrows(combined, 1);
                %maxvalue = [sortedvalues(36,1)];
                domiantdirections = [sortedvalues(36,2)];
%                 for m = 35 : -1 : 1
%                     if sortedvalues(m) > 0.8 * maxvalue(1)
%                         domiantdirections = [domiantdirections sortedvalues(m,2)];
%                     end
%                 end
                dominantDirections = [dominantDirections domiantdirections(1)];
                %Encontrando las caracteristicas del bloque de 16*16
                featuredescriptor = [];
                %Primero calcular la magnitud y la orientacion relativa
                %de todos los  16x16 valores
                
                %Determinando la ventana
                m1 = locx - 8;
                m2 = locx + 7;
                n1 = locy - 8;
                n2 = locy + 7;
                  
                %Corrigiendo limites de la ventana para no exceder
                if m1 < 2
                    delta = 2 - m1;
                    m2 = m2 + delta;
                    m1 = 2;
                elseif m2 > rows - 2
                    delta = m2 - rows + 1;
                    m1 = m1 - delta;
                    m2 = rows - 1;
                end
                if n1 < 2
                    delta = 2 - n1;
                    n2 = n2 + delta;
                    n1 = 2;
                elseif n2 > cols - 2
                    delta = n2 - cols + 1;
                    n1 = n1 - delta;
                    n2 = cols - 1;
                end
                
                for m = 1: 4
                    for n = 1:4
                        
                        mvalue = m1 + (4 * (m-1));
                        nvalue = n1 + (4 * (n-1));
                        
                        magnitudes = [];
                        orientations = [];
                        
                        %calcular los bloques 4x4
                        for a = 1: 4
                            magnitudes1 = [];
                            orientations1 = [];
                            for b = 1:4
                                i1 = mvalue + a - 1;
                                j1 = nvalue + b - 1;
                                
                                %Calculando magnitud y orientacion
                                dx = GL(centerlevel,i1+1,j1)-GL(centerlevel,i1-1,j1);
                                dy = GL(centerlevel,i1,j1+1)-GL(centerlevel,i1,j1-1);
                                magnitude = sqrt(dx*dx + dy*dy);
                                magnitudes1 =[magnitudes1 magnitude];
                                if dx == 0
                                    if dy == 0
                                        orientation = 1;
                                    else
                                        dx = 1;
                                        dy = 100000;
                                        orientation = atand(dy/dx);
                                    end
                                else
                                    orientation = atand(dy/dx);
                                end
                               
                                %Corrigiendo Orientacion de 0-180 a 0-360
                                
                            if orientation > 0 && orientation < 90
                                if GL(centerlevel,i-1,j) > GL(centerlevel,i+1,j)
                                    orientation = orientation + 180;
                                end
                            elseif orientation <= 0 && orientation > -90
                                if GL(centerlevel,i-1,j) > GL(centerlevel,i+1,j)
                                    orientation = orientation + 360;
                                else
                                    orientation = orientation + 180;
                                end
                            end
                                orientation = orientation - domiantdirections(1);
                                if orientation <= 0
                                            orientation= orientation + 360;
                                end
                                orientations1 = [orientations1 orientation];
                            end
                            magnitudes =[magnitudes ;magnitudes1];
                            orientations = [orientations; orientations1];    
                        end

                        %formando el histograma 8 bin
                        histogram = zeros(1,8);
                        Sigma = sigmaValue * (kvalue ^ centerlevel);
                        width = floor(6 * Sigma + 1);
                        gfilter = fspecial('gaussian', width, Sigma);
                        magnitudes = conv2(magnitudes, gfilter, 'same');
                        
                        [lengtha,lengthb] = size(magnitudes);
                        angle = 360/8;
                        for a = 1 : lengtha
                            for b = 1 : lengthb
                                bin = ceil(orientations(a,b)/angle);
                                histogram(1,bin ) =  histogram(1,bin) + magnitudes(a,b);
                            end
                        end

                        %concatenar el descriptor
                        featuredescriptor = [featuredescriptor histogram];
                    end
                end
                
                
                %disp(featuredescriptor);
                %Desplegado de Descriptores
                featuredescriptions= [featuredescriptions ; [featuredescriptor]];           
                        radius=80;
                        %radius = floor((H/64)*2^(octave-1));
                        yo = r(k)*(2^(octave-1));
                        xo = c(k)*(2^(octave-1));
                        ang=0:0.01:2*pi;
                        xp=radius*cos(ang);
                        yp=radius*sin(ang);
                        hold on
                        plot(xo+xp,yo+yp);
                        
                        % display the dominant direction
                        dominantdirection = domiantdirections(1);
                        x1 = xo;%-radius*cos(dominantdirection)*0.5;
                        x2 = xo+radius*cos(dominantdirection);
                        y1 = yo;%-radius*sin(dominantdirection)*0.5;
                        y2 = yo+radius*sin(dominantdirection);
                        
                        xo = linspace(x1,x2,100);
                        yo = linspace(y1,y2,100);
                        hold on
                        plot(xo,yo);
                        
                    
                
            end
     end
     %Normalizamos Descriptores
     
     [length6, ~] = size(featuredescriptions);
     for i = 1 : length6
       featuredescriptions(i,:) =  featuredescriptions(i,:)/norm(featuredescriptions(i,:));
       featuredescriptions(i,find(featuredescriptions(i,:)) > 0.2) = 0;
       featuredescriptions(i,:) =  featuredescriptions(i,:)/norm(featuredescriptions(i,:));
     end
    end
    c1=mostrarLL1KP.Count;
    c2=mostrarLL2KP.Count;
    c3=mostrarLL3KP.Count;
    c4=mostrarLL4KP.Count;
    Locaciones= [mostrarLL1KP(2:c1).Location;
                 mostrarLL2KP(2:c2).Location*2; 
                 mostrarLL3KP(2:c3).Location*4; 
                 mostrarLL4KP(2:c4).Location*8];
end