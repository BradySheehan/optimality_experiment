%script for randomly selecting n patches from an image
%selecting the patches from the image with matrix multiplication with a
%mask
function patches = sample_n_patches_curv(im, num_patches, patch_size, filter)
% tic
im = 255*im2double(rgb2gray(im));
im = im(1:2:end,1:2:end);
im = imfilter(im, filter, 'same');
%im = CurvaturebyMarcelo(im);
%im = IterativeCurvatureMinEpsilon(im);
% im = IterativeCurvatureCentral(im);
im_cols = im2col(im, [patch_size patch_size], 'sliding');
% generate vector of zeros with zeros = number of patches in the image
selection = zeros(1, size(im_cols,2)); 
selection(1:num_patches) = 1;%put 1's in the zeros
shuffled = selection(randperm(length(selection))); %permute the 1s
matrix_selection = shuffled(ones(size(im_cols,1), 1),:); %create full mask
im_cols = im_cols + 9; %note that curvature image is scaled between [-4,4]
big_patches = matrix_selection.*im_cols; %select the patches
patches = big_patches(big_patches~=0); %remove the zeros
patches = patches - 9;
% I want to reshape patches into a patch_size^2 x num_patches matrix
patches = reshape(patches, [patch_size^2, num_patches]);
% toc
end