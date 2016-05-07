function results = b_paramater_estimates()    
    %load an image
    %compute curvature
    %add noise, save this copy
    %subtract difference
    sig = 18;
    from_dir = 'Volumes/BS-PORTABLE/images/';
    file_list = get_all_files(from_dir);
    num_tries = 50;
    for ind = 1:num_tries
        index = randi([1, length(file_list)]);
        file = file_list(index);
        [pathstr,name,ext] = fileparts(char(file));
        if ~isempty(name) && ~isempty(ext)
            image = imread(char(file));
            image = 255*im2double(rgb2gray(image));
            [m,n] = size(image);
            noisy_image = image + sig*randn(m,n);
            curv_im_clean = IterativeCurvatureMinEpsilon(image);
            curv_im_noisy = IterativeCurvatureMinEpsilon(noisy_image);
            diff = curv_im_noisy - curv_im_clean;
            diff2 = reshape(diff, 1, m*n);
            med = median(diff2); 
            
            %now compute b
            results(ind) = sum(sum(abs(diff - med*(ones(size(diff))))))/(size(diff,1)*size(diff,2));
        end

    end
end