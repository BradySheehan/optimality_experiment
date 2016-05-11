%This function is meant to create two sets of sample image curvature patches in
%vector form. Result1 is clean image patches and result2 is noisy set of
%patches
%Note that this function assumes that the image has been preprocessed (ie,
%converted to grayscale, downsampled, and filtered with a guassianc)
function [result1, result2] = pre_process_and_sample_curv(from_dir, patch_size, sig, num_patches)
%load a file, downsample it by two, low-pass filter it, sample patch from it
dbstop if error
file_list = from_dir;
patches_clean = zeros(patch_size^2, num_patches);
patches_noisy = patches_clean;
for ii = 1:num_patches
    %randomly select a file from the list
    index = randi([1, length(file_list)]);
    file = file_list(index);
    [pathstr,name,ext] = fileparts(char(file));
    %check to make sure the file is of the correct format
    if ~isempty(name) && ~isempty(ext)
        %read the image
        im = imread(char(file));
        im = 255*im2double(im);
        n = size(im,1);
        m = size(im,2);
        image_noisy = im + sig*randn(n,m);
        curv_image_clean = IterativeCurvatureMinEpsilon(im);
        curv_image_noisy = IterativeCurvatureMinEpsilon(image_noisy);
        %now randomly select a patch from the image
        rows = randi(n-patch_size+1)+(0:patch_size-1);
        cols = randi(m-patch_size+1)+(0:patch_size-1);
        curv_image_clean = curv_image_clean(rows,cols);
        curv_image_noisy = curv_image_noisy(rows,cols);
        patches_clean(:,ii) = reshape(curv_image_clean, patch_size^2, 1);
        patches_noisy(:,ii) = reshape(curv_image_noisy, patch_size^2, 1);
    end
end
result1 = patches_clean;
result2 = patches_noisy;
end