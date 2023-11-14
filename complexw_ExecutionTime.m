% Generate a complex waveform
fs = 1000; % Sampling frequency
t = 0:1/fs:1; % Time vector
frequency = 5; % Frequency of the sine wave (5 Hz)
amplitude = 1; % Amplitude of the sine wave
phase = pi/4; % Phase of the sine wave

complex_waveform = amplitude * (cos(2 * pi * frequency * t) + 1i * sin(2 * pi * frequency * t + phase));

% Perform Discrete Wavelet Transform (DWT)
wavelet_name = 'db1'; % Daubechies 1 wavelet for demonstration

tic;
[cA_dwt, ~] = dwt(real(complex_waveform), wavelet_name);
dwt_execution_time = toc;

% Perform Continuous Wavelet Transform (CWT)
scales = 1:64;
wavelet = 'cmor1-1.5'; % Example continuous Morlet wavelet

tic;
[CWT, frequencies] = cwt(complex_waveform, scales, wavelet, 'SamplingPeriod', 1/fs);
cwt_execution_time = toc;

% Display execution times
fprintf('DWT Execution Time: %.4f seconds\n', dwt_execution_time);
fprintf('CWT Execution Time: %.4f seconds\n', cwt_execution_time);

% Plot the complex waveform, DWT, and CWT (you can add more details to the plots)
subplot(3, 1, 1);
plot(t, real(complex_waveform));
title('Real Part of Complex Waveform');

subplot(3, 1, 2);
plot(t, cA_dwt);
title('DWT - Approximation Coefficients');

subplot(3, 1, 3);
imagesc(t, 1:64, abs(CWT));
title('CWT - Scalogram');
xlabel('Time (s)');
ylabel('Scale');
colormap('jet');
colorbar;

