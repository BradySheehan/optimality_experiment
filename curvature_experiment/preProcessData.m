%load a file, downsample it by two, low-pass filter it, then save it
function result = preProcessData(fromDirectory, toDirectory, windowSize, sig)
dbstop if error
file_list = getAllFiles(fromDirectory);
%note that file list may be currently producing bugs
num_edits = 0;

%%CREATE THE GAUSSIAN FILTER
filter = fspecial('gaussian', [windowSize windowSize], sig); 

    for file = file_list(:)' %loop over all files in the file list
        [pathstr,name,ext] = fileparts(char(file));
        %check to make sure the file is of the correct format
        if ~isempty(name) && ~isempty(ext)
            k1 = strfind(ext,'.jpg');
            k2 = strfind(char(file),'._');

            if ~isempty(k1) && isempty(k2) %loop over images of the correct format

                image = imread(char(file));
                if size(image,3) == 3 %only want color images from the db
                    image = imresize(image, 0.5); %downsample by 2
                    image = imfilter(image, filter, 'same');
                        %now save the image
                       % path_name = sprintf('%s%s', pathstr, '/pre_processed/');
                        imwrite(image, sprintf('%s%s%s',toDirectory , name, ext), 'jpg', 'Comment',...
                            sprintf('%s%s','downsampled by 2 and gaussian filtered with sigma=',sig, 'and window size=', windowSize));
                        num_edits = num_edits + 1;
                end


            end
            clear('image','temp1', 'temp2', 'temp3');
        end
        num_edits;
    end
end