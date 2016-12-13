win_size = 1024;
hop_size = 512;
plt = 0; % debugging option

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
win_dur = 3; % in sec
n_win_size = round(win_dur * fs_sf);
n_hop_size = round(n_win_size / 2);
[windowed_n_mat, t_mat, f_rate]  = frame(n_t_sf, t_sf ,fs_sf, n_win_size, n_hop_size);

for col = 1:size(t_mat,2)-1
    alpha_vec = -0.99:0.1:3;
    tempo_plane = zeros(length(alpha_vec), size(t_mat, 1));
    best_kernel_mat = tempo_plane;
    for i = 1:length(alpha_vec)
        alpha = alpha_vec(i);
        t_sec = t_mat(:,col);
        t_warped = warp(t_sec, fs_sf, alpha*f_rate);
        if plt == 1 % debugging option
            figure(1)
            plot(t_warped);
            disp(alpha);
            pause(0.1);
        end
        n_sf_frame = windowed_n_mat(:,col);
        n_warped = interp1(t_sec, n_sf_frame, t_warped, 'spline');
        [N_mag_warped, best_kernel_warped] = plp(n_warped, fs_sf); % replace with PLP
        tempo_plane(i,:) = abs(N_mag_warped(1:length(n_warped)));
        best_kernel_recovered = interp1(t_warped, best_kernel_warped, t_sec, 'spline');
        best_kernel_mat(i, :) = best_kernel_recovered;
    end
    imagesc(tempo_plane);
    disp(col);
    pause(0.05);
end



