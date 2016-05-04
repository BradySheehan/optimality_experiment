function result = pre_process_and_sample(fromDirectory, patchSize, sig, num_patches, filter)
%load a file, downsample it by two, low-pass filter it, sample patch from it
dbstop if error
file_list = fromDirectory;
patches = zeros(patchSize^2, num_patches);
for ii = 1:num_patches
    %randomly select a file from the list
    index = randi([1, length(file_list)]);
    file = file_list(index);
    [pathstr,name,ext] = fileparts(char(file));
    %check to make sure the file is of the correct format
    if ~isempty(name) && ~isempty(ext)
            %read the image
        image = imread(char(file));
        image = 255*im2double(rgb2gray(image));
        image = image(1:2:end,1:2:end);
        image = imfilter(image, filter, 'same');
        %now randomly select a patch from the image
        n = size(image,1);
        m = size(image,2);
        rows = randi(n-patchSize+1)+(0:patchSize-1);
        cols = randi(m-patchSize+1)+(0:patchSize-1);
        image = image(rows,cols);
        patches(:,ii) = reshape(image, patchSize^2, 1);
    end
end
result = patches;
end