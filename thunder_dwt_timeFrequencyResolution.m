% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Ensure 'y' is a column vector
y = y(:);

% Set parameters for the STFT
windowLength = 256;     % Length of the analysis window
overlap = windowLength / 2;  % Overlap between successive windows

% Compute the STFT
[S, F, T] = spectrogram(y', hamming(windowLength), overlap, windowLength, fs);

% Plot the time-frequency representation
figure;
imagesc(T, F, 10*log10(abs(S)));  % Convert to dB for better visualization
axis xy;
colormap('jet');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Time-Frequency Resolution (STFT)');
colorbar;

% Adjust the colormap and color range if needed
caxis([min(10*log10(abs(S(:)))), max(10*log10(abs(S(:))))]);

% Play the original audio (optional)
sound(y, fs);

% If you want to save the time-frequency representation as an image (optional)
% saveas(gcf, 'time_frequency_resolution.png');
