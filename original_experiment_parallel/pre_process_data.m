%load a file, downsample it by two, low-pass filter it, then save it
function result = pre_process_data(fromDirectory, toDirectory, windowSize, sig, num)
dbstop if error
file_list = getAllFiles(fromDirectory);
%note that file list may be currently producing bugs
num_edits = 0;

%%CREATE THE GAUSSIAN FILTER
filter = fspecial('gaussian', [windowSize windowSize], sig);
i = 0;

index = 1;

while i < num
    %randomly select a file from the list
    index = randi([1, length(file_list)]);
    
    file = file_list(index);
    [pathstr,name,ext] = fileparts(char(file));
    %check to make sure the file is of the correct format
    if ~isempty(name) && ~isempty(ext)
        k1 = strfind(ext,'.jpg');
        k2 = strfind(char(file),'._');
        if ~isempty(k1) && isempty(k2) %loop over images of the correct format
            image = imread(char(file));
            if size(image,3) == 3 %only want color images from the db
                image = image(1:2:end,1:2:end,:);
                image = imfilter(image, filter, 'same');
                %now save the image
                % path_name = sprintf('%s%s', pathstr, '/pre_processed/');
                imwrite(image, sprintf('%s%s%s',toDirectory , name, ext), 'jpg', 'Comment',...
                    sprintf('%s%s','downsampled by 2 and gaussian filtered with sigma=',sig, 'and window size=', windowSize));
                i = i + 1;
            end
        end
    end
end
end