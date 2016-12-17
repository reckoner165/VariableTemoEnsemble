function [ a_ij ] = tempo_plane2tran_prob( tempo_plane, alpha_vec, f_basis, frame_dur, hop_per_window, alpha_adj)
%calculates a_ij from the tempo_plane in each frame.
%   Detailed explanation goes here

if nargin < 6
    alpha_adj = 0.9;
end

[~,width] = size(tempo_plane);
a_ij = zeros(width);
for w_idx = 1:width
    wj_prob = tempo_plane(:,w_idx);
    t = frame_dur / hop_per_window; % frame_dur in seconds. t is in seconds
    wj = f_basis(w_idx) * (1 + alpha_vec * t*alpha_adj);
    aij_row = interp1(wj,wj_prob,f_basis,'spline')'; 
    aij_row = aij_row/max(aij_row);
%         disp(max(aij));
    a_ij(w_idx,:) = aij_row;
%         plot(aij); title('Wij'); drawnow;
end

imagesc(a_ij);
drawnow;

end

