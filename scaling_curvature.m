patch = im2double(kodim11);
curve = CurvatureMinRGBFast(patch);
%check max/min values
maxc=max(max(max(curve)))
minc=max(min(min(curve)))
figure,subplot(2,2,1),imagesc(curve)
title(strcat('The original curvature ranging [',num2str(minc),',',num2str(maxc),'] viewed with imagesc'));
subplot(2,2,2),imagesc(curve(:,:,1))
title('channel 1');
subplot(2,2,3),imagesc(curve(:,:,2))
title('channel 2');
subplot(2,2,4),imagesc(curve(:,:,3))
title('channel 3');


curve1 = curve(:,:,1);
curve2 = curve(:,:,2);
curve3 = curve(:,:,3);
%try to rescale the curvature
scaled_curve1 = [(curve1 - min(min(curve1)))/(max(max(curve1)) - min(min(curve1)))]*255;
scaled_curve2 = [(curve2 - min(min(curve2)))/(max(max(curve2)) - min(min(curve2)))]*255;
scaled_curve3 = [(curve3 - min(min(curve3)))/(max(max(curve3)) - min(min(curve3)))]*255;
%put it back into a mxnx3 matrix
scaled_curve(:,:,1) = scaled_curve1;
scaled_curve(:,:,2) = scaled_curve2;
scaled_curve(:,:,3) = scaled_curve3;

%check max/min values
maxsc=max(max(max(scaled_curve)))
minsc=min(min(min(scaled_curve)))
%view the images
figure, subplot(2,2,1),imagesc(scaled_curve)
title(strcat('The scaled curvature ranging [',num2str(minsc),',',num2str(maxsc),'] viewed with imagesc'));
subplot(2,2,2),imagesc(scaled_curve(:,:,1))
title('channel 1');
subplot(2,2,3),imagesc(scaled_curve(:,:,2))
title('channel 2');
subplot(2,2,4),imagesc(scaled_curve(:,:,3))
title('channel 3');
figure ,imshow(scaled_curve)
title(strcat('The scaled curvature image ranging [',num2str(minsc),',',num2str(maxsc),'] viewed with imshow'));
%i then noticed that the the scaled_curvature image was in [-255,0] (?).
%So i tried taking the absolute value to see what it would look like

scaled_curve = abs(scaled_curve);
%check max/min values
maxasc=max(max(max(scaled_curve)))
minasc=min(min(min(scaled_curve)))
%view these images
figure, imagesc(scaled_curve)
title(strcat('Abs of the scaled curvature image ranging [',num2str(minasc),',',num2str(maxasc),'] viewed with imagesc'));
figure, imshow(scaled_curve)
title(strcat('Abs of the scaled curvature image ranging [',num2str(minasc),',',num2str(maxasc),'] viewed with imshow'));

%does this make sense? i'm kind of confused by how that image looks
%so, i tried just adding 4, the min value, to the image to see how that
%woudl look
curve2 = curve;
curve2 = curve2 + 4;
%check max/min values
maxp4=max(max(max(curve2)))
minp4=min(min(min(curve2)))
figure, imagesc(curve2)
title(strcat('The original curvature image +4, ranting from [',num2str(minp4),',',num2str(maxp4),'] viewed with imagesc'));
%this image looks better to me that the one scaled between [0,255] but
%still doesn't make a lot of sense to me.