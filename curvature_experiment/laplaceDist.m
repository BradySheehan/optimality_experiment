function result = laplaceDist(image1, image2)
%function assumes image1 and image2 are square images of the same size
%(probably image patches)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %for all the pixelwise differences,
% 
abs_diff = imabsdiff(image1, image2);

num_pixels = size(image1,1)*size(image1,2);

%alternative version: compute the median and use it in the computation:
med = median(abs_diff);
diff = bsxfun(@minus, abs_diff, med);

%NOTE: diff is multichannel so we need to sum all the sums of each channel
%for l1 norm
sum_diff = sum(sum(diff(:,:,1))) + sum(sum(diff(:,:,2))) + sum(sum(diff(:,:,3))) ;


b = sum_diff./num_pixels;
bx2 = bsxfun(@times, b, 2);

%result
result = (exp(-(sum_diff)./(b)))/(bx2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % %here lets assume its the mean instead of the median and lets assume its
% % % %zero

% abs_diff = imabsdiff(image1, image2);
% 
% num_pixels = size(image1,1)*size(image1,2);
% 
% %NOTE: diff is multichannel so we need to sum all the sums of each channel
% %for l1 norm
% sum_diff = sum(sum(abs_diff(:,:,1))) + sum(sum(abs_diff(:,:,2))) + sum(sum(abs_diff(:,:,3))) ;
% 
% 
% b = sum_diff./num_pixels;
% bx2 = bsxfun(@times, b, 2);
% 
% %result
% result = (exp(-(sum_diff)./(b)))/(bx2);
end