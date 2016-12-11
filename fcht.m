function [fchtt] = fcht( )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Break audio into windows
% For each window:
    % Apply window function
    % For each alpha value
        %   Warp the window time series
        %   Apply FFT
%     Get a matrix of all FFTs for all alphas IN THAT WINDOW
% Get a 3D matrix of all FFTs for all alphas for every window
% Fin.

% DEBUG

[x_t, fs] = audioread('BeatlesHelpMono.wav');
win = 1024;
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

% t = [0:length(x_t)];

win_size = 1024;
noverlap = 512;
% x_t = [zeros(win_size-noverlap,1); x_t];

buff = buffer(x_t,win_size, noverlap,'nodelay');
numOfFrames = size(buff,2);


% Applying window to each frame
windows = ones(1,numOfFrames);

windows = winVector*windows;
buff = buff.* windows;

%% Computing FChT


t = [1:size(buff,1)];
% warp_fft = zeros(5,numOfFrames,size(buff,1));
% for alpha = 1:5
% %     warp_t = phi_inv(alpha,t);
%     for frame = 1:numOfFrames
%         for n = 1: size(buff,1)
%             buff_warp(n,frame) = buff(ceil(phi_inv(n,alpha)),frame);
% %             debug(n) = ceil(warp_t(n));
%         end
%         warp_fft(frame) = fft(buff_warp(frame));
%         x = size(warp_fft(frame));
% %         disp x;
%         fchtt(alpha,frame) = warp_fft(frame);
%     end
% %     imagesc(warp_fft);
% %     drawnow;
% end

for frame = 1:numOfFrames
    currentFrame = buff(:,frame);
    frameTime = 1:length(currentFrame);
    for alpha = 1:5
        warpTime = ceil(phi_inv(alpha,frameTime));
        warpFrame(alpha,:) = currentFrame(warpTime);
    end
    fanchirp(alpha,:,frame) = warpFrame(alpha,:);
end


%             
% 
% % Matrix multiplication
% spect = basis*buff;


    
end

