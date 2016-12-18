function [ tp_tensor ] = wplp_tp_tensor(n_t_sf, t_sf, fs_sf,win_dur, hop_per_window,alpha_vec, f_basis)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% buffering
n_win_size = round(win_dur * fs_sf);
n_hop_size = round(n_win_size / hop_per_window);
[windowed_n_mat, t_mat, ~]  = frame(n_t_sf, t_sf ,fs_sf, n_win_size, n_hop_size);

% main loop
num_frame = size(t_mat,2)-1;
tp_tensor = zeros(num_frame,length(alpha_vec),length(f_basis));
for frame_n = 1:size(t_mat,2)-1
    
    tempo_plane = zeros(length(alpha_vec), length(f_basis));
    for i = 1:length(alpha_vec)
        alpha = alpha_vec(i);
        t_sec = t_mat(:,frame_n);
        t_warped = warp(t_sec, fs_sf, alpha);
        n_sf_frame = windowed_n_mat(:,frame_n);
        n_warped = interp1(t_sec, n_sf_frame, t_warped, 'spline');
        [N_warped, ~] = plp(n_warped, fs_sf, f_basis);
        tempo_plane(i,:) = abs(N_warped);      
    end
    tp_tensor(frame_n,:,:) = tempo_plane;
end

end

