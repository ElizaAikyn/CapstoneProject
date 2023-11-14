% Generate a Chirp Signal
fs = 1000; % Sampling frequency
t = 0:1/fs:1; % Time vector
f0 = 100; % Initial frequency
f1 = 200; % Final frequency
chirp_signal = chirp(t, f0, 1, f1);

% Define parameters for CWT
scales_cwt = 1:64;
wavelet_cwt = 'cmor1-1.5';

% Define parameters for SWT
level_swt = 4; % Number of decomposition levels compatible with the signal length
wavelet_name_swt = 'db1';

% Perform Discrete Wavelet Transform (DWT)
wavelet_name_dwt = 'db1'; % Daubechies 1 wavelet for demonstration
[cA, cD] = dwt(chirp_signal, wavelet_name_dwt);

% Perform Continuous Wavelet Transform (CWT)
tic;
[CWT, frequencies] = cwt(chirp_signal, scales_cwt, wavelet_cwt, 'SamplingPeriod', 1/fs);
cwt_execution_time = toc;

% Perform Stationary Wavelet Transform (SWT)
% Extend the signal to be compatible with SWT
extended_signal_length = 2^level_swt * ceil(length(chirp_signal) / 2^level_swt);
extended_signal = chirp_signal;
if length(chirp_signal) < extended_signal_length
    extended_signal = [extended_signal, zeros(1, extended_signal_length - length(chirp_signal))];
end

tic;
[~, cD_swt] = swt(extended_signal, level_swt, wavelet_name_swt);
swt_execution_time = toc;

% Compute time-frequency resolution
dwt_time_frequency_resolution = length(chirp_signal) / fs;
cwt_time_frequency_resolution = cwt_execution_time / length(frequencies);
swt_time_frequency_resolution = swt_execution_time / length(cD_swt);

% Display time-frequency resolution
fprintf('DWT Time-Frequency Resolution: %.4f seconds\n', dwt_time_frequency_resolution);
fprintf('CWT Time-Frequency Resolution: %.4f seconds\n', cwt_time_frequency_resolution);
fprintf('SWT Time-Frequency Resolution: %.4f seconds\n', swt_time_frequency_resolution);
