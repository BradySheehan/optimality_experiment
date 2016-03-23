%%
% note that input('', 's') reads from standard input and fprinf writes to standard
% output
%
%note that cleandir is a list of paths referenceing patches
function [me, var, x0] = mmse(patchdir, cleandir, sig, processNumber)

%when we run this with condor, we will need to read the input from
%standard in 
patch = imread(char(patchdir));
patch = 255*im2double(patch);
n = size(patch,1);
m = size(patch,2);
noisy_patch = patch;
noisy_patch(:,:,1) = noisy_patch(:,:,1) + sig*rand(m,n);
noisy_patch(:,:,2) = noisy_patch(:,:,2) + sig*rand(m,n);
noisy_patch(:,:,3) = noisy_patch(:,:,3) + sig*rand(m,n);

%compute the curvature of each patch
patch_c = CurvatureMinRGBFast(patch);
noisy_patch_c = CurvatureMinRGBFast(noisy_patch);


x0 = find_center(patch_c);
%compute the mean
num1 = 0;
den1 = 0;
N = length(cleandir(:)');
for file = cleandir(:)' %for all of the clean patches
    %[pathstr,name,ext] = fileparts(char(file));
    clean = imread(char(file));
    clean = 255*im2double(clean);
    clean = CurvatureMinRGBFast(clean);
    l = laplaceDist(noisy_patch_c, clean);
    num1 = num1 + l*x0;
    den1 = den1 + l;
end

num1 = num1/N;
den1 = den1/N;
if den1 == 0
    me = 0;
else
    me = num1/den1;
end


num2 = 0;
den2 = 0;
%now compute the variance
for file = cleandir(:)' %for all of the clean patches
    %[pathstr,name,ext] = fileparts(char(file));
    clean = imread(char(file));
    clean = 255*im2double(clean);
    clean = CurvatureMinRGBFast(clean);
    l = laplaceDist(noisy_patch_c, clean);
    num2 = num2 + l*(me - x0) ^ 2;
    den2 = den2 + l;
end

num2 = num2/N;
den2 = den2/N;
if den2 == 0
    var = 0;
else
    var = num2/den2;
end

save(sprintf('%s%d', 'process', processNumber), 'me', 'var', 'patchdir', 'x0');
