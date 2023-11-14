% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Ensure 'y' is a column vector
y = y(:);

% Parameters for CWT
waveletName = 'morl'; % Wavelet to use (Morlet wavelet is commonly used for CWT)
scales = 1:128; % Define the range of scales for the CWT

% Perform CWT
cwtCoeffs = cwt(y, scales, waveletName);

% Plot the CWT coefficients
t = 0:1/fs:(length(y) - 1) / fs;
figure;
imagesc(t, scales, abs(cwtCoeffs));
colormap('jet');
axis xy; % Flip the y-axis to have low frequencies at the bottom
xlabel('Time (s)');
ylabel('Scale');
title('Continuous Wavelet Transform');
colorbar;
