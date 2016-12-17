clear all;
%% Novelty curve creation.
% parameters for the first analysis:
win_size = 1024;
hop_size = 512;

[x_t, fs, t] = import_audio('./17_4_zbinden.wav');
[n_t_sf , t_sf, fs_sf] = compute_novelty_sf(x_t, t, fs, win_size, hop_size);
%[n_t_le, t_le, fs_le] = compute_novelty_le(x_t, t, fs, win_size, hop_size);

%% smoothing using butterworth filter and normalize
% w_c = 4;
% nyq = fs_sf / 2;
% [B,A] = butter(1, w_c/nyq);
% n_t_sf_smoothed = filtfilt(B,A,n_t_sf);
% n_t_sf_smoothed = n_t_sf_smoothed ./ (max(abs(n_t_sf_smoothed))); % normalize

%% Short term analysis on n_t_sf
% inputs: n_t_sf, t_sf, fs_sf
% parameters:
win_dur = 3; % in sec
hop_per_window = 4; % hop_size = win_dur / hop_per_window;
alpha_vec = (-0.65:0.05:2.0) ./ win_dur; % alpha: percentage per second.
f_basis = (44:1:144)' / 60; % in hertz, basis frequencies. Can be optimized.

plt = 0;
tic
gamma_t = method1_wplp( n_t_sf, t_sf, fs_sf,win_dur, hop_per_window,alpha_vec, f_basis, plt);
toc

%% Plotting...
figure(1)
t_gamma = (0:length(gamma_t)-1) / fs_sf;
plot(t_gamma,gamma_t);
hold on;
plot(t_sf,n_t_sf);
hold off;




