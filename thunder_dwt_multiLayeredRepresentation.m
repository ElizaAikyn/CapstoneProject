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

% Plot the original audio signal
t = (0:(length(y) - 1)) / fs;
figure;
subplot(level + 1, 1, 1);
plot(t, y);
title('Original Audio Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the DWT coefficients at different scales
for k = 1:level
    detailCoeff = detcoef(c, l, k);
    t = (0:(length(detailCoeff) - 1)) / fs;
    subplot(level + 1, 1, k + 1);
    plot(t, detailCoeff);
    title(['DWT Coefficients (Scale ', num2str(k), ')']);
    xlabel('Time (s)');
    ylabel('Amplitude');
end

% Adjust subplot layout
sgtitle('Multi-Layered Representation with DWT');

% If you want to save the plots (optional)
% saveas(gcf, 'multi_layered_representation.png');
