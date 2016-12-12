function [n_t_sf , t_sf, fs_sf] = compute_novelty_sf(x_t, t, fs, win_size, hop_size)
% Compute spectral flux novelty function.
%
% Parameters
% ----------
% x_t : 1 x T array
% time domain signal
% t : 1 x T array
% time points in seconds
% fs : int
% sample rate of x_t (samples per second)
% win_size : int
% window_size (in samples)
% hop_size : int
% hop size (in samples)
%
% Returns
% -------
% n_t_sf : 1 x L array
% novelty function
% t_sf : 1 x L array
% time points in seconds
% fs_sf : float
% sample rate of novelty function

%% Buffer input into matrix
overlap_size = win_size - hop_size;
x_mat = buffer(x_t, win_size, overlap_size);
m = size(x_mat,2); % number of windows e_mat = k*m matrix
%% Windowing
win = window(@hann, win_size);
win_mat = repmat(win, 1, m);
windowed_x_mat = x_mat .* win_mat;
%% transform
X_mat = fft(windowed_x_mat);
X_mag_mat = abs(X_mat(1:win_size/2+1,:)); % get rid of content past nyquist
%% compute flux
diff_X_mag_mat = diff(X_mag_mat,1,2); %first difference on rows
diff_X_mag_hr = max(diff_X_mag_mat, 0); % Half wave rectification
sf_hr_m = mean(diff_X_mag_hr);
%% Output gathering...
n_t_sf = sf_hr_m ./ max(abs(sf_hr_m)); %normalize
t_sf = (0:m-2) .* (hop_size / fs);
fs_sf = fs/hop_size;
end

