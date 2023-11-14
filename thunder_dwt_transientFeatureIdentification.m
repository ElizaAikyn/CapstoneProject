% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Ensure 'y' is a column vector
y = y(:);

% Define DWT parameters
waveletName = 'db4';   % Wavelet name (choose an appropriate wavelet)
level = 5;             % Decomposition level

% Perform DWT decomposition
[c, l] = wavedec(y, level, waveletName);

% Set a threshold for identifying transient features
threshold = 0.2; % Adjust the threshold as needed

% Initialize cell arrays to store transient feature information
transientFramesCell = cell(1, level);
transientTimesCell = cell(1, level);

% Identify transient features based on DWT coefficients and threshold
for k = 1:level
    detailCoeff = detcoef(c, l, k);
    
    % Identify transient frames based on the threshold
    transientFramesLevel = find(abs(detailCoeff) > threshold * max(abs(detailCoeff)));
    
    % Convert frames to corresponding time instances
    transientTimesLevel = transientFramesLevel / fs;
    
    % Store transient feature information in cell arrays
    transientFramesCell{k} = transientFramesLevel;
    transientTimesCell{k} = transientTimesLevel;
end

% Combine the transient frames and times from different scales
transientFrames = vertcat(transientFramesCell{:});
transientTimes = vertcat(transientTimesCell{:});

% Plot the original audio signal and highlight the transient features
t = (0:(length(y) - 1)) / fs;
figure;
plot(t, y);
hold on;
plot(transientTimes, zeros(size(transientTimes)), 'ro', 'MarkerSize', 8);
title('Audio Signal with Transient Features');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Audio Signal', 'Transient Features');

% If you want to save the identified transient features as an audio file (optional)
% audiowrite('transient_features_audio.wav', y(transientFrames), fs);
