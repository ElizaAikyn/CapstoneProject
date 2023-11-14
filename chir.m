% Generate a Chirp Signal
fs = 1000; % Sampling frequency
t = 0:1/fs:1; % Time vector
f0 = 100; % Initial frequency
f1 = 200; % Final frequency
chirp_signal = chirp(t, f0, 1, f1);

% Define parameters for the analysis
level = 4;
scales = 1:64;
wavelet = 'cmor1-1.5';

% Ensure the length of the signal is compatible with the level of decomposition
desired_length = 2^level * ceil(length(chirp_signal) / 2^level);
if length(chirp_signal) < desired_length
    chirp_signal = [chirp_signal, zeros(1, desired_length - length(chirp_signal))];
end

% Perform Discrete Wavelet Transform (DWT)
[cA, cD] = dwt(chirp_signal, 'db1');

% Perform Continuous Wavelet Transform (CWT)
[CWT, ~] = cwt(chirp_signal, scales, wavelet, 'SamplingPeriod', 1/fs);

% Perform Stationary Wavelet Transform (SWT)
[~, cD_swt] = swt(chirp_signal, level, 'db1');

% Create time-frequency plots
t_dwt = 0:1/fs:(length(cA)-1)/fs;
t_cwt = 0:1/fs:(length(CWT)-1)/fs;
t_swt = 0:1/fs:(length(cD_swt)-1)/fs;

figure;

subplot(3, 1, 1);
imagesc(t_dwt, 1:2, abs([cA; cD]));
colormap(jet);
title('DWT - Scalogram');
xlabel('Time (s)');
ylabel('Scale');

subplot(3, 1, 2);
imagesc(t_cwt, scales, abs(CWT));
colormap(jet);
title('CWT - Scalogram');
xlabel('Time (s)');
ylabel('Scale');

subplot(3, 1, 3);
imagesc(t_swt, 1:level, abs(cD_swt));
colormap(jet);
title('SWT - Scalogram');
xlabel('Time (s)');
ylabel('Scale');
