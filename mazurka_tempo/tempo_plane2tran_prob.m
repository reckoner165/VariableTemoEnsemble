function [ a_ij ] = tempo_plane2tran_prob( tempo_plane, alpha_vec, f_basis, window_dur, hop_per_window, alpha_adj)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin < 6
    alpha_adj = 0.9;
end

[~,width] = size(tempo_plane);
a_ij = zeros(width);
for w_idx = 1:width
    wj_prob = tempo_plane(:,w_idx);
    t = window_dur / hop_per_window;
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

