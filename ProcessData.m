% Reset
fclose('all');
close all
clear
clc

% Dependecies
[githubDir,~,~] = fileparts(pwd);
d12packDir = fullfile(githubDir,'d12pack');
addpath(d12packDir);

% File handling
parentDir = '\\root\projects\ETAC-SingleFamilyResidential\sites\consolidated data';
[filePaths,fileMetaData] = FindData(parentDir);

nFiles = numel(filePaths);
h = waitbar(0,'Please wait...');
for iFile = nFiles:-1:1
    [data,SN] = ReadHobo(filePaths{iFile});
    
    if ~isempty(data)
        if height(data) > 1
        % Analysis
        data.LampState = DetermineState(data.MaxIntensity);
        data.AwayState = DetermineAway(data);
        
        stats(iFile,:) = ComputeStats(data);
        
        % Plotting
        reportPath = fullfile(parentDir,'plots',[fileMetaData.fileName{iFile},'.pdf']);
        LampStateReport(reportPath,data,fileMetaData.fileName{iFile})
        close(gcf)
        end
    end
    
    waitbar((nFiles-(iFile-1))/nFiles,h)
end

delete(h)

tableOut = horzcat(fileMetaData(:,1:5),stats);

xlsPath = fullfile(parentDir,'stats.xlsx');
writetable(tableOut,xlsPath)

