% Divide la imagen por producto.
function [products,posProductos] = splitByProduct(shelfs, draw)

    products={};
    posProductos={[1,1]};
    for i=1:length(shelfs)
        I = shelfs{i};
        [IH,IW] = size(I);
        I = imcrop(I,[1 IH/3 IW IH]);
        
        BW = edge(I,'canny');   % Filtro detector de bordes.

        [H,T,R] = hough(BW,'Theta',0);

        % Encuentra los puntos característicos destacables.
        P  = houghpeaks(H,20,'threshold',ceil(0.3*max(H(:))));

        % Encuentra líneas (divisiones de estantes).
        lines = houghlines(BW,T,R,P,'FillGap',200,'MinLength',10);
        
%         figure, imshow(I), hold on
%         max_len = 0;
%         if draw==true
%             for k = 1:length(lines)
%                xy = [lines(k).point1; lines(k).point2];
%                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%                % Plot beginnings and ends of lines
%                plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%                plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%                % Determine the endpoints of the longest line segment
%                len = norm(lines(k).point1 - lines(k).point2);
%                if ( len > max_len)
%                   max_len = len;
%                   xy_long = xy;
%                end
%             end
%         end

        % Ordena coordenadas en Y quitando repetidas.
        sortedX = sortXCoords(I, lines);

        % Obtiene los productos.
        for k = 2:length(sortedX)
            imagenProducto = I(1:size(I,1),sortedX(k-1)+1:sortedX(k),1);
            products{end+1} = imresize(imagenProducto,1);
            posProductos{end+1} = [i sortedX(k)];
        end
        
        figure();
        imshow(shelfs{i});
        hold on;
        if draw==1
             for k = 2:length(sortedX)
                 height = IH;
                line([sortedX(k-1) sortedX(k-1)],[1 height]);
            end
        end

       
    end
end