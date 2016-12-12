%% Later to be function inputs
fs = 500;
dur = 3;
w1 = 2; % used to be alpha
w2 = -0.5; % weight for higher order terms


t_sec = 0:1/fs:dur;
%% getting the phi function
fr_vec = 1 + w1 * t_sec + w2 * t_sec .^ 2; % can be more complex...
phase_t_vec = cumsum(fr_vec) / fs;

chirp = sin(2*pi*phase_t_vec);
%% Inverting phase_vec numerically
t_phase_sec = resample(t_sec, phase_t_vec); % inverse by resampling, switching x and y.

%% later to be function outputs
warping_vec = t_phase_sec * fs;
unwarping_vec = phase_t_vec * fs / (2*pi);


