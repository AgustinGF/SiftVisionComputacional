function [truthvalue] = findextrema(array, i, j, centerlevel)
            truthvalue= 0;
            % find if the centerlevel pixel is the local maxima or minima
            centerpixel  = array(centerlevel,i,j);
            %find all the neighbouring 26 points.
            neighbours = array(centerlevel-1:centerlevel+1,i-1:i+1, j-1:j+1);
            neighbours= neighbours(:);
            neighbours(14) = [];
            
            %find if greater than all values or smaller than all values
            maxvalue = max(neighbours);
            minvalue = min(neighbours);
            
            % store all the points in location so that they can be
            % used later
            if (centerpixel > maxvalue)
                truthvalue = 1;
            elseif (centerpixel < minvalue)
                truthvalue = 1;
            end
        end