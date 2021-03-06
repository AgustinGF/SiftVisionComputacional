function [sortedX] = sortXCoords(I, lines)

    % Ordena las coordenadas en X de las l�neas encontradas.
    fullSortedX = zeros(1,length(lines)+1);             % Agrega coordenada derecha.
    for k = 2:length(lines)+1
        fullSortedX(k)=lines(k-1).point2(1);
    end
    fullSortedX(length(fullSortedX) + 1) = size(I,1);   % Agrega coordenada inferior.
    fullSortedX = sort(fullSortedX);

    % Quita coordenadas X detectadas en el mismo eje, o que estan muy cerca
    tol = 100;
    sortedX = fullSortedX;
    for k = length(fullSortedX)-1:-1:1
        if (fullSortedX(k) == fullSortedX(k+1))
            sortedX(k) = [];
        else if (fullSortedX(k+1) - fullSortedX(k) <tol)
            sortedX(k) = [];
        end
    end
end