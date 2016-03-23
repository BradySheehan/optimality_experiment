function result = run()

directory1 = '/Volumes/BS-PORTABLE/curvature_data/sample/patches/';%smaller set of patches, 1000 of these
directory2 = '/Volumes/BS-PORTABLE/curvature_data/sample/patches2/'; %larger population of patches, 10,000 of these
file_list1 = get_all_files(directory1);
file_list2 = get_all_files(directory2);

sig = 18;
patchSize = 5;

ind = 0;
MMSEU = 0;
MMSEL = 0;
for file = file_list1(:)'
    %for each of the files in the directory
    [me, var, x0] = mmse(file,file_list2,sig,ind);
    MMSEU = MMSEU + (me - x0)^2;
    MMSEL = MMSEL + var;
    ind = ind + 1;
end

MMSEL = MMSEL/length(file_list1);
MMSEU = MMSEU/length(file_list2);

save(sprintf('%s%d','output', run),MMSEL, MMSEU, sig, patchSize); 

end