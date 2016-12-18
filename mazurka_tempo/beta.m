clear all;

win_size = 1024;
hop_size = 512;
plt = 1; % debugging option

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
% parameters:
win_dur = 3; % in sec
hop_per_window = 2; % hop_size = win_dur / hop_per_window;
alpha_vec = (-0.5:0.05:1) ./ win_dur; % alpha: percentage per second.
f_basis = (44:0.5:144)' / 60; % in hertz, basis frequencies. Can be optimized.


tp_tensor= wplp_tp_tensor(n_t_sf, t_sf, fs_sf,win_dur, hop_per_window,alpha_vec, f_basis);
[t_len,a_len,w_len] = size(tp_tensor);
value_wt = zeros(w_len,t_len);
path_wt = zeros(w_len,t_len);


[~,a_0_idx] = min(abs(alpha_vec));
t = 1;
tp = squeeze(tp_tensor(t,:,:));
emission_prob_yt_wj = abs(tp(a_0_idx,:))';

value_wt(:,t) = log(emission_prob_yt_wj);

for t = 2:t_len % each frame
    tp = squeeze(tp_tensor(t,:,:)); 
    emission_prob_yt_wj = abs(tp(a_0_idx,:))'; % take the plp with alpha close to 0 for emission probability
    a_ij = tempo_plane2tran_prob( tp, alpha_vec, f_basis, win_dur, hop_per_window,0.3);
    value_t1_i = repmat(value_wt(:,t-1),1,w_len);
    [value_wt_row, i_hat_row] = max(value_t1_i+log(a_ij), [], 1);
    value_wt_col = value_wt_row' + log(emission_prob_yt_wj);
    value_wt(:,t) = value_wt_col;
    path_wt(:,t-1) = i_hat_row';
end
%% Plotting
path_wt(:,t_len) = 1:w_len;
[best_value,best_value_idx] = max(value_wt(:,t_len));
best_path = path_wt(best_value_idx,:);
best_w_vec = f_basis(best_path) * 60;
plot(best_w_vec,'k');



