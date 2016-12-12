%% Params
fs = 500;
t0 = 3; t_f = 4.999;
bpm_0 = 60; % max at 500 bpm
alpha = 2; 
%% building chirp from phase. Figure 1 plots the signal
t_sec = t0:1/fs:t_f;
f_0 = bpm_0 / 60; % beats per seconds
f_vec =  f_0 * (1 + alpha * (t_sec-t0)); % can be more complex...

phase_vec = cumsum(f_vec) / fs; % in radian
chirp = sin(2*pi*phase_vec);

figure(1)
plot(phase_vec);
hold on;
plot(max(phase_vec) * chirp); % just to normalize.
hold off;
title('the original, unwapred chirp, and the phase')

%% calling the warp function, and using the output resampling time tick.
t_warped = warp(t_sec, fs, alpha);
chirp_warped = interp1(t_sec, chirp, t_warped, 'spline'); 
phase_warped = interp1(t_sec, phase_vec, t_warped, 'spline'); 

figure(2)
plot(chirp_warped * max(phase_warped));
hold on;
plot(phase_warped);
hold off;
title('warping a chirp to a constant frequency sine wave');

%% How to recover a warped signal, and noise introduced by this process.
chirp_recovered = interp1(t_warped, chirp_warped, t_sec, 'spline');
diff = chirp_recovered - chirp;
figure(3)
plot(diff);
title('diff between chirp and chirp_recovered');


