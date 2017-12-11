function [featuredescriptions, featurelocations] =calculateSIFTDescriptor(GLA,LLKP,dominantDirections)
            
            featuredescriptions = [];
%             index= 1;
            featurelocations = [];
            
%             for octave = 1 : octavecount
%                  GL=GLA{octave};
%                  [~,rows,cols]=size(GL);
%                 for centerlevel = minlevel : maxlevel - 1
                    r= LLKP(:,1);
                    c= LLKP(:,2);
                    [length1,~] = size(r);
%         for level=2:3
                    %do edge outliers
                    for k = 1 : length1
                        centerlevel=LLKP(k,3);
                        level=centerlevel;
                        octave=LLKP(k,4);
                        GL=GLA{octave};
                        [~,rows,cols]=size(GL);
                        locx = r(k);
                        locy = c(k);
                        %find the feature descriptor for 16x16 block
                        featuredescriptor = [];
                        %first calculate the magnitude and relative orientation for
                        %all 16x16 values
                        
                        % determine the boundary
                        m1 = locx - 7;
                        m2 = locx + 8;
                        n1 = locy - 7;
                        n2 = locy + 8;
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
                        
                        %disp(['boundaries ' , num2str(m1), ' , ', num2str(m2), ' , ' , num2str(n1) , ' , ' num2str(n2)]);
                        
                        for m = 1: 4
                            for n = 1:4
                                
                                mvalue = m1 + (4 * (m-1));
                                nvalue = n1 + (4 * (n-1));
                                
                                magnitudes = [];
                                orientations = [];
                                
                                %calculate for 4x4 block
                                for a = 1: 4
                                    magnitudes1 = [];
                                    orientations1 = [];
                                    
                                    for b = 1:4
                                        
                                        i = mvalue + a - 1;
                                        j = nvalue + b - 1;
                                        
                                        %calculate magnitude and orientation
                                        magnitude = calculateMagnitude(GL, i, j, level);
                                        magnitudes1 =[magnitudes1 magnitude];
                                        orientation = calculateOrientation(GL, i, j, level);
                                        dD = dominantDirections(k)*10;
                                        orientation = orientation - dD ;
                                        if orientation <= 0
                                            orientation= orientation + 360;
                                        end
                                        orientations1 = [orientations1 orientation];
                                        
                                    end
                                    
                                    magnitudes =[magnitudes ;magnitudes1];
                                    orientations = [orientations; orientations1];
                                end
 

                                %smooth magnitude with gaussian
                                magnitudes = smoothMagnitudeGaussian(magnitudes, level, octave);
                                
                                histogram = computeHistogram(8, magnitudes, orientations);
                                
                                            % Example Visualise:
%                                 figure;
%                                 bar(1*45:45:360, histogram)
%                                 append to feature descriptor
                                featuredescriptor = [featuredescriptor histogram];
                            end
                        end
                        
                        %disp(featuredescriptor);
                        featuredescriptions= [featuredescriptions ; featuredescriptor];
                        featurelocations = [featurelocations; [locy*(2^(octave-1)),locx*(2^(octave-1))]];
                        
%                         index = index+1;
                    end
                    
%                 end
                
%             end
%         end
            [length6, ~] = size(featuredescriptions);
            for i = 1 : length6
                featuredescriptions(i,:) =  featuredescriptions(i,:)/norm(featuredescriptions(i,:));
                featuredescriptions(i,find(featuredescriptions(i,:)) > 0.2) = 0;
                featuredescriptions(i,:) =  featuredescriptions(i,:)/norm(featuredescriptions(i,:));
            end   
       
end