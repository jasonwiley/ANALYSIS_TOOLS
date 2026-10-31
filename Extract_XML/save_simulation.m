% A script to save your simulation data to a .mat file.
% If a variable, save_name, exists, this script saves to save_name.mat
% If not, you will be prompted to define save_name.

if ~exist('savename','var')
    savename=input('Save Name=','s');
end

if exist('dim','var')
    save(savename,'dim','-v7.3');
else
    dim=[xdim ydim zdim];
    save(savename,'dim','-v7.3');
end
if exist('pos','var')
    save(savename,'pos','-v7.3','-append');
end
if exist('attype','var')
    save(savename,'attype','-append');
end
if exist('bonds','var')
    save(savename,'bonds','-append');
end
if exist('angles','var')
    save(savename,'angles','-append');
end
if exist('vel','var')
    save(savename,'vel','-append');
end
if exist('acc','var')
    save(savename,'acc','-append');
end
if exist('nactive','var')
    save(savename,'nactive','-append');
end
if exist('mass','var')
    save(savename,'mass','-append');
end
