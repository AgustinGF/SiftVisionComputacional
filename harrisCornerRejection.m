function[finalpositions]= harrisCornerRejection(LLA,octavecount,LLKP,minlevel)
            
            finalpositions = {};
            
            for octave = 1 : octavecount   
                array = LLA{octave};
                KP=LLKP{octave};
                [rows,cols,maxlevel]=size(KP);
                
                P=zeros(rows,cols,maxlevel);
                
                for centerlevel = minlevel + 1 : maxlevel   
                    %disp(['at level ' num2str(centerlevel) ' of octave ' num2str(octave)]);
                    
                    %find the points at that octave and scale, Find row,col coords.
                    [r,c] = find(KP(:,:,centerlevel));
                    
                    [Dxx, Dxy, Dyy] = findDerivatives(array, centerlevel);
                    %                     disp(Dxx);
                    % 2. further outlier rejection
                    [lengtha,~] = size(r);
                    %disp(lengtha);
                    for k = 1 : lengtha
                        i = r(k,1);
                        j = c(k,1);
                        %use harris corner detector
                        hessian = [Dxx(i,j) Dxy(i,j)
                            Dxy(i,j) Dyy(i,j)];
                        eigenvalues = eig(hessian);
                        if eigenvalues(2) ~= 0
                            ratio = eigenvalues(1)/eigenvalues(2);
                            if ratio < 0
                                ratio = -ratio;
                            end
                            %remove all the edges
                            if abs(ratio) <= 2
                                P(i,j, centerlevel )=1;
                            end
                        end
                    end
                    
                end
                
                finalpositions{end+1}=P;
                
            end
            
        end