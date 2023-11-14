% Load the clean audio signal (replace 'clean_audio.wav' with your clean audio file)
cleanAudioFile = 'thunder.wav';
[cleanSignal, fs] = audioread(cleanAudioFile);

% Ensure 'cleanSignal' is a column vector
cleanSignal = cleanSignal(:);

% Define the noise level and type (you can adjust these values)
noiseLevel = 0.05; % Adjust the noise level as needed
noiseType = 'white'; % You can change the type of noise (e.g., 'white' or 'pink')

% Generate noise to add to the clean signal
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

% Measure the quality of the denoised signal (e.g., SNR or MSE)
snrValue = snr(cleanSignal, denoisedSignal); % Signal-to-Noise Ratio (SNR)
mseValue = mean((cleanSignal - denoisedSignal).^2); % Mean Squared Error (MSE)

% Display the quality metrics to assess noise tolerance
fprintf('SNR: %.2f dB\n', snrValue);
fprintf('MSE: %.6f\n', mseValue);

% If you want to save the denoised audio as a file (optional)
% audiowrite('denoised_audio.wav', denoisedSignal, fs);
