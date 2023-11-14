% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Define the desired interpolation factor
interpolationFactor = 2; % Increase the sample rate by a factor of 2

% Perform linear interpolation
y_interpolated = interp1(1:length(y), y, 1:1/interpolationFactor:length(y), 'linear');

% Adjust the sample rate
fs_interpolated = fs * interpolationFactor;

% Plot the original and interpolated signals
t_original = (0:(length(y) - 1)) / fs;
t_interpolated = (0:(length(y_interpolated) - 1)) / fs_interpolated;

figure;
subplot(2,1,1);
plot(t_original, y);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t_interpolated, y_interpolated);
title('Interpolated Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Play the original audio and the interpolated audio (optional)
sound(y, fs);
pause(length(y) / fs);
sound(y_interpolated, fs_interpolated);

% If you want to save the interpolated audio as an audio file (optional)
% audiowrite('interpolated_audio.wav', y_interpolated, fs_interpolated);
