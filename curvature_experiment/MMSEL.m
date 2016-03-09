function MMSE_L = MMSEL(vectPairs, vectCleanImages, sig)
%VectPairs(M,1) are the noisy images
%VectPairs(M,2) are the clean images
%vectPairs are the 2000 image patches
%vectCleanImages is the larger set of N image patches

for j = 1:M
   MMSE_L = MMSE_L + varianceForMMSE(vectPairs(M,1), vectCleanImages, sig);
end
MMSE_L = MMSE_L/M;
end