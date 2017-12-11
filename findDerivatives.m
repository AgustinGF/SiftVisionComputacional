function [Dxx, Dxy, Dyy] =  findDerivatives(array, level)
            % Derivative masks
            filterdx = [-1 0 1; -1 0 1; -1 0 1];
            filterdy = filterdx';
            
            imagen = array(level,:,:);
            imagen=squeeze(imagen);
            
            %find first derivative and second derivative at those points
            Dx = conv2(imagen, filterdx, 'same');
            Dxx = conv2(Dx, filterdx, 'same');
            Dxy = conv2(Dx, filterdy, 'same');
            Dy = conv2(imagen, filterdy, 'same');
            Dyy = conv2(Dy, filterdy, 'same');
end