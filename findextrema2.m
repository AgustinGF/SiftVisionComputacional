function [truthvalue] = findextrema2(array, i, j, centerlevel)
            maxVal = false;
            truthvalue = false;
            minVal = false;
            
            pixelActual = array(centerlevel,i,j);
            
            % Comparaciones en el mismo nivel para maximos
            if pixelActual > array(centerlevel,i-1,j-1) && pixelActual > array(centerlevel,i-1,j) && pixelActual > array(centerlevel,i-1,j+1) &&  pixelActual > array(centerlevel,i,j-1) && pixelActual > array(centerlevel,i,j+1) &&  pixelActual > array(centerlevel,i+1,j-1) && pixelActual > array(centerlevel,i+1,j) && pixelActual > array(centerlevel,i+1,j+1)
                maxVal = true;
            end
            
            % Comparaciones en el nivel superior para maximos
            if maxVal && pixelActual > array(centerlevel+1,i-1,j-1) && pixelActual > array(centerlevel+1,i-1,j) && pixelActual > array(centerlevel+1,i-1,j+1) &&  pixelActual > array(centerlevel+1,i,j-1) && pixelActual > array(centerlevel+1,i,j+1) &&  pixelActual > array(centerlevel+1,i+1,j-1) && pixelActual > array(centerlevel+1,i+1,j) && pixelActual > array(centerlevel+1,i+1,j+1)
                maxVal = true;
            end
            
             % Comparaciones en el nivel inferior para maximos
            if maxVal && pixelActual > array(centerlevel-1,i-1,j-1) && pixelActual > array(centerlevel-1,i-1,j) && pixelActual > array(centerlevel-1,i-1,j+1) &&  pixelActual > array(centerlevel-1,i,j-1) && pixelActual > array(centerlevel-1,i,j+1) &&  pixelActual > array(centerlevel-1,i+1,j-1) && pixelActual > array(centerlevel-1,i+1,j) && pixelActual > array(centerlevel-1,i+1,j+1)
                maxVal = true;
            end
            
            if maxVal == true
                truthvalue = true;
                return;
            end
            
            % Comparaciones en el mismo nivel para minimos
            if pixelActual < array(centerlevel,i-1,j-1) && pixelActual < array(centerlevel,i-1,j) && pixelActual < array(centerlevel,i-1,j+1) &&  pixelActual < array(centerlevel,i,j-1) && pixelActual < array(centerlevel,i,j+1) &&  pixelActual < array(centerlevel,i+1,j-1) && pixelActual < array(centerlevel,i+1,j) && pixelActual < array(centerlevel,i+1,j+1)
                minVal = true;
            end
            
            % Comparaciones en el nivel superior para minimos
            if minVal && pixelActual < array(centerlevel+1,i-1,j-1) && pixelActual < array(centerlevel+1,i-1,j) && pixelActual < array(centerlevel+1,i-1,j+1) &&  pixelActual < array(centerlevel+1,i,j-1) && pixelActual < array(centerlevel+1,i,j+1) &&  pixelActual < array(centerlevel+1,i,j) &&  pixelActual < array(centerlevel+1,i+1,j-1) && pixelActual < array(centerlevel+1,i+1,j) && pixelActual < array(centerlevel+1,i+1,j+1)
                minVal = true;
            end
            
             % Comparaciones en el nivel inferior para minimos
            if minVal && pixelActual < array(centerlevel-1,i-1,j-1) && pixelActual < array(centerlevel-1,i-1,j) && pixelActual < array(centerlevel-1,i-1,j+1) &&  pixelActual < array(centerlevel-1,i,j-1) && pixelActual < array(centerlevel-1,i,j+1) &&  pixelActual < array(centerlevel-1,i,j) &&  pixelActual < array(centerlevel-1,i+1,j-1) && pixelActual < array(centerlevel-1,i+1,j) && pixelActual < array(centerlevel-1,i+1,j+1)
                minVal = true;
            end
            
            if minVal == true
                truthvalue = true;
                return;
            end
            
        end