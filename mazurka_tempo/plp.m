function [ X_t, best_kernel ] = plp( x_t, fs )
%function [ X_t, best_k ] = plp( x_t, fs )
%   x_t: a input signal: 1 * t vec
%   fs: the sampling freq of x_t
%   -----OUTPUT-----
%   X_t: the frequency representation (using f as basis functions)
%       size: 1 * t
%   best_kernel: 1* t vector
%       that is a windowed sine wave that's the best representation of the perioditcity.


% %% PLP
% fs_sf = 85;
% t = (1:258)/fs_sf;
% f = 2;
% x_t = sin(2*pi*f*t)' + rand(258,1)*0.1; % the chuck of siganl input

%% get info
n_win_size = length(x_t);
f = (30:600)' / 60; % in hertz, basis frequencies. Can be parametized.
n_t = (1:n_win_size) / fs;

analysis_mat = exp(-2*pi*1i*(f * n_t));

%% output collect
X_t = analysis_mat * x_t;

X_mag = abs(X_t);

[~,i] = max(X_mag);
best_phase = 1/(2*pi) * acos(real(X_t(i))/X_mag(i)); % according to PLP paper
w = (i+30-1) / 60; % the best freq.

best_kernel = cos(2*pi*(w*n_t - best_phase)); % according to paper

window = hann(length(best_kernel));
best_kernel = window .* best_kernel';

end

