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

% Define a conversion factor (e.g., dB to linear scaling)
conversionFactor = 10^(1/20); % Convert from dB to linear scale

% Apply unit conversion standardization
standardizedSignal = zScoreStandardized * conversionFactor;

% Define a scaling factor (if needed)
scalingFactor = 2.0;

% Apply the scaling factor
standardizedSignal = standardizedSignal * scalingFactor;

% Plot the original, Z-score standardized, and unit-converted standardized signals
t = 0:1/fs:(length(y) - 1) / fs;
figure;
subplot(3,1,1);
plot(t, y);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude (Original Units)');

subplot(3,1,2);
plot(t, zScoreStandardized);
title('Z-Score Standardized Signal');
xlabel('Time (s)');
ylabel('Z-Score Value');

subplot(3,1,3);
plot(t, standardizedSignal);
title('Unit-Converted Standardized Signal');
xlabel('Time (s)');
ylabel('Amplitude (Converted Units)');

% Play the original audio, Z-score standardized audio, and the unit-converted standardized audio (optional)
sound(y, fs);
pause(length(y)/fs);
sound(zScoreStandardized, fs);
pause(length(y)/fs);
sound(standardizedSignal, fs);

% If you want to save the unit-converted standardized signal as an audio file (optional)
% audiowrite('unit_converted_standardized_audio.wav', standardizedSignal, fs);
