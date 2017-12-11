function displayKeypointsDirections(Image,directions, LLKP)
            
    index = 1;
    sigmavalue=1.6;
    kvalue=sqrt(2);
    figure;
    imshow(Image); 
    [H,W]=size(Image);
%     for octave = 1 : octavecount
%         for centerlevel = minlevel : maxlevel
            r=LLKP(:,1);
            c=LLKP(:,2);
            length1 = size(r);
%         switch octave
%           case 1
%             [r,c]=find(LL1KP(:,:,centerlevel));
%             [length1,~] = size(r);
%               
%           case 2
%             [r,c]=find(LL2KP(:,:,centerlevel));
%             [length1,~] = size(r);
%                 
%           case 3
%            [r,c]=find(LL3KP(:,:,centerlevel));
%            [length1,~] = size(r);
%                
%           case 4
%            [r,c]=find(LL4KP(:,:,centerlevel));
%            [length1,~] = size(r);
%         end
                
                    %                     sigma = self.sigmavalue * (self.kvalue ^ (centerlevel-1));
%                     radius = H*.005*1.5 * sigmavalue * (kvalue ^ (octave));
%                     radius = 8;
                    
            for pointindex = 1 : length1
                        octave = LLKP(pointindex,4);
                        level = LLKP(pointindex,3);
                        y = r(pointindex)*2^(octave-1);
                        x = c(pointindex)*2^(octave-1);
                        radius = sigmavalue * (kvalue ^ (level+2*(octave-1)));
%                         radius=20;
                        ang=0:0.01:2*pi;
                        xp=radius*cos(ang);
                        yp=radius*sin(ang);
                        hold on
                        plot(x+xp,y+yp);
                        
                        % display the dominant direction
                        dominantdirection = directions(index)*10;
                        x1 = x;%-radius*cos(dominantdirection)*0.5;
                        x2 = x+radius*cos(dominantdirection*pi/180);
                        y1 = y;%-radius*sin(dominantdirection)*0.5;
                        y2 = y-radius*sin(dominantdirection*pi/180);
                        x = linspace(x1,x2,100);
                        y = linspace(y1,y2,100);
                        hold on
                        plot(x,y);
                        
                        index=index+1;
            end
%         end
%     end
end