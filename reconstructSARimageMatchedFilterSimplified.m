% Function that creates 2-D SAR Image 
% -------------------------------------------------------------------------
% Developed by:
% Muhammet Emin Yanik
% Prof. Murat Torlak

% -------------------------------------------------------------------------
%  Copyright 2018, The University of Texas at Dallas
% -------------------------------------------------------------------------

function sarImage = reconstructSARimageMatchedFilterSimplified(sarData,matchedFilter,xStepM,yStepM,xySizeT)
% Example function calls, see details below
% -------------------------------------------------------------------------
% sarImage = reconstructSARimageMatchedFilterSimplified(sarData,matchedFilter,200/406,2,200);

% Variables
% -------------------------------------------------------------------------
% This code creates SAR Image for the following scenario:
% sarData: nVertical x nHorizontal 2-D SAR Data
% matchedFilter: nVertical x nHorizontal 2-D Matched Filter
% xStepM: measurement step size at x (horizontal) axis in mm (only used for data display)
% yStepM: measurement step size at y (vertical) axis in mm (only used for data display)
% xySizeT: Target size in mm (only used for data display)

%% sarData should be in following format
% yPointM x xPointM
[yPointM,xPointM] = size(sarData);
[yPointF,xPointF] = size(matchedFilter);


%% Equalize Dimensions of sarData and Matched Filter with Zero Padding
if (xPointF > xPointM)
    sarData = padarray(sarData,[0 floor((xPointF-xPointM)/2)],0,'pre');
    sarData = padarray(sarData,[0 ceil((xPointF-xPointM)/2)],0,'post');
else  
    matchedFilter = padarray(matchedFilter,[0 floor((xPointM-xPointF)/2)],0,'pre');
    matchedFilter = padarray(matchedFilter,[0 ceil((xPointM-xPointF)/2)],0,'post');
end

if (yPointF > yPointM)
    sarData = padarray(sarData,[floor((yPointF-yPointM)/2) 0],0,'pre');
    sarData = padarray(sarData,[ceil((yPointF-yPointM)/2) 0],0,'post');
else  
    matchedFilter = padarray(matchedFilter,[floor((yPointM-yPointF)/2) 0],0,'pre');
    matchedFilter = padarray(matchedFilter,[ceil((yPointM-yPointF)/2) 0],0,'post');
end

%% Create SAR Image
sarDataFFT = fft2(sarData);
matchedFilterFFT = fft2(matchedFilter);
sarImage = fftshift(ifft2(sarDataFFT .* matchedFilterFFT));

%% Define Target Axis
[yPointT,xPointT] = size(sarImage);

xRangeT = xStepM * (-(xPointT-1)/2 : (xPointT-1)/2); % xStepM is in mm
yRangeT = yStepM * (-(yPointT-1)/2 : (yPointT-1)/2); % yStepM is in mm

%% Crop the Image for Related Region
indXpartT = xRangeT>(-xySizeT/2) & xRangeT<(xySizeT/2);
indYpartT = yRangeT>(-xySizeT/2) & yRangeT<(xySizeT/2);

xRangeT = xRangeT(indXpartT);
yRangeT = yRangeT(indYpartT);
sarImage = sarImage(indYpartT,indXpartT);

%% Plot SAR Image
figure; mesh(xRangeT,yRangeT,abs(fliplr(sarImage)),'FaceColor','interp','LineStyle','none')
view(2)
colormap('jet');

xlabel('Horizontal (mm)')
ylabel('Vertical (mm)')
titleFigure = "SAR Image - Matched Filter Response";
title(titleFigure)
