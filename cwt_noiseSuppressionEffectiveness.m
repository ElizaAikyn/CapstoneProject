% Load the clean audio signal (replace 'clean_audio.wav' with your clean audio file)
cleanAudioFile = 'thunder.wav';
[cleanSignal, fs] = audioread(cleanAudioFile);

% Ensure 'cleanSignal' is a column vector
cleanSignal = cleanSignal(:);

% Parameters for CWT
waveletName = 'morl'; % Wavelet to use (Morlet wavelet is commonly used for CWT)
scales = 1:128; % Define the range of scales for the CWT

% Add noise to the clean signal to simulate a noisy environment
noiseLevel = 0.05; % Adjust the noise level as needed
noisySignal = cleanSignal + noiseLevel * randn(length(cleanSignal), 1);

% Perform CWT on the noisy signal
noisyCWT = cwt(noisySignal, scales, waveletName);

% Visualize the CWT coefficients of the noisy signal
t = 0:1/fs:(length(cleanSignal) - 1) / fs;
figure;
imagesc(t, scales, abs(noisyCWT));
colormap('jet');
axis xy; % Flip the y-axis to have low frequencies at the bottom
xlabel('Time (s)');
ylabel('Scale');
title('Noisy CWT Coefficients');
colorbar;

% Calculate the threshold for denoising (e.g., universal threshold for soft thresholding)
sigma = median(abs(noisyCWT(:)))/0.6745; % Estimate of the noise standard deviation
threshold = sigma * sqrt(2 * log(length(noisySignal)));

% Apply soft thresholding to the CWT coefficients
denoisedCWT = wthresh(noisyCWT, 's', threshold);

% Reconstruct the denoised signal
denoisedSignal = icwt(denoisedCWT, scales, waveletName);

% Measure the quality of the denoised signal (e.g., SNR or MSE)
snrValue = snr(cleanSignal, denoisedSignal); % Signal-to-Noise Ratio (SNR)
mseValue = mean((cleanSignal - denoisedSignal).^2); % Mean Squared Error (MSE)

% Display the quality metrics to assess noise suppression effectiveness
fprintf('SNR: %.2f dB\n', snrValue);
fprintf('MSE: %.6f\n', mseValue);

% Visualize the denoised signal and compare it to the clean signal
figure;
subplot(3, 1, 1);
plot(t, cleanSignal);
title('Clean Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 2);
plot(t, noisySignal);
title('Noisy Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 3);
plot(t, denoisedSignal);
title('Denoised Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% If you want to save the denoised audio as a file (optional)
% audiowrite('denoised_audio.wav', denoisedSignal, fs);
