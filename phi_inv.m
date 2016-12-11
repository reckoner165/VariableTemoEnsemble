function [ warp_t ] = phi_inv( alpha, t )

% Computes warped time series for a signal
% t = time series
% alpha = warping parameter

warp_t = -(1/alpha) + ((1+2*alpha*t).^0.5)/alpha;

end

