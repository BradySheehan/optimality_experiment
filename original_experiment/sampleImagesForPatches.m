
function result = sampleImagesForPatches(fromDirectory, toDirectory, patchSize, num)

%we will randomly select an image
%then randomly select a kxk patch within the image
%save this image back to disk (we want to load only one image at a time)
fromDirectoryList = getAllFiles(fromDirectory);
numFiles = length(fromDirectoryList);
for N = 1:num
    rand = randi([1 numFiles]);
    [pathstr,name,ext] = fileparts(char(fromDirectoryList(rand)));
    if ~isempty(name) && ~isempty(ext)
        k1 = strfind(ext,'.jpg');
        k2 = strfind(char(fromDirectoryList(rand)),'._');
        if ~isempty(k1) && length(k2) == 0 %loop over images of the correct format
            patch = imread(char(fromDirectoryList(rand)));
            if size(patch,3) == 3 %only want color images from the db
                n = size(patch,1);
                m = size(patch,2);
                %figure, imagesc(patch), title(sprintf('%s', 'patch name = ', name));
                %randomly select a patch from within the image
                rows = randi(n-patchSize+1)+(0:patchSize-1);
                cols = randi(m-patchSize+1)+(0:patchSize-1);
                patch = patch(rows,cols, :);
                imwrite(patch, sprintf('%s%s%s%s',toDirectory ,name, 'patch', ext), 'jpg', 'Comment',...
                    sprintf('%s%s','patch taken from ',name, 'with window size=', patchSize));
            end
        end
    end
end
end
