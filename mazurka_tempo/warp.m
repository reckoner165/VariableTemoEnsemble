function t_warped = warp(t_unwarped, fs, a1, a2)
%function t_warped = warp(t_unwarped, fs, a1, [a2 = 0])
%   Generate a warped sampling tick from a normal, equally space time
%   support t_unwarped. Warping dictated by a1 and a2 as following:
%       fr_t = 1 + a1*t + a2*(t.^2)
%       where fr_t is the time varying relative frequency, t is the
%       original unwarped time support vector.
%   Taking a2 = 0, the default value would conform to a linear chirp, the
%   original formulation of FChT. This is an extension.
%   ---USAGE---
%   x_warped = interp1(t_unwarped, x, t_warped); chirp_warped(1) = 0;
%   x_recovered = interp1(t_warped, x_warped, t_unwarped); chirp_warped(1) = 0;

if nargin < 4
    a2 = 0; % default to linear chirp
end

t_len = length(t_unwarped);
t = (0:t_len-1) / fs; % framewise tick.

%% getting the phi function
fr_t = 1 + a1 * t + a2 * t .^ 2; % can be even more complex... maybe exponential. To get the actual frequency at time t, multiply fr_t by f_k, the bin frequency of the FFT.
phase_t = cumsum(fr_t) / fs; % phase is fr integrated. 1/fs is dt.
%% Inverting phase_vec numerically
t_warped = resample(t_unwarped, phase_t); % inverse by resampling, switching x and y.
end

