%script for randomly selecting n patches from an image
function patches = sample_n_patches_color(im, num_patches, patch_size)
tic
%selecting the patches from the image with matrix multiplication with a
%mask
im = im2double(im);
% im_cols2 = im2col(im(:,:,1), [patch_size patch_size], 'sliding');
im_cols1 = im2col(im(:,:,1), [patch_size patch_size], 'sliding');
im_cols2 = im2col(im(:,:,2), [patch_size patch_size], 'sliding');
im_cols3 = im2col(im(:,:,3), [patch_size patch_size], 'sliding');
im_cols = cat(3, im_cols1, im_cols2, im_cols3);
clear('im_cols1', 'im_cols2', 'im_cols3');
% generate vector of zeros with zeros = number of patches in the image
selection = zeros(1, size(im_cols,2)); 
selection(1:num_patches) = 1;%put 1's in the zeros
shuffled = selection(randperm(length(selection))); %permute the 1s
matrix_selection = shuffled(ones(size(im_cols,1), 1),:); %create full mask
matrix_selection = cat(3, matrix_selection, matrix_selection, matrix_selection);
im_cols = im_cols + 1; %adjustment for images in [0,255]
big_patches = matrix_selection.*im_cols; %select the patches
% patches = big_patches(big_patches~=0); %remove the zeros

big_patches1 = big_patches(:,:,1);
big_patches2 = big_patches(:,:,2);
big_patches3 = big_patches(:,:,3);
patches1 = big_patches1(big_patches1~=0);
patches2 = big_patches2(big_patches2~=0);
patches3 = big_patches3(big_patches3~=0);

patches = cat(3, patches1, patches2, patches3);

patches = patches - 1;
% patches = reshape(patches, [size(im_cols,1), num_patches]); %reshape into matrix
toc
end