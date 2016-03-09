function result = varianceForMMSE(image1, dirFileList, sig)
numerator = 0;
denominator = 0;
N = length(dirFileList(:)');
parfor i = 1:N    %comptue the numerator and denominator
    file = dirFileList(i)';
    [pathstr,name,ext] = fileparts(char(file));
    %check to make sure the file is of the correct format
    if ~isempty(name) && ~isempty(ext)
        k1 = strfind(ext,'.jpg');
        k2 = strfind(char(file),'._');
        if ~isempty(k1) && isempty(k2) %loop over images of the correct format
            patch = imread(char(file));
            patch = 255*im2double(patch);
            %comptue the numerator and denominator
            numerator = numerator + gausDist(image1, patch, sig)*...
                ( meanForMMSE(image1, dirFileList, sig) - find_center(patch)) ^ 2;
            denominator = denominator + gausDist(image1, patch, sig);
        end
    end
end

numerator = numerator/N;
denominator = denominator/N;
if denominator == 0
    result = 0;
else
    result = numerator/denominator;
    
end