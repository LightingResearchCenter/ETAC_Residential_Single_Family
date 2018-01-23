% Reset
fclose('all');
close all
clear
clc

% Dependecies
[githubDir,~,~] = fileparts(pwd);
d12packDir = fullfile(githubDir,'d12pack');
addpath(d12packDir);

projectDir = '\\root\projects\ETAC-SingleFamilyResidential\sites\consolidated data';

% Load data
[Data,metaData] = LoadData;

% Find unique sites and seasons
unqSites   = unique(metaData.site);
unqSeasons = unique(metaData.season);

% Edit away state based on entire location during that season
for iSite = 1:numel(unqSites)
    thisSite    = unqSites{iSite};
    thisSiteIdx = ismember(metaData.site,thisSite);
    
    for iSeason = 1:numel(unqSeasons)
        thisSeason    = unqSeasons{iSeason};
        thisSeasonIdx = ismember(metaData.season,thisSeason);
        
        theseIdx  = thisSiteIdx & thisSeasonIdx;
        theseData = Data(theseIdx);
        theseMeta = metaData(theseIdx,:);
        
        if ~isempty(theseData)
            theseDataAdj = GroupAwayState(theseData);
            Data(theseIdx) = theseDataAdj;
        end
    end
end

nFiles = numel(Data);
message = sprintf('Please wait.File %d of %d completed.',0,nFiles);
h = waitbar(0,message);

stats = table;
stats.monitoringStart         = NaT(nFiles,1,'TimeZone','local');
stats.monitoringEnd           = NaT(nFiles,1,'TimeZone','local');
stats.monitoringDuration_days = NaN(nFiles,1);
stats.occupiedDuration_days	  = NaN(nFiles,1);
stats.occupiedDuration_hours  = NaN(nFiles,1);
stats.occupiedOn_hours	      = NaN(nFiles,1);
stats.occupiedOff_hours	      = NaN(nFiles,1);
stats.hoursOnPerDay           = NaN(nFiles,1);

for iFile = 1:nFiles
    data = Data{iFile};
    
    if ~isempty(data)
        if height(data) > 1
        % Analysis
        stats(iFile,:) = ComputeStats(data);
        
        % Plotting
        reportPath = fullfile(projectDir,'plots',[metaData.fileName{iFile},'.pdf']);
        LampStateReport(reportPath,data,metaData.cutoff_percent(iFile),metaData.fileName{iFile})
        close(gcf)
        end
    end
    message = sprintf('Please wait. File %d of %d completed.',iFile,nFiles);
    waitbar(iFile/(nFiles+1),h,message)
end
message = sprintf('Please wait. Saving stats to Excel...');
waitbar(1,h,message)

tableOut = horzcat(metaData,stats);

xlsPath = fullfile(projectDir,['stats_',datestr(now,'yyyy-mm-dd_HHMM'),'.xlsx']);
writetable(tableOut,xlsPath)

delete(h)