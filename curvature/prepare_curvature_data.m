function results = prepare_curvature_data()
file_list = get_all_files('/images/');
to_dir_clean = '/curvature_images_clean/';
to_dir_noisy = '/curvature_images_noisy';
to_dir_processed = '/processed_images/';
num_patches = 2000;
sig = 18; %for added noise
patch_size = [5, 10, 15, 20]; %for sampling
%for filtering
sig_filter = 3;
window_size = 5;
filter = fspecial('gaussian', [window_size window_size], sig_filter);
%for filtering
% patches_clean = {};
% patches_noisy = {};
% for t = 1:length(patch_size)
%     patches_clean{t} = zeros(patch_size(t)^2, num_patches);
%     patches_noisy{t} = patches_clean{t};
% end
ind = 1;
for file = file_list(:)' %loop over all files in the file list
    
    [pathstr,name,ext] = fileparts(char(file));
    %check to make sure the file is of the correct format
    if ~isempty(name) && ~isempty(ext) && isempty(strfind(char(file),'._'));
        image = imread(char(file));
        image = im2double(rgb2gray(image));
        image = image(1:2:end,1:2:end);
        image = imfilter(image, filter, 'same');
        imwrite(image, fullfile(to_dir_processed,sprintf('%s%s', name, ext)), 'Quality', 100);
        n = size(image,1);
        m = size(image,2);
        image_noisy = image + sig*randn(n,m);
        curv_image_clean = IterativeCurvatureMinEpsilon(image);
        curv_image_noisy = IterativeCurvatureMinEpsilon(image_noisy);
        imwrite(curv_image_clean, fullfile(to_dir_clean, sprintf('%s%s', name, ext)));
        imwrite(curv_image_noisy, fullfile(to_dir_noisy, sprintf('%s%s', name, ext)));
%         %now randomly select a patch from the image
%         for t = 1:length(patch_size)
%             rows = randi(n-patch_size(t)+1)+(0:patch_size(t)-1);
%             cols = randi(m-patch_size(t)+1)+(0:patch_size(t)-1);
%             temp_clean = curv_image_clean(rows,cols);
%             temp_noisy = curv_image_noisy(rows,cols);
%             patches_clean{t} = reshape(temp_clean, patch_size(t)^2, 1);
%             patches_noisy{t} = reshape(temp_noisy, patch_size(t)^2, 1);
%         end
    end
    ind = ind + 1;
    ind
end

% save('/Users/BradySheehan/Desktop/curvature_patch_sets/curvature_patches.mat', 'patches_clean', 'patches_noisy', 'sig', 'patch_size');