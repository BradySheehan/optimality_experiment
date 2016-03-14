function result = computeMMSE()

% this experiment uses the following functions:
% gausDist(), meanForMMSE(), varianceForMMSE(), sampleImagesForPatches(), preProcessData()
%
% ======================== parameters =================================
fromDirectory = '/Volumes/BS-PORTABLE/curvature_data/static_web_submitted_jenny_rome'; %directory for assumed clean images
toDirectory = '/Volumes/BS-PORTABLE/curvature_data/original_experiment/run4/processed/';   %where we're moving that after pre processing
cleanImagePatchDirectory = '/Volumes/BS-PORTABLE/curvature_data/original_experiment/run4/patches/' ; %where we are putting the sampled clean patches
fromDirectory2 = '/Volumes/BS-PORTABLE/curvature_data/fink_static_indoor_officepanorama_small/'; %other directory for clean images
toDirectory2 = '/Volumes/BS-PORTABLE/curvature_data/original_experiment/run4/pairs/';   %this is where we will put the images from toDirectory2
                   %that get patches sampled from them
numCleanPatches = 1500; %n
numPairs = 200; %M
windowSize = 5;
sig = 18;
run = 5;
% ======================== parameters =================================
%
% % =================preprocess the image data============================
% % 
tic
% %     process the N clean images %
  % preProcessData(fromDirectory, toDirectory, windowSize, sig);
% % %  % reads the images from disk and randomly selects  an image and then randomly selects a patch 
% % %  % and writes it back to a new directory
  % sampleImagesForPatches(toDirectory, cleanImagePatchDirectory, windowSize, numCleanPatches); 
 cleanPatches = getAllFiles(cleanImagePatchDirectory); %note that this is a file list
% 
% %     process the M clean images %
% 
% % 
  %sampleImagesForPatches(fromDirectory2, toDirectory2, windowSize, numPairs); 
 pairPatches = getAllFiles(toDirectory2); %note that this is a file list
 display('preprocesssing time')
 toc
% 
% % =================preprocess the image data============================
%%
% =================== compute MMSE Bounds ==============================
MMSE_U = 0;
MMSE_L = 0;
M = length(pairPatches(:)');
i = 1;
tic
for file = pairPatches(:)' %for all of the pairs of clean and noisy images
    [pathstr,name,ext] = fileparts(char(file));
    %check to make sure the file is of the correct format
    if ~isempty(name) && ~isempty(ext)
        k1 = strfind(ext,'.jpg');
        k2 = strfind(char(file),'._');
        if ~isempty(k1) && isempty(k2) %loop over images of the correct format
            patch = imread(char(file));
            if size(patch,3) == 3 %only want color images from the db
                % ============ CREATE THE NOISY PATCH =================
                patch = 255*im2double(patch);
                n = size(patch,1);
                m = size(patch,2);
                noisy_patch = patch;
                noisy_patch(:,:,1) = noisy_patch(:,:,1) + sig*rand(m,n);
                noisy_patch(:,:,2) = noisy_patch(:,:,2) + sig*rand(m,n);
                noisy_patch(:,:,3) = noisy_patch(:,:,3) + sig*rand(m,n);
                
                % ============ compute MMSEU and MMSEL ================
                
                % this function computes the squared difference between the mean of the
                % noisy patch and the center pixel of the jth clean patch
                var{i} = varianceForMMSE(noisy_patch, cleanPatches, sig);
                me{i} = meanForMMSE(noisy_patch, cleanPatches, sig);
                MMSE_U = MMSE_U + ...
                    ( me{i} - find_center(patch)) ^ 2;
                % this function computes the variance of the noisy patch
                % for all clean patches
                MMSE_L = MMSE_L + var{i};
                i = i + 1;
                i
            end
        end
    end
end
display('finished msse upper and lower') 
toc
MMSE_U = MMSE_U/M;
MMSE_L = MMSE_L/M;
% =================== compute MMSE Bounds ==============================
%%
%in the process, what do we want to save from all these computations?
% we want to save what sigma we used, what the directories were
% we want to save for each mmse upper and lower as we go
% and... oh! what filter we used. with what window size


numCleanPatches = length(cleanPatches(:)');
save(sprintf('%s%d', 'run', run), 'MMSE_U', 'MMSE_L', 'sig', 'windowSize','var', 'me', 'numCleanPatches')

end