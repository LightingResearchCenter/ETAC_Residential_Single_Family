function [filePaths,fileMetaData] = FindData(parentDir)
%FINDDATA Summary of this function goes here
%   Detailed explanation goes here

ignoreDir = {'.','..','plots','convertedData'}';

sitesListing = dir(parentDir);
idxIgnore = ismember({sitesListing.name}',ignoreDir);
sitesListing(idxIgnore,:) = [];
sitesPaths = fullfile({sitesListing.folder}',{sitesListing.name}');

filePaths = {};
for iSite = 1:numel(sitesPaths)
    fileListing = dir(fullfile(sitesPaths{iSite},'*.xlsx'));
    filePathsTemp = fullfile({fileListing.folder}',{fileListing.name}');
    filePaths = [filePaths;filePathsTemp];
end

[~,fileNames,~] = cellfun(@fileparts,filePaths,'UniformOutput',false);
splitStr = regexp(fileNames,' - ','split');
splitStr = vertcat(splitStr{:});
fileMetaData = cell2table(splitStr,'VariableNames',{'site','room','fixture','sn','season'});
fileMetaData.fileName = fileNames;
end

