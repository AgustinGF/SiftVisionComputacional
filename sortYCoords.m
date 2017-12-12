function [sortedY] = sortYCoords(I, lines)

    % Ordena las coordenadas en Y de las líneas encontradas.
    fullSortedY = zeros(1,length(lines)+1);             % Agrega coordenada superior.
    for k = 2:length(lines)+1
        fullSortedY(k)=lines(k-1).point1(2);
    end
    fullSortedY(length(fullSortedY) + 1) = size(I,1);   % Agrega coordenada inferior.
    fullSortedY = sort(fullSortedY);

    % Quita coordenadas Y detectadas en el mismo eje.
    sortedY = fullSortedY;
    for k = length(fullSortedY):-1:2
        if (fullSortedY(k) == fullSortedY(k-1))
            sortedY(k) = [];
        end
    end
end