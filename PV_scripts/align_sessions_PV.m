function align_sessions_PV()

myFolder=uigetdir;
filePattern = fullfile(myFolder, '*.h5');
theFiles = dir(filePattern);
Vid={};
Cn={};

for i=1:size(theFiles,1)
    baseFileName = theFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    temp=h5read(fullFileName,'/Object');
    Vid{i}=temp;
%     [Coor, PNR] = correlation_image_endoscope_PV2(temp,4);
    Cn{i}=mean(temp,3);   
end
X=catpad(3,Cn{:});
t=~isnan(mean(X,3));
X=remove_borders(X,t);
Vid=remove_borders(Vid,t);
X=filter_image(X);
% options_rigid = NoRMCorreSetParms('d1',size(X,1),'d2',size(X,2),'d3',1,'max_shift',60,'init_batch',1);
% [M,shifts,~,~] = normcorre_test(X,options_rigid);
% shifts=convert_shifts(shifts,N)
% out = apply_shifts(Vid,shifts,options_rigid);



end

function out=filter_image(in)
h1 = fspecial('disk',20);
h2 = fspecial('disk',4);

out=zeros(size(in,1),size(in,2),size(in,3));
for i=1:size(in,3)
    temp=double(in(:,:,i));
    temp=temp-imfilter(temp,h1,'replicate');
    temp=imfilter(temp,h2,'replicate');
    m=nanmean(temp,'all');
    temp=((temp-m)*-1)+m;
    out(:,:,i)=mat2gray(temp);
end

end

function out=remove_borders(in,t)
binaryImage=~isnan(mean(in,3));

  % Take the largest blob only.
edtImage = bwdist(~binaryImage);
% Display the image.
imshow(edtImage, []);
axis on;
caption = sprintf('Distance Transform Image');
title(caption, 'FontSize', 12, 'Interpreter', 'None');
hp = impixelinfo();
drawnow;
% Find the max of the EDT:
maxDistance = max(edtImage(:));
[rowCenter, colCenter] = find(edtImage == maxDistance,1);
hold on;
plot(colCenter, rowCenter, 'r+', 'MarkerSize', 30, 'LineWidth', 2);
% Get the boundary of the blob.
boundaries = bwboundaries(binaryImage);
b = boundaries{1}; % Extract from cell.
x = b(:, 2);
y = b(:, 1);
% Get distances from center to each of the edge pixels.
distances = sqrt((x - colCenter).^2 + (y - rowCenter).^2);
% Find the min distance.
[minDistance, indexOfMin] = min(distances);
% Find x and y of the min
xMin = x(indexOfMin);
yMin = y(indexOfMin);
plot(xMin, yMin, 'co', 'MarkerSize', 10, 'LineWidth', 2);
% Get the delta x and delta y from center to corner
dx = abs(colCenter - xMin);
dy = abs(rowCenter - yMin);
% Get edges of rectangle by adding and subtracting deltas from center.
row1 = rowCenter - dy;
row2 = rowCenter + dy;
col1 = colCenter - dx;
col2 = colCenter + dx;
% Make a box so we can plot it.
xBox = [col1, col2, col2, col1, col1];
yBox = [row1, row1, row2, row2, row1];
plot(xBox, yBox, 'r-', 'LineWidth', 2);
end


function align(Vid)

for s=2:size(Vid,2)
    X=catpad(3,Vid{s-1}(:,:,end),Vid{s}(:,:,1));
    t=~isnan(mean(X,3));
    X=remove_borders(X,t);
    Vid{s-1}=remove_borders(Vid{s-1},t);
    Vid{s}=remove_borders(Vid{s},t);
    REF=filter_image(X(:,:,1));
    IMG=filter_image(X(:,:,2));
    [optimizer, metric] = imregconfig('Monomodal');
    tf= imregtform(REF,IMG,'similarity', optimizer, metric);
    temp=Vid{s};
    temp_mc=[];
    for i=1:size(temp,3)
        temp_mc(:,:,i) = imwarp(temp(:,:,i),tf);
    end
    temp_mc(temp_mc==0)=nan;
    Vid{s}=temp_mc;
end
    out=catpad(3,Vid{:});

end
    
        
    
    
    
    
    

% function out=convert_shifts(shifts,N)
% N = [0,cumsum(N)];
% for i=1:size(shifts,1)
%     x1=N(i)+1;
%     x2=N(i+1);
%     out(x1:x2)=shifts(i)';
% end
% end
%     
%     
    
    
    
