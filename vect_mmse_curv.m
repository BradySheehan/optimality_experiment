function [mmse_u, mmse_l, psnr_u, psnr_l] = vect_mmse_curv()
tic
%======paramaters======
patch_size = 5;
sig = 5;
%note that sample_list is a file generated from an R script that samples
%from a normal distribution the number of patches we will select from each
%image we load.
% sample_list = importdata('/media/BS-PORTABLE/vectorized/samples4.txt', '\n');
%from_dir = '/Users/DrLevine/Documents/Research/students/brady/images/';
from_dir = '/Users/BradySheehan/Desktop/data/images';
% sample_list = repelem(100, 500);
%======paramaters======

%======initializations========
file_list = get_all_files(from_dir);
%num_n = sum(sample_list);
num_n = 200000;%5000; %the number of samples from each image
%num_m = length(sample_list);
num_m = 200;%50; %the number of images
centers = zeros(1,num_n); %array that will hold the center pixel intensity values
filter = fspecial('gaussian', [patch_size patch_size], 5);%sig);
g = zeros(num_m,num_n); %matrix that will hold all of the probabilities we will compute
mmse_u = 0;
mmse_l = 0;
%======initializations========


%generate the list of m_patches and save it in memory
% [m_set_clean, m_set_noisy] = pre_process_and_sample_curv(file_list, patch_size,sig,num_m, filter);
% save('curvature_m_sets.mat', 'm_set_clean', 'm_set_noisy');

%======compute the probabilities========
centers_clean = find_center(m_set_clean, patch_size); %x_tilde_j center pixel
entry = 1;
num_s = num_n/num_m; %number of samples from each of the images we load
for ind = 1:num_m %load each image patch from memory
%     image = imread(char(file_list(ind)));
    n_subset = sample_n_patches_curv(image, num_s, patch_size, filter);
    c = find_center(n_subset, patch_size);
    centers(entry:entry+num_s -1 ) = c; %save the center value
    %while these are in memory, get the probability for all of these n for
    %each of the m in the m_set
    for ind2 = 1:num_m
        result = laplace_dist(m_set_noisy(:,ind2),n_subset);
        g(ind2,entry:entry+num_s - 1) = result';
    end
    entry = entry + num_s;
    ind;
end
%======compute the probabilities========

% ========== NOTE ==========
%in case something bad happens, save everything computed up to this point.
save('data_before_computation.mat'); 
%Then, if you want to use the data that was saved to recalculate the
%bounds, just load this .mat file into memory, and executed everything
%below this section of the code again!
% ========== NOTE ==========

% =========== compute the means ==============
%note that size(g) = [num_m, num_n] because each m_patch has num_n prob's
temp_centers = repmat(centers, num_m, 1); %first replicate the centers to have m colums
means1 = sum(g.*temp_centers,2)/num_n;
means2 = sum(g,2)/num_n;
max(means2)
min(means2)
%now replace all the zeros with 1's in the denominator so the division is
%defined
means = means1./means2; %vector of means, 1 mean for each m

% since some of these means are NaN's, we want to extract the indices of
% the non NaN values and use that for all of the computations.
% let's compute the MMSE_U right here:

inds =isfinite(means); %use this to index the centers2
%overwriting old num_m value
num_m = sum(inds) %number of m patches that were not ignored...
save('number_of_m_not_ignored', 'num_m');
cents2 = centers_clean(inds);
mens2 = means(inds);
diff = cents2' - mens2;
diff = diff.*diff;
mmse_u = (1/num_m)*sum(diff);
psnr_u = 10*log10(((255)^2)/mmse_u);
save('mean_values.mat', 'mmse_u', 'psnr_u', 'means');
% =========== compute the means ==============

% =========== compute the variances ==============
temp_means = repmat(means, [1 num_n]);
diff = temp_means - temp_centers;
diffsq = diff.*diff;
var_num = sum(g.*diffsq, 2);
var_denom = sum(g,2);
var_num_inds=var_num(inds);
var_denom_inds=var_denom(inds);
variance = var_num_inds./var_denom_inds;
mmse_l = sum(variance)/num_m;
psnr_l = 10*log10((255)^2/mmse_l);
save('var_values.mat', 'mmse_l', 'psnr_l', 'var_num', 'var_denom', 'variance');
% =========== compute the variances ==============

toc
end
% note taht to get the non nan values efficiently, do 
% M(isfinite(m))