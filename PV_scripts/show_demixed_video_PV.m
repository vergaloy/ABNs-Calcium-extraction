function show_demixed_video_PV(obj,tmp_range,mult)
%show_demixed_video_PV(neuron,[3660 3700],2);  
amp_ac=3;

if ~exist('tmp_range', 'var') || isempty(tmp_range)
    tmp_range = obj.frame_range  ;
end
try
    Y = mat2gray(obj.load_patch_data([], tmp_range));
catch
    try
        name=dir(fullfile(obj.P.log_folder, '*.h5'));
        file=fullfile(obj.P.log_folder,name(1).name);
        Y = mat2gray(h5read(file,'/Object',[1 1 tmp_range(1) 1],[inf inf tmp_range(2)-tmp_range(1)+1 1]));
    catch
        warning('Choose .h5 file location with "neuron.P.log_folder=strcat(uigetdir,''\'')"');
    end
end

Ybg=Y-imgaussfilt(Y,40);
Ybg=mat2gray(Y-mean(Y,3));
mg_ac = mat2gray(obj.reshape(obj.A*obj.C(:, tmp_range(1):tmp_range(2)), 2));
t=cat(2,Y,Ybg,mg_ac*mult);
implay(t);

