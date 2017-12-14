% Divide la imagen por estante.
function [shelf posshelf] = splitByShelf(I, draw)

    i1 = imadjust(I,[0.3 0.7],[]);
    BW = edge(i1,'sobel');   % Filtro detector de bordes.

    [H,T,R] = hough(BW);    % Transformada de Hough.

    % Encuentra los puntos característicos destacables.
    P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));

    % Encuentra líneas (divisiones de estantes).
    lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',100);

    % Ordena coordenadas en Y quitando repetidas.
    sortedY = sortYCoords(I, lines);

    % Obtiene estantes.
    shelf={0};
    posshelf={1};
    for k = 2:length(sortedY)
        imagenEstante = I(sortedY(k-1)+1:sortedY(k),1:size(I,2),1);
        shelf{k-1} = imresize(imagenEstante,1);
        posshelf{end+1}=sortedY(k);
    end

    % Dibuja el proceso.
    if(draw)
        figure;
        imshow(i1);

        figure;
        imshow(BW);

        % Dibuja líneas de Hough.
        drawHoughLines(I, lines);

        figure;
        drawSplits(I, sortedY);  

        % Dibuja estantes.
        figure;
        for k = 1:length(shelf)
            subplot(length(shelf),1,k);
            imshow(shelf{k});
        end
    end
end

function drawSplits(I, Y)
    imshow(I), hold on
    for k = 2:length(Y)-1
       plot([0,size(I,2)], [Y(k), Y(k)],'LineWidth',3,'Color','green');
    end
end

function drawHoughLines(I, lines)
    imshow(I), hold on
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','green');
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    end
end