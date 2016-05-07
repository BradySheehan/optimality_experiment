function result = integrated_mmse()
%%%% break this process into steps
sig = 18;
from_dir = ;
num_m = ;
num_n = ;
file_list = get_all_files(from_dir);
m_set = zeros(1,num_m);
n_set = zeros(1,num_n);
patch_size = 5;
sample_list = importdata('samples.txt', '\n');

%% randomly select an image and randomly select a patch within it
% save that image patch, but keep it in memory, this is one image from M
%generate 2,000 random numbers
% mrandoms = randi([1 length(file_list)], 1, num_m); 

m_patch = imread(file_list(randi([1 length(file_list)])));
m_patch = imresize(m_patch, 0.5);
n = size(m_patch,1);
m = size(m_patch,2);
%randomly select a patch from within the image
rows = randi(n-patch_size(1)+1)+(0:patch_size(1)-1);
cols = randi(m-patch_size(2)+1)+(0:patch_size(2)-1);
m_set(1,1) = m_patch(rows,cols, :); %this is the current focus image
%% now select an image and randomly sample n patches from it

im = imread(file_list(randi([1 length(file_list)],1)));
im = 255*im2double(im);
patches = sample_n_patches(im, sample_list(ind), patch_size);

%% for the m_imaeg and each set of image patches from the n_set selected, 
%  we want to compute the mean and variance

%  first compute probability for one patch and m_patch
gaus_dist(m_patch, patches(:,1), sig);



%% after all that completes, we want to loop over all  the means and
% variances for all combinations of patch size and variance to get the
% MMSEU and MMSEL
    
end