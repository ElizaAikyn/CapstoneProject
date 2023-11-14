% Generate a Complex Waveform
fs = 1000; % Sampling frequency
t = 0:1/fs:1; % Time vector
frequencies = [20, 100, 250]; % Frequencies of the complex waveform components
amplitudes = [1.5, 0.8, 0.4]; % Amplitudes of the components

% Initialize the real and imaginary parts
real_part = zeros(size(t));
imaginary_part = zeros(size(t));

% Generate the complex waveform by summing sinusoids
for i = 1:length(frequencies)
    real_part = real_part + amplitudes(i) * cos(2 * pi * frequencies(i) * t);
    imaginary_part = imaginary_part + amplitudes(i) * sin(2 * pi * frequencies(i) * t);
}

complex_waveform = real_part + 1i * imaginary_part;

% Perform Discrete Wavelet Transform (DWT)
wavelet_name = 'db1'; % Daubechies 1 wavelet for demonstration
tic;
[cA_dwt, cD_dwt] = dwt(complex_waveform, wavelet_name);
dwt_execution_time = toc;

% Perform Continuous Wavelet Transform (CWT)
scales = 1:64;
wavelet = 'cmor1-1.5'; % Example continuous Morlet wavelet
tic;
[CWT, frequencies] = cwt(complex_waveform, scales, wavelet, 'SamplingPeriod', 1/fs);
cwt_execution_time = toc;

% Plot the Results
subplot(3, 1, 1);
plot(t, real(complex_waveform));
title('Real Part of Complex Waveform');

subplot(3, 1, 2);
imagesc(t, 1:length(scales), abs(CWT));
title('CWT - Scalogram');
xlabel('Time (s)');
ylabel('Scale');

subplot(3, 1, 3);
plot(t, abs(cA_dwt));
title('DWT - Approximation Coefficients');

% Display Execution Times
fprintf('DWT Execution Time: %.4f seconds\n', dwt_execution_time);
fprintf('CWT Execution Time: %.4f seconds\n', cwt_execution_time);
