% Divide la imagen por estante.
function [shelf posshelf] = splitByShelf(I, draw)

    BW = edge(I,'sobel');   % Filtro detector de bordes.
    [H,T,R] = hough(BW);    % Transformada de Hough.

    % Encuentra los puntos caracter�sticos destacables.
    P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));

    % Encuentra l�neas (divisiones de estantes).
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
        % Dibuja l�neas de Hough.
        drawHoughLines(I, lines);

        % Dibuja estantes.
        figure;
        for k = 1:length(shelf)
            subplot(length(shelf),1,k);
            imshow(shelf{k});
        end
    end
end