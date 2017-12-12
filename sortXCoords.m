function [sortedX] = sortXCoords(I, lines)

    % Ordena las coordenadas en X de las líneas encontradas.
    fullSortedX = zeros(1,length(lines)+1);             % Agrega coordenada derecha.
    for k = 2:length(lines)+1
        fullSortedX(k)=lines(k-1).point2(1);
    end
    fullSortedX(length(fullSortedX) + 1) = size(I,1);   % Agrega coordenada inferior.
    fullSortedX = sort(fullSortedX);

    % Quita coordenadas X detectadas en el mismo eje.
    sortedX = fullSortedX;
    for k = length(fullSortedX):-1:2
        if (fullSortedX(k) == fullSortedX(k-1))
            sortedX(k) = [];
        end
    end
end