function prepare_input()
%this function will generate all the input files for the
%condor submit file

%preprocess larger sample
fromdir1 = '/Users/BradySheehan/Documents/Development/matlab/research/CurvatureBounds/original_experiment_parallel/sample_images/';
todir1 = '/Users/BradySheehan/Documents/Development/matlab/research/CurvatureBounds/original_experiment_parallel/runs/run1/processed/';
% pre_process_data(fromdir1, todir1, 3, 18, 20);

%sample assumed clean patches
num_clean = 10;
fromdir = todir1;
todir2 = '/Users/BradySheehan/Documents/Development/matlab/research/CurvatureBounds/original_experiment_parallel/runs/run1/patches/';
% sample_images_for_patches(fromdir, todir2, 3, 20);

%sample smaller set of pairs
todir3 = '/Users/BradySheehan/Documents/Development/matlab/research/CurvatureBounds/original_experiment_parallel/runs/run1/pairs/';
% sample_images_for_patches(fromdir, todir3, 3, 1);

inputfiledir = '/Users/BradySheehan/Documents/Development/matlab/research/CurvatureBounds/original_experiment_parallel/runs/input/';
patchdir = get_all_files(todir2);
pairdir = get_all_files(todir3);


file = pairdir(1:1)';
mmse_parallel(file, patchdir,18,1);

%now that we have the means and variance, lets compute the bounds

% %for each patch, lets get its path value it and save it with the sigma value
% i = 0;
% for file = patchdir(:)'
%     patch = imread(char(file)); %load and save image for faster processing later
%     save(sprintf('%s%s%d', 'inputfiledir', '/in.', i), 'patch', 'sig');
%     i = i + 1;
% end

end