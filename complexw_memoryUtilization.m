% Generate a complex waveform
fs = 1000; % Sampling frequency
t = 0:1/fs:1; % Time vector
frequency = 5; % Frequency of the sine wave (5 Hz)
amplitude = 1; % Amplitude of the sine wave
phase = pi/4; % Phase of the sine wave

complex_waveform = amplitude * (cos(2 * pi * frequency * t) + 1i * sin(2 * pi * frequency * t + phase));

% Perform Discrete Wavelet Transform (DWT)
wavelet_name = 'db1'; % Daubechies 1 wavelet for demonstration

dwt_memory_start = memory; % Record initial memory usage
tic;
[cA_dwt, ~] = dwt(real(complex_waveform), wavelet_name);
dwt_execution_time = toc;
dwt_memory_end = memory; % Record memory usage after DWT

% Perform Continuous Wavelet Transform (CWT)
scales = 1:64;
wavelet = 'cmor1-1.5'; % Example continuous Morlet wavelet

cwt_memory_start = memory; % Record initial memory usage
tic;
[CWT, frequencies] = cwt(complex_waveform, scales, wavelet, 'SamplingPeriod', 1/fs);
cwt_execution_time = toc;
cwt_memory_end = memory; % Record memory usage after CWT

% Calculate memory usage in MB
dwt_memory_usage = (dwt_memory_end.MemUsedMATLAB - dwt_memory_start.MemUsedMATLAB) / 1e6;
cwt_memory_usage = (cwt_memory_end.MemUsedMATLAB - cwt_memory_start.MemUsedMATLAB) / 1e6;

% Display execution times and memory usage
fprintf('DWT Execution Time: %.4f seconds\n', dwt_execution_time);
fprintf('DWT Memory Usage: %.2f MB\n', dwt_memory_usage);

fprintf('CWT Execution Time: %.4f seconds\n', cwt_execution_time);
fprintf('CWT Memory Usage: %.2f MB\n', cwt_memory_usage);
