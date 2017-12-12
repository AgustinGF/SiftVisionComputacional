function [dominantDirections, Locaciones] = calculateDominantOrientation(octavecount,minlevel,GLA,LLKP)
Locaciones=[];
dominantDirections = [];
           
    for octave = 1 : octavecount   
         GL=GLA{octave};
         [~,rows,cols]=size(GL);
         KP=LLKP{octave};
         [~,~,maxlevel]=size(KP);
       for centerlevel = minlevel : maxlevel    
            
            [r,c]=find(KP(:,:,centerlevel));
            [length1,~] = size(r);
            level=centerlevel; 
      %     do edge outliers
          for k = 1 : length1
            locx = r(k);
            locy = c(k);
      %   featurelocations = [featurelocations ; [locx, locy, centerlevel, octave] ];
                        
            magnitudes = [];
            orientations = [];
                        
         %find orientation and magnitude in the 4x4 neighbourhood
            m1 = locx - 2;
            m2 = locx + 2;
            n1 = locy - 2;
            n2 = locy + 2;
         % correct the boundary
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
            %calculate magnitude and orientation
                magnitude = calculateMagnitude(GL, i, j, level);
                magnitudes1 =[magnitudes1 magnitude];
                orientation = calculateOrientation(GL, i, j, level);
                orientations1 = [orientations1 orientation];
            end
            magnitudes =[magnitudes ;magnitudes1];
            orientations = [orientations; orientations1];
         end
                        
          %smooth magnitude with gaussian
         magnitudes = smoothMagnitudeGaussian(magnitudes, level, octave);
         histogram  = computeHistogram(36, magnitudes, orientations);
                        
         %find the dominant directions in the histogram
         combined = [histogram; 1:36]';
         sortedvalues = sortrows(combined, 1); 
           maxvalue = [sortedvalues(36,1)];
         domiantdirections = [sortedvalues(36,2)];
              for m = 35 : -1 : 1
                if sortedvalues(m) >= 0.8 * maxvalue(1)
%                     maxvalue = [maxvalue sortedvalues(m,1)];
                    dominantDirections = [dominantDirections sortedvalues(m,2)];
                    Locaciones = [Locaciones; [r(k), c(k),centerlevel,octave]];
                end
              end 
             dominantDirections = [dominantDirections domiantdirections(1)];
             Locaciones = [Locaciones; [ r(k), c(k), centerlevel, octave]];
             
          end
       end
   end
end
