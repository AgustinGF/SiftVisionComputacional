function[finalpositions]= harrisCornerRejection(LLA,octavecount,LLKP,minlevel,maxlevel)
            
            finalpositions = {};
            
            for octave = 1 : octavecount   
                array = LLA{octave};
                KP=LLKP{octave};
                [rows,cols,~]=size(KP);
                
                P=zeros(rows,cols,maxlevel);
                
                for centerlevel = minlevel + 1 : maxlevel-1  
                    
                    [r,c] = find(KP(:,:,centerlevel));
                    
                    [Dxx, Dxy, Dyy] = findDerivatives(array, centerlevel);
                    
                    [lengtha,~] = size(r);
                    for k = 1 : lengtha
                        i = r(k,1);
                        j = c(k,1);
                        
                        % Calculo de la matriz hessiana
                        hessian = [Dxx(i,j) Dxy(i,j) Dxy(i,j) Dyy(i,j)];
                        eigenvalues = eig(hessian);
                        if eigenvalues(2) ~= 0
                            ratio = eigenvalues(1)/eigenvalues(2);
                            if ratio < 0
                                ratio = -ratio;
                            end
                            %Solo usamos el punto cuando el ratio <=2
                            if abs(ratio) <= 2
                                P(i,j, centerlevel )=1;
                            end
                        end
                    end
                    
                end
                
                finalpositions{end+1}=P;
                
            end
            
        end