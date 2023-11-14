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

% Calculate the mean and standard deviation of the CWT coefficients
cwtMean = mean(cwtCoeffs, 2);
cwtStd = std(cwtCoeffs, 0, 2);

% Z-score standardization
cwtZScore = (cwtCoeffs - cwtMean) ./ cwtStd;

% Visualize the Z-score standardized CWT coefficients
t = 0:1/fs:(length(y) - 1) / fs;
figure;
imagesc(t, scales, abs(cwtZScore));
colormap('jet');
axis xy; % Flip the y-axis to have low frequencies at the bottom
xlabel('Time (s)');
ylabel('Scale');
title('Z-score Standardized Continuous Wavelet Transform');
colorbar;

% Play the original audio
sound(y, fs);
pause(length(y)/fs);
