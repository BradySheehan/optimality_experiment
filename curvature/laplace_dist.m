%function takes in a single patch, columnwise, and a set of patches, also
%columnwise, and computes size(patch_set,2) probabilities and
%returns them
function result = laplace_dist(patch_single, patch_set) 
b = 2.36185928477463; %MAGIC NUMBER...
med = 0;
patch_singles = patch_single(:,ones(size(patch_set,2), 1));
diff = patch_singles - patch_set - med;
result = (1/(2*b))*exp(-(sum(sum(diff)))/b);
end