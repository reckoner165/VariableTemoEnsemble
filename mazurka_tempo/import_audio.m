function [x_t, fs, t] = import_audio(filepath)
% Import an audio signal from a wave file.
%
% Parameters
% ----------
% filepath : string
% path to a .wav file
%
% Returns
% -------
% x_t : 1 x T array
% time domain signal
% t : 1 x T array
% time points in seconds
% fs : int
% sample rate (samples per second)

[x_t, fs]=audioread(filepath);
x_t = x_t(:,1)'; % get only mono and trun into 1*T
t = 0:length(x_t)-1;
t = t ./ fs;    

end

