function state = DetermineState(x,varargin)
%DETERMINESTATE Determine if state of lights are on or off
%   Input 'x' is light reading signal
%   Output state is true/false, true = light is on, false = light is off
%   Optional argument in is cutoff as percentage of maximum light
%       (0 > cutoff < 1), default cutoff is 10% (0.1)

if nargin == 2
    cutoff = varargin{1};
else
    cutoff = 0.1;
end

norm = x/max(x);

state0 = norm > cutoff;
state = state0;

% state1 = circshift(state0,-1);
% state1(end) = true;
% state2 = circshift(state0,-2);
% state2(end-1:end) = true;
% state3 = circshift(state0,-3);
% state3(end-2:end) = true;
% 
% stateSum = state0 + state1;% + state2;% + state3;
% 
% state = stateSum >= 2;

end

