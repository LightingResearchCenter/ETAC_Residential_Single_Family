function [data,SN] = ReadHobo(filePath)
%READHOBO Read and process Hobo data from an Excel file
%   Input is complete file path

%% Set import parameters
timeZone = 'America/New_York';

opts = detectImportOptions(filePath,'FileType','spreadsheet','NumHeaderLines',1,'NumVariables',3);
tmp = opts.VariableNames{3};
opts.VariableNames{2} = 'DateTime';
opts.VariableNames{3} = 'MaxIntensity';
opts.SelectedVariableNames = opts.VariableNames(2:3);
opts.MissingRule = 'omitrow';

%% Read serial number
SN = regexprep(tmp,'^.*S_N_(\d*)_$','$1');

%% Import the data
data = readtable(filePath,opts);

%% Set the time zone
data.DateTime.TimeZone = timeZone;

end

