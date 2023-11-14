% Load the audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[noisySignal, fs] = audioread(audioFile);

% Ensure 'noisySignal' is a column vector
noisySignal = noisySignal(:);

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

% Calculate the Signal-to-Noise Ratio (SNR) for the noisy and denoised signals
snrNoisy = snr(noisySignal);
snrDenoised = snr(denoisedSignal);

% Display the SNR values to evaluate noise suppression effectiveness
fprintf('SNR of Noisy Signal: %.2f dB\n', snrNoisy);
fprintf('SNR of Denoised Signal: %.2f dB\n', snrDenoised);

% If you want to save the denoised audio as a file (optional)
% audiowrite('denoised_audio.wav', denoisedSignal, fs);
