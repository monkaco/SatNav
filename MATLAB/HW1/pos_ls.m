function [estXYZ, estBias] = pos_ls(time, satsXYZ, prData, nomXYZ, clkBiasNom) 
% Function [estXYZ, estBias] = pos_ls(satsXYZ, prData, nomXYZ, clkBiasNom) 
% estimates position in coordinate system ECEF (XYZ) in meters, and the
% clock bias in seconds.
% 
% INPUT:
%   time        - GPS time week 1711, [s].
%	satsXYZ     - ECEF satellite positions, [m].
%	prData      - GPS pseudorange measurements, [m].
%	nomXYZ      - ECEF initial condition for position, [m].
%	clkBiasNom  - Initial condition for clock bias, [s].
%
% OUTPUT:
%	estXYZ  - Estimated ECEF position, [m]
%	estBias - Estimated clock bias, [s]
% ---------------------------- ABOUT --------------------------------------
% HOMERWORK #1
% COURSE:           Satellite Navigation (MAE-561)
% PROFESSOR:        Dr. Gross
% STUDENT NAME:     Rogerio R. Lima
% STUDENT WVU ID:   800 329 625
% DATE & PLACE:     Jan/2020 @ WVU/Morgantown
% -------------------------------------------------------------------------

