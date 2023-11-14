% Generate a clean signal
n = 2^16;  % Signal length
cleanSignal = randn(n, 1);

% Parameters
nLevels = 5;  % Number of decomposition levels for DWT and SWT
waveletName = 'db4';  % Wavelet for DWT and SWT
scales = 1:128;  % Scales for CWT

% Add noise to the clean signal at various SNR levels
SNR_levels = [-10, 0, 10];  % SNR levels to test
results = struct('SNR', [], 'MSE', [], 'PSNR', []);

for snr_db = SNR_levels
    % Add noise to the signal
    noisySignal = awgn(cleanSignal, snr_db, 'measured');

    % Perform DWT on the noisy signal
    [cDWT_noisy, ~] = wavedec(noisySignal, nLevels, waveletName);

    % Perform CWT on the noisy signal
    cCWT_noisy = cwt(noisySignal, scales, 'morl');

    % Perform SWT on the noisy signal
    swc_noisy = swt(noisySignal, nLevels, waveletName);

    % Calculate SNR, MSE, and PSNR for each transform
    snrDWT = snr(cleanSignal, cleanSignal - noisySignal);
    mseDWT = mse(cleanSignal - noisySignal);
    psnrDWT = psnr(cleanSignal, cleanSignal - noisySignal);

    snrCWT = snr(abs(cCWT).^2, abs(cCWT_noisy).^2);
    mseCWT = mse(abs(cCWT).^2 - abs(cCWT_noisy).^2);
    psnrCWT = psnr(abs(cCWT).^2, abs(cCWT_noisy).^2);

    snrSWT = snr(swc.^2, swc_noisy.^2);
    mseSWT = mse(swc.^2 - swc_noisy.^2);
    psnrSWT = psnr(swc.^2, swc_noisy.^2);

    results(end+1).SNR = struct('DWT', snrDWT, 'CWT', snrCWT, 'SWT', snrSWT);
    results(end).MSE = struct('DWT', mseDWT, 'CWT', mseCWT, 'SWT', mseSWT);
    results(end).PSNR = struct('DWT', psnrDWT, 'CWT', psnrCWT, 'SWT', psnrSWT);
end

% Display results for each SNR level
for i = 1:numel(results)
    fprintf('SNR Level: %d dB\n', SNR_levels(i));
    fprintf('DWT SNR: %.2f dB\n', results(i).SNR.DWT);
    fprintf('DWT MSE: %.4f\n', results(i).MSE.DWT);
    fprintf('DWT PSNR: %.2f dB\n', results(i).PSNR.DWT);
    fprintf('CWT SNR: %.2f dB\n', results(i).SNR.CWT);
    fprintf('CWT MSE: %.4f\n', results(i).MSE.CWT);
    fprintf('CWT PSNR: %.2f dB\n', results(i).PSNR.CWT);
    fprintf('SWT SNR: %.2f dB\n', results(i).SNR.SWT);
    fprintf('SWT MSE: %.4f\n', results(i).MSE.SWT);
    fprintf('SWT PSNR: %.2f dB\n', results(i).PSNR.SWT);
end
