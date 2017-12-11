function [histogram] = computeHistogram(binsize, magnitudes, orientations)
            %find histogram of orientation in neighbourhood
            histogram = zeros(1,binsize);
            %                         bins = 1:binsize;
            [lengtha,lengthb] = size(magnitudes);
            angle = 360/binsize;
            for a = 1 : lengtha
                for b = 1 : lengthb
%                   disp(['angle2 = ' num2str(orientations(a,b))]);
                    bin = ceil(orientations(a,b)/angle);
                    histogram(1,bin ) =  histogram(1,bin) + magnitudes(a,b);
                end
            end
            % Example Visualise:
%             figure;
%             bar(1*10:10:binsize*10, histogram)
end