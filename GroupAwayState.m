function groupData = GroupAwayState(groupData)
%GROUPAWAYSTATE Summary of this function goes here
%   Detailed explanation goes here

groupDataCopy = groupData;
idxEmpty = cellfun(@isempty,groupDataCopy,'UniformOutput',true);
groupDataCopy(idxEmpty) = [];

vertData = vertcat(groupDataCopy{:});
dates = dateshift(vertData.DateTime,'start','day');
away = vertData.AwayState;

ungDates = unique(dates);
for iDate = 1:numel(ungDates)
    idx = dates == ungDates(iDate);
    isAway = all(away(idx));
    for iData = 1:numel(groupData)
        if ~isempty(groupData{iData})
            idx = dateshift(groupData{iData}.DateTime,'start','day') == ungDates(iDate);
            groupData{iData}.AwayState(idx) = isAway;
        end
    end
end

end

