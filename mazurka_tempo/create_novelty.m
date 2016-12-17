function [y , t_y, fs_nc] = create_novelty(~, ~, fs, ~, hop_size);
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%

tempo_vec_struct = load('demo_tempo_vec.mat');
tempo_vec = tempo_vec_struct.tempo_vec;


tempo_vec = tempo_vec(2:60);
num_seg = length(tempo_vec);


seg_dur = 1.5;
fs_nc = fs/hop_size;
seg_len = ceil(seg_dur*fs_nc);

T = (1:seg_len) ./ fs_nc;

y_mat = zeros(seg_len, num_seg - 1);
for seg = 1:num_seg - 1
    y_seg = chirp(T,tempo_vec(seg)/60 , 1 , tempo_vec(seg+1)/60 );
    y_mat(:,seg) = y_seg;
end

win_mat = sparse( diag( window( @hann, seg_len ) ) );
y_mat_windowed = win_mat * y_mat;

y = unframe(y_mat_windowed,round(seg_len/2));
t_y = (1:length(y)) / fs_nc;
end