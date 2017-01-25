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
filePath = 'sampleHoboData.xlsx';
[data,SN] = ReadHobo(filePath);

% Analysis
data.LampState = DetermineState(data.MaxIntensity);
data.AwayState = DetermineAway(data);

% Plotting
reportPath = 'samplePlot.pdf';
LampStateReport(reportPath,data)
winopen(reportPath)