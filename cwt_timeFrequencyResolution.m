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

% Calculate the time-frequency resolution metric
time_resolution = 1./(scales * fs); % Time resolution for each scale
frequency_resolution = fs./scales; % Frequency resolution for each scale

% Plot the time-frequency resolution
figure;
subplot(2, 1, 1);
plot(scales, time_resolution);
title('Time Resolution vs. Scale');
xlabel('Scale');
ylabel('Time Resolution (s)');

subplot(2, 1, 2);
plot(scales, frequency_resolution);
title('Frequency Resolution vs. Scale');
xlabel('Scale');
ylabel('Frequency Resolution (Hz)');

sgtitle('Time-Frequency Resolution of CWT');

% Play the original audio
sound(y, fs);
pause(length(y)/fs);
