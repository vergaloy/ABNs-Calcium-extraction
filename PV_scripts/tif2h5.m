function nam_h5 = tif2h5()
%% convert tiff files into mat files
% inputs:
%   nam: file names
% output:
%   nam_mat: name of the *.mat file


myFolder =uigetdir;  %Write the path with the
filePattern = fullfile(myFolder, '*.tif*'); % Change to whatever pattern you need.
theFiles = dir(filePattern);


for k=1:length(theFiles)
    clearvars -except filePattern theFiles k myFolder
    close all
    baseFileName = theFiles(k).name;
    nam = fullfile(myFolder, baseFileName);
    fprintf(1, 'Now reading %s\n', nam);
    %% Constrained Nonnegative Matrix Factorization for microEndoscopic data  * *
    % *STEP*0: select data
    
    warning('off','all')
    
    [tmp_dir, tmp_file, ~] = fileparts(nam);
    nam_h5 = sprintf('%s%s%s.h5', tmp_dir, filesep, tmp_file);
    info = imfinfo(nam);
    %%
    d1 = info.Height;   % height of the image
    d2 = info.Width;    % width of the image
     T = length(info);   % number of frames
    %%
    fprintf('Converting TIFF file to *.h5 file');
    
     Tchunk = min(T, round(2^29/d1/d2)); %each chunk uses at most 4GB
    lin=round(linspace(1,T+1,ceil(T/Tchunk)+1));
    for i=2:length(lin)
        warning('off','all')
        num2read = lin(i)-lin(i-1);
        t0= lin(i-1);
        tmpY{i} = smod_bigread2(nam, t0, num2read);
    end
    
    Y=uint16(catpad(3,tmpY{:}));
    %%
    saveash5(Y(:,:,2:end),nam_h5);
end





