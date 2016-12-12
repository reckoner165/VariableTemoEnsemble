function [windowed_x_mat, t_mat, f_rate] = frame(x_t, t, fs, win_size, hop_size)
%function [windowed_x_mat, t_mat, f_rate] = frame(x_t, t, fs, win_size, hop_size)
%   Detailed explanation goes here

%% Buffer input into matrix
overlap_size = win_size - hop_size;
x_mat = buffer(x_t, win_size, overlap_size, 'nodelay');
t_mat = buffer(t, win_size, overlap_size, 'nodelay');
%% Windowing
win = window(@hann, win_size);
win_mat = sparse(diag(win));
windowed_x_mat = win_mat * x_mat;
f_rate = fs / hop_size;
end

