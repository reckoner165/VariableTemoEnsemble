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
alpha_vec = -0.99:0.1:3;
f_basis = (30:0.5:250)' / 60; % in hertz, basis frequencies. Can be optimized.

% buffering
win_dur = 3; % in sec
n_win_size = round(win_dur * fs_sf);
n_hop_size = round(n_win_size / 2);
[windowed_n_mat, t_mat, frame_rate]  = frame(n_t_sf, t_sf ,fs_sf, n_win_size, n_hop_size);


% main loop
gamma_mat = zeros(size(windowed_n_mat));
for col = 1:size(t_mat,2)-1
    
    best_kernel_mat = zeros(length(alpha_vec), size(t_mat, 1));
    tempo_plane = zeros(length(alpha_vec), length(f_basis));
    
    for i = 1:length(alpha_vec)
        alpha = alpha_vec(i) / win_dur; % make sure negative tempo dont exist
        t_sec = t_mat(:,col);
        t_warped = warp(t_sec, fs_sf, alpha);
        n_sf_frame = windowed_n_mat(:,col);
        n_warped = interp1(t_sec, n_sf_frame, t_warped, 'spline');
        [N_warped, best_kernel_warped] = plp(n_warped, fs_sf, f_basis);
        tempo_plane(i,:) = abs(N_warped);
        % unwarping the kernel
        t_warped_0offset = t_warped - t_warped(1);
        t_sec_0offset = t_sec - t_sec(1);
        best_kernel_recovered = interp1(t_warped_0offset, best_kernel_warped, t_sec_0offset, 'spline');
        best_kernel_mat(i, :) = best_kernel_recovered;
       
    end
    plt = 0;
    if plt == 1 % debug option
        figure(2)
        imagesc(tempo_plane);
%         figure(3)
%         imagesc(best_kernel_mat);
        disp(col);
        pause(0.05);
    end
    % pick the best alpha
    alpha_score = sum(tempo_plane,2);
    [best_alpha, best_a_idx] = max(alpha_score);
    % collect the best overall ker
    best_overall_kernel_col = best_kernel_mat(best_a_idx, :)'; % slice out the best row, and transpose
    gamma_mat(:,col) = best_overall_kernel_col;
    
    S(col,:) = alpha_score;
    P(col
    Y(col,:) = squeeze(tempo_plane(find(not(alpha_vec)),:));
    all_best_alpha(col) = best_alpha;
end

% unframe:
gamma_t = unframe(gamma_mat, n_hop_size);




%%

% viterbi

% subplot(2,1,1), imagesc(log(Y')), colorbar; title('Y matrix')
% hold on;
% plot(all_best_alpha,'.r');
% subplot(2,1,2), imagesc(S'),colorbar; title('S matrix')

% Initial pi(alpha) is a uniform/random distribution to start with
PI_alpha = ones(length(alpha_vec),1);
% Uniform transition matrix ***FOR NOW***
trans = ones(length(alpha_vec)); 

% Need to compute all state probabilities

figure(1)
plot(gamma_t);
hold on;
plot(n_t_sf);
hold off;





