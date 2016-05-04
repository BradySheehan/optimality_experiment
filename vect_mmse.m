function [mmse_u, mmse_l, g, centers] = vect_mmse()
%paramaters
tic
patch_size = 5;
sig = 18;
% sample_list = importdata('/media/BS-PORTABLE/vectorized/samples4.txt', '\n');
from_dir = '/media/BS-PORTABLE/images/';
% sample_list = repelem(100, 500);
%get data
file_list = get_all_files(from_dir);
%initializations
% num_n = sum(sample_list);
num_n = 50000;
% num_m = length(sample_list);
num_m = 500;
centers = zeros(1,num_n);
filter = fspecial('gaussian', [patch_size patch_size], sig);
g = zeros(num_m,num_n);
mmse_u = 0;
mmse_l = 0;

%generate the list of m_patches and save it in memory
m_set = pre_process_and_sample(file_list, patch_size,sig,num_m, filter);
centers2 = find_center(m_set, patch_size); %x_tilde_j center pixel
entry = 1;
for ind = 1:num_m
    image = imread(char(file_list(ind)));
    n_subset = sample_n_patches(image,100, patch_size, filter);
    c = find_center(n_subset, patch_size);
    centers(entry:entry+100 -1 ) = c;
    %while these are in memory, get the probability for all of these n for
    %each of the m in the m_set
    for ind2 = 1:num_m
        result = gaus_dist(m_set(:,ind2),n_subset,sig);
        g(ind2,entry:entry+100 - 1) = result';
    end
    entry = entry +100;
end
save('data_before_computation.mat', 'g', 'centers', 'centers2', 'm_set');
%note that size(g) = [num_m, num_n] because each m_patch has num_n prob's
temp_centers = repmat(centers, num_m, 1); %first replicate the centers to have m colums

%compute the means
%must do sum before we divide, but some might me NaN's and they might end
%up as different sized matrices... need to figure out
%could replace all the NaN's with zeros, they wouldn't affect the sums
means1 = g.*temp_centers;
means1 = sum(means1,2)/num_n;
means2 = g;
means2 = sum(g,2)/num_n;
%now replace all the zeros with 1's in the denominator so the division is
%defined
means = means1./means2; %vector of means, 1 mean for each m

% since some of these means are NaN's, we want to extract the indices of
% the non NaN values and use that for all of the computations.
% let's compute the MMSE_U right here:

inds =isfinite(means); %use this to index the centers2
cents2 = centers2(inds);
mens2 = means(inds);
diff = cents2' - mens2;
diff = diff.*diff;
mmse_u = (1/num_m)*sum(diff);
psnr_u = 10*log10((255^2)/mmse_u);


%compute the variances
temp_means = repmat(means, [1 num_n]); %replicate means to have n colums
inds2 = isfinite(temp_means);
%get the values that are finite. confusion happens when we do the
%multiplication - what happens to the multiplication by g? can we index g
%with the same indices we use to index temp_means?
diff = temp_means(inds2) - temp_centers(inds2);
diffsq = diff.*diff;
%numerator for variances will be the sum across the rows of multiplication
%of the g.*diffsq divided by the num_n. This will be a vector of variances,
%one for each of the m images
var1 = sum(g(inds2).*diffsq, 2)/num_n;
var2 = sum(g(inds2),2);

%take all the values that are not NaNs and divide the numerator and
%denominators, for all m patches
v = var1./var2;
%the v vector should be 1xnum_m when we are done with the above, but that
%doesn't seem to be right.
mmse_l = sum(v(isfinite(v)))/num_m;
psnr_l = 10*log10((255^2)/mmse_l);

save('output2.mat', 'mmse_u', 'mmse_l', 'g', 'm', 'centers');
toc
end


% note taht to get the non nan values efficiently, do 
% M(isfinite(m))