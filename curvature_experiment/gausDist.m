function result = gausDist(image1, image2, sig)

%compute l2^2 norm of difference: 
% sum abs of all the squared differences

num_pixels = size(image1,1)*size(image1,2);

diff = imabsdiff(image1,image2);
diff_squared = diff.*diff;
sum_diff_squared = sum(sum(diff_squared(:,:,1))) + sum(sum(diff_squared(:,:,2))) ...
    + sum(sum(diff_squared(:,:,3)));

result = (1/(2*pi*sig^2)^(num_pixels/2)) * ...
    exp(-sum_diff_squared/(2*sig^2));

end