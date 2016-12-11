% Sumanth Srinivasan

function [S, F, T] = my_spectrogram(x_t, win, noverlap, nfft, fs)
% Parameters
% ----------
% x t : 1 x T array
% time domain signal

% win : int (interpreted as window size), vector (interpreted as the
% window)
% 
% noverlap : number of overlapping samples (i.e. window size - hop size)
% 
% fs : int
% sample rate (samples per second)
% nfft : int
% 
% fft length (in samples)
%
% Returns
% -------
% S - Spectrogram Matrix
% F - A vector of frequencies in Hz corresponding to each bin
% T - A vector of time in Sec corresponding to the beginning of each window



%% Preparing window function
% Default window is hamming
type = @hamming;

l = length(win);
if l == 1
    win_size = win;
    winVector = window(type,win_size);
elseif l > 1
    win_size = l;
    winVector = win;
end
    
%% Creating Buffer Matrix

% Breaking audio file into frames 

x_t = [zeros(win_size-noverlap,1); x_t];

buff = buffer(x_t,win_size, noverlap,'nodelay');
numOfFrames = size(buff,2);


% Applying window to each frame
windows = ones(1,numOfFrames);

windows = winVector*windows;
buff = buff.* windows;

%% Computing DFT

% Creating basis function matrix
basis = ones(nfft,win_size);


for k = 1:nfft
    for n = 1:win_size
        basis(k,n) = exp(-1i*2*pi*k*n/nfft);
    end
end


% Matrix multiplication
spect = basis*buff;





%% Return values

S = spect;
T = [1:win_size-noverlap:length(x_t)]/fs;
F = fs*[1:nfft]/nfft;

%% Plot the Spectrogram

imagesc(T,F(1:nfft/2),(mag2db(abs(spect(1:nfft/2,:)))));
set(gca,'YDir','normal')
xlabel('Time (sec)')
ylabel('Frequency (Hz)')
colorbar;
end

