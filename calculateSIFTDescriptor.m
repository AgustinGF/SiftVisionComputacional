function [featuredescriptions, featurelocations] =calculateSIFTDescriptor(GLA,LLKP,dominantDirections)
            kvalue=sqrt(2);
            
%             index= 1;
                    [haykp,~,~,~]= size(LLKP);
                    if haykp==0
                        featuredescriptions = [];
                        featurelocations = [];
                        return; 
                    end
%             for octave = 1 : octavecount
%                  GL=GLA{octave};
%                  [~,rows,cols]=size(GL);
%                 for centerlevel = minlevel : maxlevel - 1
                    r= LLKP(:,1);
                    c= LLKP(:,2);
                    featuredescriptions = zeros(haykp,128);
                    featurelocations = zeros(haykp,2);
                    [length1,~] = size(r);
%         for level=2:3
                    %do edge outliers
                    for k = 1 : length1
                        k2=1;
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
                                
                                magnitudes = zeros(4,4);
                                orientations = zeros(4,4);
                                
                                %calculate for 4x4 block
                                for a = 1: 4
                                    magnitudes1 = zeros(1,4);
                                    orientations1 = zeros(1,4);
                                    
                                    for b = 1:4
                                        
                                        i = mvalue + a - 1;
                                        j = nvalue + b - 1;
                                        
                                        %calculate magnitude and orientation
                                        magnitude = calculateMagnitude(GL, i, j, level);
                                        magnitudes1(1,b) = magnitude;
                                        orientation = calculateOrientation(GL, i, j, level);
                                        dD = dominantDirections(k)*10;
                                        orientation = orientation - dD ;
                                        if orientation <= 0
                                            orientation= orientation + 360;
                                        end
                                        orientations1(1,b)= orientation;
                                        
                                    end
                                    
                                    magnitudes (a,:) = magnitudes1;
                                    orientations (a,:)= orientations1;
                                end
 

                                %smooth magnitude with gaussian
                                magnitudes = smoothMagnitudeGaussian(magnitudes, level, octave);
                                
                                histogram = computeHistogram(8, magnitudes, orientations);
                                
                                [~,fin] = size(histogram);
                                            % Example Visualise:
%                                 figure;
%                                 bar(1*45:45:360, histogram)
%                                 append to feature descriptor

                                featuredescriptor(1,k2:k2+fin-1) = histogram;
                                k2=k2+fin;
                            end
                        end
                        
                        %disp(featuredescriptor);
                        featuredescriptions(k,:)= featuredescriptor;
                        featurelocations(k,:) = [locy*(2^(octave-1)),locx*(2^(octave-1))];
                        
%                         index = index+1;
                    end
                    
%                 end
                
%             end
%         end
            [length6, ~] = size(featuredescriptions);
            for i = 1 : length6
                featuredescriptions(i,:) =  featuredescriptions(i,:)/norm(featuredescriptions(i,:));
                featuredescriptions(i,find(featuredescriptions(i,:)) > 0.2) = .2;
                featuredescriptions(i,:) =  featuredescriptions(i,:)/norm(featuredescriptions(i,:));
            end   
       
end