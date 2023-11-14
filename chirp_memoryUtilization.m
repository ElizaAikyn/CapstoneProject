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

% Perform Discrete Wavelet Transform (DWT) and measure memory utilization
mem_dwt_start = memory;
[cA, cD] = dwt(chirp_signal, 'db1');
mem_dwt_end = memory;
mem_dwt_utilization = (mem_dwt_end.MemUsedMATLAB - mem_dwt_start.MemUsedMATLAB) / 1e6; % Convert to MB

% Perform Continuous Wavelet Transform (CWT) and measure memory utilization
mem_cwt_start = memory;
[CWT, ~] = cwt(chirp_signal, scales, wavelet, 'SamplingPeriod', 1/fs);
mem_cwt_end = memory;
mem_cwt_utilization = (mem_cwt_end.MemUsedMATLAB - mem_cwt_start.MemUsedMATLAB) / 1e6; % Convert to MB

% Perform Stationary Wavelet Transform (SWT) and measure memory utilization
mem_swt_start = memory;
[~, cD_swt] = swt(chirp_signal, level, 'db1');
mem_swt_end = memory;
mem_swt_utilization = (mem_swt_end.MemUsedMATLAB - mem_swt_start.MemUsedMATLAB) / 1e6; % Convert to MB

% Display Memory Utilization
disp('Memory Utilization for DWT (MB):');
disp(mem_dwt_utilization);

disp('Memory Utilization for CWT (MB):');
disp(mem_cwt_utilization);

disp('Memory Utilization for SWT (MB):');
disp(mem_swt_utilization);
