%% Params
fs = 500;
dur = 3;
bpm_0 = 50; % max at 500 bpm
alpha = 3; 
%% building chirp from phase
t_sec = 1/fs:1/fs:dur;
f_0 = bpm_0 / 60; % beats per seconds
f_vec =  f_0 * (1 + alpha * t_sec); % can be more complex...

phase_vec = cumsum(f_vec) / fs;
chirp = sin(2*pi*phase_vec);

figure(1)
plot(phase_vec);
hold on;
plot(max(phase_vec) * chirp); % just to normalize.
hold off;
%% Inverting phase_vec numerically
t_phase_sec = resample(t_sec, phase_vec); % inverse by resampling

warping_vec = t_phase_sec * fs;
figure(2)
plot(warping_vec);

%% resampling: warping
chirp_warped = interp1(chirp, warping_vec, 'spline');
phase_warped = interp1(phase_vec, warping_vec, 'spline');

figure(3)
plot(chirp_warped * max(phase_warped));
hold on;
plot(phase_warped);
hold off;
%% resampling: unwarping
unwarping_vec = phase_vec / max(phase_vec) * length(phase_vec);
chirp_recovered = interp1(chirp_warped, unwarping_vec, 'spline');

figure(4)
plot(chirp_recovered-chirp);

