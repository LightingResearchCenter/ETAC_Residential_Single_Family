function state = DetermineAway(data)
%DETERMINEAWAY Summary of this function goes here
%   false = present, true = away

awayThreshold = 72;

LampState = data.LampState;

% Find off bouts
D1 = diff([~LampState(1);LampState]);
D2 = diff([LampState;~LampState(end)]);

offStarts = data.DateTime(D1 == -1);
offEnds = data.DateTime(D2 == 1);

% Short circuit
if numel(offStarts)<1 || numel(offEnds)<1
    state = false(size(LampState));
    return
end

% Find away bouts
boutDurations = offEnds - offStarts;
boutsAway = boutDurations > duration(awayThreshold,0,0);

offStarts = offStarts(boutsAway);
offEnds = offEnds(boutsAway);

% Short circuit
if numel(offStarts)<1 || numel(offEnds)<1
    state = false(size(LampState));
    return
end

state = false(size(LampState));
for iBout = 1:numel(offStarts)
    state = state | (data.DateTime >= offStarts(iBout) & data.DateTime <= offEnds(iBout));
end

end

