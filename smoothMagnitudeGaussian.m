function[magnitudes] = smoothMagnitudeGaussian(magnitudes, centerlevel, octave)
            sigma = 1.5 * computeGaussianSigma(octave,centerlevel);
            width = floor(6 * sigma + 1);
            gfilter = fspecial('gaussian', width, sigma);
            magnitudes = conv2(magnitudes, gfilter, 'same');
end

function[sigma] = computeGaussianSigma(octave,level)
sigmavalue=1.6;
kvalue=sqrt(2);
sigma = sigmavalue * (kvalue^(level+2*(octave-1)));
end