function [mmse_u, mmse_l, psnr_u, psnr_l] = vect_mmse_curv()
tic
%======paramaters======
patch_size = 5;
sig = 18;
%note that sample_list is a file generated from an R script that samples
%from a normal distribution the number of patches we will select from each
%image we load.
% sample_list = importdata('/media/BS-PORTABLE/vectorized/samples4.txt', '\n');
from_dir = '/Volumes/BS-PORTABLE/processed_images/';
% sample_list = repelem(100, 500);
%======paramaters======

%======initializations========
file_list = get_all_files(from_dir);
% num_n = sum(sample_list);
num_n = 5000;
% num_m = length(sample_list);
num_m = 50;
n_set_centers = zeros(1,num_n);
g = zeros(num_m,num_n);
mmse_u = 0;
mmse_l = 0;
psnr_u = 0;
psnr_l = 0;
% NOTE: num_n should be the total number of patches sampled from all of the
% images. This value is computed by sampling num_s patches from each image
% in the database num_m times. Therefore, num_n = num_s * num_m. Later
% whenever we run an experiment with the entire dataset, we will generate
% num_s by sampling from a Normal distribution with mean = num_n/num_m and
% standard deviation estimated so that all the samples are positive (which
% isn't the best way to do it, but produces reasonable results).
%======initializations========

%generate the list of m_patches and save it in memory
[m_set_clean, m_set_noisy] = pre_process_and_sample_curv(file_list, patch_size,sig,num_m);
% save('curvature_m_sets.mat', 'm_set_clean', 'm_set_noisy');
m_set_centers_clean = find_center(m_set_clean, patch_size)'; %x_tilde_j center pixel
entry = 1;
num_s = 100; %number of samples from each of the images we load
for ind = 1:num_m
    image = imread(char(file_list(ind)));
    n_subset = sample_n_patches_curv(image,num_s, patch_size);
    c = find_center(n_subset, patch_size);
    n_set_centers(entry:entry+num_s -1 ) = c;
    %while these are in memory, get the probability for all of these n for
    %each of the m in the m_set
    for ind2 = 1:num_m
        result = laplace_dist(m_set_noisy(:,ind2),n_subset);
        g(ind2,entry:entry+num_s - 1) = result';
    end
    entry = entry + num_s;
    ind
end
% ========== NOTE ==========
%in case something bad happens, save everything computed up to this point.

% save('data_before_computation.mat'); 

%Then, if you want to use the data that was saved to recalculate the
%bounds, just load this .mat file into memory, and executed everything
%below this section of the code again!
% ========== NOTE ========== %

% =========== compute the upper means and upper bound ============== %
%note that size(g) = [num_m, num_n] because each m_patch has num_n prob's
rep_n_centers = repmat(n_set_centers, num_m, 1); %first replicate the n_set_centers to have num_m columns
mean_num = sum(g.*rep_n_centers,2);
mean_denom = sum(g,2);
means = mean_num./mean_denom; %vector of means, 1 mean for each m
%NOTE: If means_denom contains zeros, everything gets messed up. Recent
%runs show that none of the means_denom were zero so the correction for
%this was removed. If we find that we need to correct for it in the future,
%find the indices of the isfinite() values in means and use that to index
%the rest of the code. If this happens, be sure to update num_m according
%to the number of means not ignored.

% == here we are computing the MMSE_U and PSNR_u == %
diff = means - m_set_centers_clean;
diff = diff.*diff;
mmse_u = sum(diff)/num_m;
psnr_u = 10*log10((8^2)/mmse_u);
% save('mean_values.mat', 'mmse_u', 'psnr_u', 'means');
% == here we are computing the MMSE_U and PSNR_u == %

% =========== compute the upper bound ============== %

% =========== compute the variances ==============
rep_means = repmat(means, [1 num_n]);
diff = rep_means - rep_n_centers;
diffsq = diff.*diff;
var_num = sum(g.*diffsq, 2);
var_denom = sum(g,2);
variance = var_num./var_denom;
mmse_l = sum(variance)/num_m;
psnr_l = 10*log10((8^2)/mmse_l);
% save('var_values.mat', 'mmse_l', 'psnr_l', 'var_num', 'var_denom', 'variance');
% =========== compute the variances ==============

toc
end