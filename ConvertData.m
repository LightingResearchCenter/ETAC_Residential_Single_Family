% Reset
fclose('all');
close all
clear
clc

% File handling
parentDir = '\\root\projects\ETAC-SingleFamilyResidential\sites\consolidated data';
[filePaths,metaData] = FindData(parentDir);

custom = readtable('CustomCutoffs.xlsx');

nFiles = numel(filePaths);
message = sprintf('Please wait.File %d of %d completed.',0,nFiles);
h = waitbar(0,message);

Data = cell(nFiles,1);

for iFile = 1:nFiles
    [hoboData,~] = ReadHobo(filePaths{iFile});
    
    if ~isempty(hoboData)
        if height(hoboData) > 1
            
            % Analysis
            [Lia,Lib] = ismember(metaData.fileName{iFile},custom.fileName);
            if Lia
                cutoff = custom.cutoff(Lib);
                [hoboData.LampState,metaData.cutoff_percent(iFile),metaData.cutoff_lumPerSqFt(iFile)] = DetermineState(hoboData.MaxIntensity,cutoff);
            else
                [hoboData.LampState,metaData.cutoff_percent(iFile),metaData.cutoff_lumPerSqFt(iFile)] = DetermineState(hoboData.MaxIntensity);
            end
            hoboData.AwayState = DetermineAway(hoboData);
            
            Data{iFile,1} = hoboData;
        end
    end
    message = sprintf('Please wait. File %d of %d converted.',iFile,nFiles);
    waitbar(iFile/(nFiles+1),h,message)
end
message = sprintf('Please wait. Saving converted data...');
waitbar(1,h,message)

saveName = [datestr(now,'yyyy-mm-dd_HHMM'),'.mat'];
savePath = fullfile(parentDir,'convertedData',saveName);
save(savePath,'Data','metaData');

delete(h)