function [filePaths,fileMetaData] = FindData(parentDir)
%FINDDATA Summary of this function goes here
%   Detailed explanation goes here

ignoreDir = {'.','..','plots'}';

sitesListing = dir(parentDir);
idxIgnore = ismember({sitesListing.name}',ignoreDir);
sitesListing(idxIgnore,:) = [];
sitesPaths = fullfile({sitesListing.folder}',{sitesListing.name}');

seasonsPaths = {};
for iSite = 1:numel(sitesPaths)
    seasonsListing = dir(sitesPaths{iSite});
    idxIgnore = ismember({seasonsListing.name}',ignoreDir);
    seasonsListing(idxIgnore,:) = [];
    seasonsPathsTemp = fullfile({seasonsListing.folder}',{seasonsListing.name}');
    seasonsPaths = [seasonsPaths;seasonsPathsTemp];
end

filePaths = {};
for iSeason = 1:numel(seasonsPaths)
    fileListing = dir(fullfile(seasonsPaths{iSeason},'*.xlsx'));
    filePathsTemp = fullfile({fileListing.folder}',{fileListing.name}');
    filePaths = [filePaths;filePathsTemp];
end

[~,fileNames,~] = cellfun(@fileparts,filePaths,'UniformOutput',false);
splitStr = regexp(fileNames,' - ','split');
splitStr = vertcat(splitStr{:});
fileMetaData = cell2table(splitStr,'VariableNames',{'site','room','fixture','sn','season'});
fileMetaData.fileName = fileNames;
end

