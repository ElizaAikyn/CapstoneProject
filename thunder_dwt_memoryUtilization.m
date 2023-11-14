% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Ensure 'y' is a column vector
y = y(:);

% Parameters for DWT
waveletName = 'db4'; % Wavelet to use
level = 5;           % Number of decomposition levels

% Start measuring memory utilization
preDWTMemory = whos;

% Perform the DWT decomposition
[c, l] = wavedec(y, level, waveletName);

% Stop measuring memory utilization
postDWTMemory = whos;

% Calculate the threshold for denoising (universal threshold for soft thresholding)
sigma = median(abs(c))/0.6745; % Estimate of the noise standard deviation
threshold = sigma * sqrt(2 * log(length(y)));

% Apply soft thresholding to the DWT coefficients
cDenoised = wthresh(c, 's', threshold);

% Reconstruct the denoised signal
yDenoised = waverec(cDenoised, l, waveletName);

% Display memory utilization before and after the DWT operation
fprintf('Memory utilization before DWT: %.2f MB\n', sum([preDWTMemory.bytes]) / 1e6);
fprintf('Memory utilization after DWT: %.2f MB\n', sum([postDWTMemory.bytes]) / 1e6);

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

% Save the denoised audio to a file
audiowrite('denoised_audio.wav', yDenoised, fs);
