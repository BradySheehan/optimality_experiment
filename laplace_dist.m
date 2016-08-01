%function takes in a single patch, columnwise, and a set of patches, also
%columnwise, and computes size(patch_set,2) probabilities and
%returns them
function result = laplace_dist(patch_single, patch_set) 
% 5/10/2016 Levine: with b = 10 I get num_m = 100 (if that's what it started
% as, where with b = 2.36 - 6.6 I get on the order of num_m = 5->8.
% using the new curvature and adjusted Laplace Distribution, b = 6.6 works
% as well
b = 2.36185928477463; %MAGIC NUMBER...
med = 0;
patch_singles = patch_single(:,ones(size(patch_set,2), 1));
diff = patch_singles - patch_set;% - med*ones(size(patch_set));
sumdfs = sum(abs(diff),1);
result = (1/(2*b))^(size(patch_single,1))*exp(-sumdfs/b);
%result = 1/((2*b)^((size(patch_single,1))/2))*exp(-sumdfs/b);
%size(result)
end
