% Generate a Gaussian noise signal
n = 2^16;  % Signal length
noise = randn(n, 1);

% Parameters
nLevels = 5;  % Number of decomposition levels for DWT and SWT
waveletName = 'db4';  % Wavelet for DWT and SWT
scales = 1:128;  % Scales for CWT

% Perform DWT
[cDWT, lDWT] = wavedec(noise, nLevels, waveletName);

% Perform CWT
cCWT = cwt(noise, scales, 'morl');

% Perform SWT
swc = swt(noise, nLevels, waveletName);

% Add noise to the signal
SNR_dB = 10;  % Signal-to-Noise Ratio in dB
signal = awgn(noise, SNR_dB, 'measured');

% Perform DWT on the noisy signal
[cDWT_noisy, lDWT_noisy] = wavedec(signal, nLevels, waveletName);

% Perform CWT on the noisy signal
cCWT_noisy = cwt(signal, scales, 'morl');

% Perform SWT on the noisy signal
swc_noisy = swt(signal, nLevels, waveletName);

% Calculate SNR, MSE, and PSNR for each transform
snrDWT = snr(noise, noise - signal);
mseDWT = mse(noise - signal);
psnrDWT = psnr(noise, noise - signal);

snrCWT = snr(abs(cCWT).^2, abs(cCWT_noisy).^2);
mseCWT = mse(abs(cCWT).^2 - abs(cCWT_noisy).^2);
psnrCWT = psnr(abs(cCWT).^2, abs(cCWT_noisy).^2);

snrSWT = snr(swc.^2, swc_noisy.^2);
mseSWT = mse(swc.^2 - swc_noisy.^2);
psnrSWT = psnr(swc.^2, swc_noisy.^2);

% Display results
fprintf('DWT SNR: %.2f dB\n', snrDWT);
fprintf('DWT MSE: %.4f\n', mseDWT);
fprintf('DWT PSNR: %.2f dB\n', psnrDWT);

fprintf('CWT SNR: %.2f dB\n', snrCWT);
fprintf('CWT MSE: %.4f\n', mseCWT);
fprintf('CWT PSNR: %.2f dB\n', psnrCWT);

fprintf('SWT SNR: %.2f dB\n', snrSWT);
fprintf('SWT MSE: %.4f\n', mseSWT);
fprintf('SWT PSNR: %.2f dB\n', psnrSWT);
