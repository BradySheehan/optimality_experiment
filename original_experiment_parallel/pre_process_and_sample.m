function result = pre_process_and_sample(fromDirectory, toDirectory, patchSize, sig, num)
%load a file, downsample it by two, low-pass filter it, sample patch from it, then save it
dbstop if error
file_list = get_all_files(fromDirectory);
%note that file list may be currently producing bugs
%%CREATE THE GAUSSIAN FILTER
filter = fspecial('gaussian', [patchSize patchSize], sig);
ind = 0;
index = 1;
while ind < num
    %randomly select a file from the list
    index = randi([1, length(file_list)]);
    file = file_list(index);
    [pathstr,name,ext] = fileparts(char(file));
    %check to make sure the file is of the correct format
    if ~isempty(name) && ~isempty(ext)
        k1 = strfind(ext,'.jpg');
        k2 = strfind(char(file),'._');
        if ~isempty(k1) && isempty(k2) %loop over images of the correct format
            %read the image
            image = imread(char(file));
            if size(image,3) == 3 %only want color images from the db
                image = image(1:2:end,1:2:end,:);
                image = imfilter(image, filter, 'same');
                %now randomly select a patch from the image
                n = size(image,1);
                m = size(image,2);
                rows = randi(n-patchSize+1)+(0:patchSize-1);
                cols = randi(m-patchSize+1)+(0:patchSize-1);
                image = image(rows,cols, :);
                %now save the patch
                imwrite(image, sprintf('%s%s%d%s',toDirectory , name,ind, ext), 'jpg', 'Comment',...
                    sprintf('%s%d%s%d%s%s%s%s','downsampled by 2 and gaussian filtered with sigma=',sig, 'and window size=', patchSize, 'from image =',pathstr,name,ext));
                ind = ind + 1;
                if mod(ind,10) == 0
                    ind
                end
            end
        end
    end
end

end