%function takes in a single patch, columnwise, and a set of patches, also
%columnwise, and computes size(patch_set,2) probabilities and
%returns them
function result = gaus_dist(patch_single, patch_set, sig)
%replicate patch_single n times where n = size(patch_set, 2);
patch_singles = patch_single(:,ones(size(patch_set,2), 1));
diff = abs(patch_singles - patch_set);
diff_squared = diff.*diff;
sumdfs = sum(diff_squared,1);
coeff = 1/((2*pi*sig^2)^(size(patch_single,1))/2);
result = coeff*exp(-sumdfs./(2*sig^2))';
end