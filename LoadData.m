function [Data,metaData] = LoadData(varargin)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

% Enable dependencies
[githubDir,~,~] = fileparts(pwd);
d12packDir      = fullfile(githubDir,'d12pack');
addpath(d12packDir);

if nargin >= 1
    projectDir = varargin{1};
else
    projectDir = '\\root\projects\ETAC-SingleFamilyResidential\sites\consolidated data\convertedData';
end

ls = dir([projectDir,filesep,'*.mat']);
[~,idxMostRecent] = max(vertcat(ls.datenum));
dataName = ls(idxMostRecent).name;
dataPath = fullfile(projectDir,dataName);

d = load(dataPath);

Data = d.Data;
metaData  = d.metaData;

end

