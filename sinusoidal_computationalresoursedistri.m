% Generate a Sinusoidal Signal
fs = 1000;            % Sampling frequency
t = 0:1/fs:1;         % Time vector
frequency = 5;        % Frequency of the sine wave (5 Hz)
amplitude = 1;        % Amplitude of the sine wave

% Adjust the signal length to be compatible with the SWT
signal_length = 1024;  % Choose a length that is a power of 2
t = 0:(1/fs):(signal_length/fs);
sinusoidal_signal = amplitude * sin(2 * pi * frequency * t);

% Initialize memory utilization variables
dwt_memory = 0;
cwt_memory = 0;
swt_memory = 0;

% Initialize execution time variables
dwt_execution_time = 0;
cwt_execution_time = 0;
swt_execution_time = 0;

% Perform Discrete Wavelet Transform (DWT)
wavelet_name = 'db1'; % Daubechies 1 wavelet for demonstration
tic;
[cA, cD] = dwt(sinusoidal_signal, wavelet_name);
dwt_execution_time = toc;
dwt_memory = memory;
dwt_memory_usage = dwt_memory.MemUsedMATLAB / 1e6; % Convert to MB

% Perform Continuous Wavelet Transform (CWT)
scales = 1:64;
wavelet = 'cmor1-1.5';  % Example continuous Morlet wavelet
tic;
[CWT, frequencies] = cwt(sinusoidal_signal, scales, wavelet, 'SamplingPeriod', 1/fs);
cwt_execution_time = toc;
cwt_memory = memory;
cwt_memory_usage = cwt_memory.MemUsedMATLAB / 1e6; % Convert to MB

% Perform Stationary Wavelet Transform (SWT)
level = 4;  % Number of decomposition levels compatible with the signal length
% Extend the signal to be compatible with SWT
extended_signal_length = signal_length + 2^(level+1);
extended_signal = extend_signal(sinusoidal_signal, extended_signal_length);
tic;
[cA, cD] = swt(extended_signal, level, wavelet_name);
swt_execution_time = toc;
swt_memory = memory;
swt_memory_usage = swt_memory.MemUsedMATLAB / 1e6; % Convert to MB

% Compute total execution time and memory usage
total_execution_time = dwt_execution_time + cwt_execution_time + swt_execution_time;
total_memory_usage = dwt_memory_usage + cwt_memory_usage + swt_memory_usage;

% Compute resource distribution percentages
dwt_time_percentage = (dwt_execution_time / total_execution_time) * 100;
cwt_time_percentage = (cwt_execution_time / total_execution_time) * 100;
swt_time_percentage = (swt_execution_time / total_execution_time) * 100;

dwt_memory_percentage = (dwt_memory_usage / total_memory_usage) * 100;
cwt_memory_percentage = (cwt_memory_usage / total_memory_usage) * 100;
swt_memory_percentage = (swt_memory_usage / total_memory_usage) * 100;

% Display Execution Times and Memory Utilization
fprintf('DWT Execution Time: %.4f seconds (%.2f%% of total time)\n', dwt_execution_time, dwt_time_percentage);
fprintf('DWT Memory Usage: %.2f MB (%.2f%% of total memory)\n', dwt_memory_usage, dwt_memory_percentage);

fprintf('CWT Execution Time: %.4f seconds (%.2f%% of total time)\n', cwt_execution_time, cwt_time_percentage);
fprintf('CWT Memory Usage: %.2f MB (%.2f%% of total memory)\n', cwt_memory_usage, cwt_memory_percentage);

fprintf('SWT Execution Time: %.4f seconds (%.2f%% of total time)\n', swt_execution_time, swt_time_percentage);
fprintf('SWT Memory Usage: %.2f MB (%.2f%% of total memory)\n', swt_memory_usage, swt_memory_percentage);

% Function to Extend Signal (unchanged)
function extended_signal = extend_signal(signal, target_length)
    extended_signal = signal;
    while length(extended_signal) < target_length
        extended_signal = [extended_signal, 0];
    end
end
