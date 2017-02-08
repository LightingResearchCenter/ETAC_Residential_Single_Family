function stats = ComputeStats(data)
%COMPUTESTATS Summary of this function goes here
%   Detailed explanation goes here

epoch       = mode(diff(data.DateTime));
occupiedOn	= ~data.AwayState & data.LampState;
occupiedOff	= ~data.AwayState & ~data.LampState;

stats = table;
stats.monitoringStart           = data.DateTime(1);
stats.monitoringEnd             = data.DateTime(end);
stats.monitoringDuration_days	= days(stats.monitoringEnd - stats.monitoringStart);

occupiedDuration             = epoch*sum(~data.AwayState);
stats.occupiedDuration_days	 = days(occupiedDuration);
stats.occupiedDuration_hours = hours(occupiedDuration);

stats.occupiedOn_hours	= hours(epoch*sum(occupiedOn));
stats.occupiedOff_hours	= hours(epoch*sum(occupiedOff));
stats.hoursOnPerDay     = stats.occupiedOn_hours*24/hours(occupiedDuration);

end

