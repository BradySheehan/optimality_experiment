function result = summary(outputdir)
%this function will read in the output from all the parallel processes
%and compute the final MMSE_U, MMSE_L, PSNR's, and plot necessary data

output_list = get_all_files(outputdir);
M = length(output_list);
means = zeros(1,M);
vars = zeros(1,M);
i = 0;
MMSE_U = 0;
MMSE_L = 0;
for file = file_list(:)' %loop over all files in the file list
    load(file);
    means(i) = me;
    vars(i) = var;
    
    MMSE_U = MMSE_U + (mean(i) - x0)^2;
    % this function computes the variance of the noisy patch
    % for all clean patches
    MMSE_L = MMSE_L + vars(i);
    i = i + 1;
end
figure, hist(vars),title('histogram of variances');
figure, hist(means), title('histogram of means');
MMSE_U = MMSE_U/M;
MMSE_L = MMSE_L/M;

end