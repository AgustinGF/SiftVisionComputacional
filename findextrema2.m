function [truthvalue] = findextrema2(array, i, j, centerlevel)
            isMax=1;
            isMin=1;
            
            centerpixel  = array(centerlevel,i,j);
            
            if centerpixel>array(centerlevel,i-1,j-1) && centerpixel>array(centerlevel,i-1,j) && centerpixel>array(centerlevel,i-1,j+1) && centerpixel>array(centerlevel,i+1,j-1) && centerpixel>array(centerlevel,i+1,j) && centerpixel>array(centerlevel,i+1,j+1)&& centerpixel>array(centerlevel,i,j-1) && centerpixel>array(centerlevel,i,j+1)
                isMax=1;
            else
                isMax=0;
            end
            
            if isMax && centerpixel>array(centerlevel-1,i-1,j-1) && centerpixel>array(centerlevel-1,i-1,j) && centerpixel>array(centerlevel-1,i-1,j+1) && centerpixel>array(centerlevel-1,i+1,j-1) && centerpixel>array(centerlevel-1,i+1,j) && centerpixel>array(centerlevel-1,i+1,j+1)&& centerpixel>array(centerlevel-1,i,j-1) && centerpixel>array(centerlevel-1,i,j) && centerpixel>array(centerlevel-1,i,j+1)
                isMax=1;
            else
                isMax=0;
            end
            
             if isMax && centerpixel>array(centerlevel+1,i-1,j-1) && centerpixel>array(centerlevel+1,i-1,j) && centerpixel>array(centerlevel+1,i-1,j+1) && centerpixel>array(centerlevel+1,i+1,j-1) && centerpixel>array(centerlevel+1,i+1,j) && centerpixel>array(centerlevel+1,i+1,j+1)&& centerpixel>array(centerlevel+1,i,j-1) && centerpixel>array(centerlevel+1,i,j) && centerpixel>array(centerlevel+1,i,j+1)
                isMax=1;
            else
                isMax=0;
             end
            
             if isMax == 1
                 truthvalue = 1;
                 return;
             end
             
             if centerpixel<array(centerlevel,i-1,j-1) && centerpixel<array(centerlevel,i-1,j) && centerpixel<array(centerlevel,i-1,j+1) && centerpixel<array(centerlevel,i+1,j-1) && centerpixel<array(centerlevel,i+1,j) && centerpixel<array(centerlevel,i+1,j+1)&& centerpixel<array(centerlevel,i,j-1) && centerpixel<array(centerlevel,i,j+1)
                isMin=1;
            else
                isMin=0;
            end
            
            if isMin && centerpixel<array(centerlevel-1,i-1,j-1) && centerpixel<array(centerlevel-1,i-1,j) && centerpixel<array(centerlevel-1,i-1,j+1) && centerpixel<array(centerlevel-1,i+1,j-1) && centerpixel<array(centerlevel-1,i+1,j) && centerpixel<array(centerlevel-1,i+1,j+1)&& centerpixel<array(centerlevel-1,i,j-1) && centerpixel<array(centerlevel-1,i,j) && centerpixel<array(centerlevel-1,i,j+1)
                isMin=1;
            else
                isMin=0;
            end
            
             if isMin && centerpixel<array(centerlevel+1,i-1,j-1) && centerpixel<array(centerlevel+1,i-1,j) && centerpixel<array(centerlevel+1,i-1,j+1) && centerpixel<array(centerlevel+1,i+1,j-1) && centerpixel<array(centerlevel+1,i+1,j) && centerpixel<array(centerlevel+1,i+1,j+1)&& centerpixel<array(centerlevel+1,i,j-1) && centerpixel<array(centerlevel+1,i,j) && centerpixel<array(centerlevel+1,i,j+1)
                isMin=1;
            else
                isMin=0;
             end
             
             truthvalue = isMin;
            
        end