%% PLP
fs_sf = 85;
t = (1:258)/fs_sf;
f = 2;
x_t = sin(2*pi*f*t)' + rand(258,1)*0.1; % the chuck of siganl input

%%
n_win_size = length(x_t);
f = (30:600)' / 60; % in hertz, basis frequencies. Can be parametized.
n_t = (1:n_win_size) / fs_sf;

analysis_mat = exp(-2*pi*1i*(f * n_t));

X = analysis_mat * x_t;
X_mag = abs(X);
plot(30:600,X_mag);

[~,i] = max(X_mag);
best_phase = 1/(2*pi) * acos(real(X(i))/X_mag(i));
w = (i+30-1) / 60; % the best freq.

best_kernel = cos(2*pi*(w*n_t - best_phase));

plot(t, best_kernel);
hold on;
plot(t, x_t);
hold off;