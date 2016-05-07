function result = gaus_dist2(patch1, patch2, sig)

%compute l2^2 norm of difference: 
% sum abs of all the squared differences
num_pixels = length(patch1)*length(patch2);
diff = abs(patch1 -patch2);
sum_diff_squared = sum(diff)^2;
result = (1/(2*pi*sig^2)^(num_pixels/2)) * ...
    exp(-sum_diff_squared/(2*sig^2));
end