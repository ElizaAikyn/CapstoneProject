% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Ensure 'y' is a column vector
y = y(:);

% Calculate the mean and standard deviation of the audio signal
meanY = mean(y);
stdY = std(y);

% Compute the Z-score standardized signal
zScoreStandardized = (y - meanY) / stdY;

% Plot the original and Z-score standardized signals
t = 0:1/fs:(length(y) - 1) / fs;
figure;
subplot(2,1,1);
plot(t, y);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, zScoreStandardized);
title('Z-Score Standardized Signal');
xlabel('Time (s)');
ylabel('Z-Score Value');

% Play the original audio and the Z-score standardized audio (optional)
sound(y, fs);
pause(length(y)/fs);
sound(zScoreStandardized, fs);

% If you want to save the Z-score standardized signal as an audio file (optional)
% audiowrite('zscore_standardized_audio.wav', zScoreStandardized, fs);
