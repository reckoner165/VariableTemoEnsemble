function [n_t_le, t_le, fs_le] = compute_novelty_le(x_t, t, fs, win_size, hop_size)
% Compute log energy derivative novelty function.
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
% window size (in samples)
% hop_size : int
% hop size (in samples)
%
% Returns
% -------
% n_t_le : 1 x L array
% novelty function
% t_le : 1 x L array
% time points in seconds
% fs_le : float
% sample rate of novelty function

%% Turn signal into energy by squaring
e_t = x_t .^ 2;
%% Buffer input into matrix
overlap_size = win_size - hop_size;
e_mat = buffer(e_t, win_size, overlap_size);
num_windows = size(e_mat,2);

%% Windowing
win = window(@hann, win_size);
win_mat = repmat(win, 1, num_windows);
windowed_e_mat = e_mat .* win_mat;

%% Compute Log Energy Derivative 
energy_m = mean(windowed_e_mat); % mean of each column. energy_m = row_vector
log_energy_m = log(energy_m);

% log Energy Derivative
delta_t = hop_size/fs; % in seconds
log_energy_derivative = (diff(log_energy_m)) ./ delta_t; 

%% Output gathering...
n_t_le = log_energy_derivative ./ max(abs(log_energy_derivative)); %normalize
t_le = (0:num_windows-2) .* (hop_size / fs);
fs_le = fs/hop_size;
end

