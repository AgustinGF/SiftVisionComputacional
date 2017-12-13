function[orientation] = calculateOrientation(GL, i, j, centerlevel)
            dx = GL(centerlevel,i+1,j)-GL(centerlevel,i-1,j);
            dy = GL(centerlevel,i,j+1)-GL(centerlevel,i,j-1);
            
            if dx == 0
                if dy == 0
                    dx = 100000;
                    dy = 1;
                else
                    dx = 1;
                    dy = 100000;
                end
            end
            orientation = atand(dy/dx);
            
%             disp(['angle = ' num2str(orientation) ' dx = ' num2str(dx) ' dy = ' num2str(dy)]);
            %correct the orientation from -90<->90 to 0<->360 range

            if orientation > 0 && orientation < 90
                if GL(centerlevel,i-1,j) > GL(centerlevel,i+1,j)
                    orientation = orientation + 180;
                end
            elseif orientation <= 0 && orientation > -90
                if GL(centerlevel,i-1,j) > GL(centerlevel,i+1,j)
                    orientation = orientation + 180;
                else
                    orientation = orientation + 360;
                end
            end
            [orientation i j];
            
end