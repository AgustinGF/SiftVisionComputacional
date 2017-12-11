function [magnitude] = calculateMagnitude(GL, i, j, centerlevel)
            dx = GL(centerlevel,i+1,j)-GL(centerlevel,i-1,j);
            dy = GL(centerlevel,i,j+1)-GL(centerlevel,i,j-1);
            magnitude = sqrt(dx*dx + dy*dy);
end