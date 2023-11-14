% Load the clean audio signal (replace 'clean_audio.wav' with your clean audio file)
cleanAudioFile = 'thunder.wav';
[cleanSignal, fs] = audioread(cleanAudioFile);

% Ensure 'cleanSignal' is a column vector
cleanSignal = cleanSignal(:);

% Add noise to the clean signal to simulate a noisy environment
noiseLevel = 0.05; % Adjust the noise level as needed
noisySignal = cleanSignal + noiseLevel * randn(length(cleanSignal), 1);

% Perform the DWT decomposition on the noisy signal
level = 5; % You can choose the decomposition level
[noisyC, noisyL] = wavedec(noisySignal, level, 'db4');

% Calculate the threshold for denoising (e.g., universal threshold for soft thresholding)
sigma = median(abs(noisyC))/0.6745; % Estimate of the noise standard deviation
threshold = sigma * sqrt(2 * log(length(noisySignal)));

% Apply soft thresholding to the DWT coefficients
denoisedC = wthresh(noisyC, 's', threshold);

% Reconstruct the denoised signal
denoisedSignal = waverec(denoisedC, noisyL, 'db4');

% Calculate the noise component as the difference between the noisy and denoised signals
noiseComponent = noisySignal - denoisedSignal;

% Measure the quality of the denoised signal (e.g., SNR or MSE)
snrValue = snr(cleanSignal, denoisedSignal); % Signal-to-Noise Ratio (SNR)
mseValue = mean((cleanSignal - denoisedSignal).^2); % Mean Squared Error (MSE)

% Measure the noise artifacts in the denoised signal
snrNoiseArtifacts = snr(noiseComponent);

% Display the quality metrics and noise artifacts handling effectiveness
fprintf('SNR: %.2f dB\n', snrValue);
fprintf('MSE: %.6f\n', mseValue);
fprintf('SNR of Noise Artifacts: %.2f dB\n', snrNoiseArtifacts);

% If you want to save the denoised audio, noisy audio, and noise component as files (optional)
% audiowrite('denoised_audio.wav', denoisedSignal, fs);
% audiowrite('noisy_audio.wav', noisySignal, fs);
% audiowrite('noise_component.wav', noiseComponent, fs);
