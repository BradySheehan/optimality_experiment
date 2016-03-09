function MMSE_U = MMSEU(vectPairs, vectCleanImages, sig)
%VectPairs(M,1) are the noisy images, y_j
%VectPairs(M,2) are the clean images, x_j
%vectPairs are the 2000 image patches (y_j, x_j)
%vectCleanImages is the larger set of N image patches

% this function computes the squared difference between the mean of the
% noisy patch and the center pixel of the jth clean patch


M = length(vectPairs);
for j = 1:M
    MMSE_U = MMSE_U + ...
        ( meanForMMSE(vectPairs(M,1), vectCleanImages, sig) - find_center(vectPairs(M,2)) ) ^ 2;
end
MMSE_U = MMSE_U/M;
end