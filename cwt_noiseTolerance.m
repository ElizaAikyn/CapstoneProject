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

% Add noise directly to the CWT coefficients
noiseLevel = 0.1; % Adjust the noise level as needed
noisyCWT = cwtCoeffs + noiseLevel * randn(size(cwtCoeffs));

% Visualize the noisy CWT coefficients
t = 0:1/fs:(length(y) - 1) / fs;
figure;
imagesc(t, scales, abs(noisyCWT));
colormap('jet');
axis xy; % Flip the y-axis to have low frequencies at the bottom
xlabel('Time (s)');
ylabel('Scale');
title('Noise Tolerance with Direct Noise Addition');
colorbar;

% Play the original audio
sound(y, fs);
pause(length(y)/fs);
