% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Ensure 'y' is a column vector
y = y(:);

% Parameters for DWT
waveletName = 'db4'; % Wavelet to use
level = 5;           % Number of decomposition levels

% Perform the DWT decomposition
[c, l] = wavedec(y, level, waveletName);

% Calculate the threshold for denoising (universal threshold for soft thresholding)
sigma = median(abs(c))/0.6745; % Estimate of the noise standard deviation
threshold = sigma * sqrt(2 * log(length(y)));

% Apply soft thresholding to the DWT coefficients
cDenoised = wthresh(c, 's', threshold);

% Reconstruct the denoised signal
yDenoised = waverec(cDenoised, l, waveletName);

% Extract and visualize detailed representations
for i = 1:level
    a_i = appcoef(cDenoised, l, waveletName, i); % Approximation coefficient
    d_i = detcoef(cDenoised, l, i);              % Detail coefficient
    
    % Plot the approximation and detail coefficients for level i
    figure;
    subplot(2,1,1);
    plot(a_i);
    title(['Approximation Coefficients (Level ', num2str(i), ')']);
    
    subplot(2,1,2);
    plot(d_i);
    title(['Detail Coefficients (Level ', num2str(i), ')']);
    
    % You can also save the plots to files if needed
    %saveas(gcf, ['detailed_representation_level_', num2str(i), '.png']);
end

% Plot the original and denoised signals
t = 0:1/fs:(length(y) - 1) / fs;
figure;
subplot(2,1,1);
plot(t, y);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, yDenoised);
title('Denoised Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Play the original and denoised audio
sound(y, fs);
pause(length(y)/fs);
sound(yDenoised, fs);

