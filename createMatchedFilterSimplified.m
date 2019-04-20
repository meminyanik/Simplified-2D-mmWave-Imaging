% Function that creates matched filter 
% -------------------------------------------------------------------------
% Developed by:
% Muhammet Emin Yanik
% Prof. Murat Torlak

% -------------------------------------------------------------------------
%  Copyright 2018, The University of Texas at Dallas
% -------------------------------------------------------------------------

function matchedFilter = createMatchedFilterSimplified(xPointM,xStepM,yPointM,yStepM,zTarget)
% Example function calls, see details below
% -------------------------------------------------------------------------
% Matched filter for Tx0-Rx0 antenna pair with monostatic assumption
% matchedFilter = createMatchedFilterSimplified(512,200/406,512,2,400)

% Coordinate system
% -------------------------------------------------------------------------
% x is the Horizontal axis
% y is the Vertical axis
% z is the Depth axis

% Variables
% -------------------------------------------------------------------------
% This code creates Matched Filter for the following scenario:
% xPointM: number of measurement points at x (horizontal) axis
% xStepM: Sampling distance at x (horizontal) axis in mm
% yPointM: number of measurement points at y (vertical) axis
% yStepM: Sampling distance at y (vertical) axis in mm
% zTarget: z distance of target in mm

%-------------------------------------------------------------------------%
% Define Fixed Parameters
%-------------------------------------------------------------------------%
f0 = 77e9; % start frequency
c = physconst('lightspeed');

%-------------------------------------------------------------------------%
% Define Measurement Locations at Linear Rail
% Coordinates: [x y z], x-Horizontal, y-Vertical, z-Depth
%-------------------------------------------------------------------------%
x = xStepM * (-(xPointM-1)/2 : (xPointM-1)/2) * 1e-3; % xStepM is in mm
y = (yStepM * (-(yPointM-1)/2 : (yPointM-1)/2) * 1e-3).'; % yStepM is in mm
      
%-------------------------------------------------------------------------%
% Define Target Locations
% Coordinates: [x y z], x-Horizontal, y-Vertical, z-Depth
%-------------------------------------------------------------------------%
z0 = zTarget*1e-3; % zTarget is in mm

%--------------------------------------------------------------------------
% Create Single Tone Matched Filter
%--------------------------------------------------------------------------
k = 2*pi*f0/c;
matchedFilter = exp(-1i*2*k*sqrt(x.^2 + y.^2 + z0^2));