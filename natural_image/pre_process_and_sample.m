%This function is meant to create two sets of sample image patches in
%vector form. Result1 is clean image patches and result2 is noisy set of
%patches
function [result1, result2] = pre_process_and_sample(fromDirectory, patchSize, sig, num_patches, filter)
%load a file, downsample it by two, low-pass filter it, sample patch from it
dbstop if error
file_list = fromDirectory;
patches_clean = zeros(patchSize^2, num_patches);
patches_noisy = patches_clean;
for ii = 1:num_patches
    %randomly select a file from the list
    index = randi([1, length(file_list)]);
    file = file_list(index);
    [pathstr,name,ext] = fileparts(char(file));
    %check to make sure the file is of the correct format
    if ~isempty(name) && ~isempty(ext)
        %read the image
        image = imread(char(file));
        image = 255*im2double(rgb2gray(image));
        image = image(1:2:end,1:2:end);
        image = imfilter(image, filter, 'same');
        n = size(image,1);
        m = size(image,2);
        image_noisy = image + sig*randn(n,m);
        %now randomly select a patch from the image
        rows = randi(n-patchSize+1)+(0:patchSize-1);
        cols = randi(m-patchSize+1)+(0:patchSize-1);
        image = image(rows,cols);
        image_noisy = image_noisy(rows,cols);
        patches_clean(:,ii) = reshape(image, patchSize^2, 1);
        patches_noisy(:,ii) = reshape(image_noisy, patchSize^2, 1);
    end
end
result1 = patches_clean;
result2 = patches_noisy;
end