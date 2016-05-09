function result = find_center(patch_set, patch_size)
%given a patch_size^2 * num_patches matrix
%return a vector of center pixels for each of the patches
index =  sub2ind([patch_size patch_size], ceil(patch_size/2), ceil(patch_size/2));
result = patch_set(index,:);
end