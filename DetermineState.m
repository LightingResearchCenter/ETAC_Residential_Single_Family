function [state,cutoff_percent,cutoff_lumPerSqFt] = DetermineState(x,varargin)
%DETERMINESTATE Determine if state of lights are on or off
%   Input 'x' is light reading signal
%   Output state is true/false, true = light is on, false = light is off
%   Optional argument in is cutoff as percentage of maximum light
%       (0 > cutoff < 1), default cutoff is 30% (0.3)

% Determine cutoff value
max_X = max(x);
if nargin == 2
    cutoff_percent = varargin{1};
else
    if max_X < 30
        cutoff_percent = 1.1;
    else
        cutoff_percent = 0.3;
    end
end
cutoff_lumPerSqFt = cutoff_percent*max_X;

% Design filter
windowSize = 10;
b = (1/windowSize)*ones(1,windowSize);
a = 1;

% Apply filter to data
y = filter(b,a,x);

% Find values above cutoff
state0 = x > cutoff_lumPerSqFt;
state1 = y > cutoff_lumPerSqFt;
state = state0 | state1;


end

