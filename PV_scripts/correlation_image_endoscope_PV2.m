function [Cn, PNR] = correlation_image_endoscope_PV2(Y,gSig)
%% compute correlation image of endoscopic data. it has to spatially filter the data first
%% Input:
%   Y:  d X T matrx, imaging data
%   options: struct data of paramters/options
%       d1:     number of rows
%       d2:     number of columns
%       gSiz:   maximum size of a neuron
%       nb:     number of background
%       min_corr: minimum threshold of correlation for segementing neurons
%  K:  scalar, the rank of the random matrix for projection

%% Output:
%       Cn:  d1*d2, correlation image
%       PNR: d1*d2, peak to noise ratio
%% Author: Pengcheng Zhou, Carnegie Mellon University. zhoupc1988@gmail.com

%% use correlation to initialize NMF
%% parameters
d1 = size(Y,1);        % image height
d2 = size(Y,2);        % image width

sig = 3;    % thresholding noise by sig*std()

if ~ismatrix(Y); Y = reshape(Y, d1*d2, []); end;  % convert the 3D movie to a matrix
Y(isnan(Y)) = 0;    % remove nan values
Y = double(Y);
Y = detrend_data(Y, 2, 'spline');

%% preprocessing data
% create a spatial filter for removing background
if gSig>0
        psf = fspecial('gaussian', ceil(gSig*4+1), gSig);
        ind_nonzero = (psf(:)>=max(psf(:,1)));
        psf = psf-mean(psf(ind_nonzero));
        psf(~ind_nonzero) = 0;
else
    psf = [];
end

% filter the data
if isempty(psf)
    % no filtering
    HY = Y;
else
    HY = imfilter(reshape(Y, d1,d2,[]), psf, 'replicate');
end

HY = reshape(HY, d1*d2, []);
% HY_med = median(HY, 2);
% HY_max = max(HY, [], 2)-HY_med;    % maximum projection
HY = bsxfun(@minus, HY, median(HY, 2));
HY_max = max(HY, [], 2);
Ysig = GetSn(HY);
PNR = reshape(HY_max./Ysig, d1, d2);

HY_thr = HY;
HY_thr(bsxfun(@lt, HY_thr, Ysig*sig)) = 0;

% compute loal correlation
Cn = correlation_image(HY_thr, [1,2], d1,d2);

