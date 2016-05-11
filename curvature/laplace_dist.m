%function takes in a single patch, columnwise, and a set of patches, also
%columnwise, and computes size(patch_set,2) probabilities and
%returns them

%We are computing the probability of seeing some noisy image curvature patch given a
%random (sampled from the simulated set of all curvature image patches assumed to be
%clean) clean curvature image patch using the double exponential
%distribution or Laplace distribution. 

function result = laplace_dist(patch_single, patch_set) 
b = 2.36185928477463; %MAGIC NUMBER...
med = 0;
patch_singles = patch_single(:,ones(size(patch_set,2), 1));
diff = patch_singles - patch_set - med*ones(size(patch_set));
sumdf = sum(abs(diff),1);
result = (1/(2*b))*exp(-sumdf/b);
end