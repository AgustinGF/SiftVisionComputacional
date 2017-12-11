function displayKeypoints(imagenes, locations, octavecount,minLevel,maxLevel,length1)
            
            for octave = 1 : octavecount
                %which figure to display according to octave
                image1 = imagenes{octave};
                
                for centerlevel = minLevel + 1 : maxLevel - 1
                    
                    %find the points at that octave and scale
                    [r,c] = find(locations(:,:,centerlevel, octave));                  % Find row,col coords.
                    
                    %display the found points
                    %disp(['total points found at ' num2str(centerlevel) ' in octave' num2str(octave) ]);
                    %disp(size(r))
                    
                    % overlay corners on original image
                    figure,
                    imagesc(image1),
                    axis image,
                    colormap(gray),
                    hold on;
                    %plot(c,r,'ys'),
                    title(['potential points detected', num2str(octave), ' - ', num2str(centerlevel) ]);
                    
                    [length1,~] = size(r);
                    %                     sigma = self.sigmavalue * (self.kvalue ^ (centerlevel-1));
                    radius = 3;
                    for pointindex = 1 : length1
                        y = r(pointindex);
                        x = c(pointindex);
                        ang=0:0.01:2*pi;
                        xp=radius*cos(ang);
                        yp=radius*sin(ang);
                        plot(x+xp,y+yp);
                    end
                    
                end
            end
        end