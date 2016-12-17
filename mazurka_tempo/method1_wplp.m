function [gamma_t] = method1_wplp( n_t_sf, t_sf, fs_sf,win_dur, hop_per_window,alpha_vec, f_basis, plt)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% buffering
n_win_size = round(win_dur * fs_sf);
n_hop_size = round(n_win_size / hop_per_window);
[windowed_n_mat, t_mat, ~]  = frame(n_t_sf, t_sf ,fs_sf, n_win_size, n_hop_size);

% main loop
gamma_mat = zeros(size(windowed_n_mat));
for frame_n = 1:size(t_mat,2)-1
    
    best_kernel_mat = zeros(length(alpha_vec), size(t_mat, 1));
    tempo_plane = zeros(length(alpha_vec), length(f_basis));
    
    for i = 1:length(alpha_vec)
        alpha = alpha_vec(i);
        t_sec = t_mat(:,frame_n);
        t_warped = warp(t_sec, fs_sf, alpha);
        n_sf_frame = windowed_n_mat(:,frame_n);
        n_warped = interp1(t_sec, n_sf_frame, t_warped, 'spline');
        [N_warped, best_kernel_warped] = plp(n_warped, fs_sf, f_basis);
        tempo_plane(i,:) = abs(N_warped);
        % unwarping the kernel
        t_warped_0offset = t_warped - t_warped(1);
        t_sec_0offset = t_sec - t_sec(1);
        best_kernel_recovered = interp1(t_warped_0offset, best_kernel_warped, t_sec_0offset, 'spline');
        best_kernel_mat(i, :) = best_kernel_recovered;       
    end
    
    if plt == 1 % debug option
        figure(2)
        imagesc(tempo_plane);
%         figure(3)
%         imagesc(best_kernel_mat);
        disp(frame_n);
        pause(0.05);
    end
    % pick the best alpha
    alpha_score = sum(tempo_plane,2);
    [~, best_a_idx] = max(alpha_score);
    % collect the best overall ker
    best_overall_kernel_col = best_kernel_mat(best_a_idx, :)'; % slice out the best row, and transpose
    gamma_mat(:,frame_n) = best_overall_kernel_col;
end
% unframe:
gamma_t = unframe(gamma_mat, n_hop_size);
%output gamma_t; tempo_plane_t
end

