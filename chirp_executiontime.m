% Generate a Chirp Signal
fs = 1000; % Sampling frequency
t = 0:1/fs:1; % Time vector
f0 = 100; % Initial frequency
f1 = 200; % Final frequency
chirp_signal = chirp(t, f0, 1, f1);

% Ensure the length of the signal is compatible with the level of decomposition
level = 4;
desired_length = 2^level * ceil(length(chirp_signal) / 2^level);
if length(chirp_signal) < desired_length
    chirp_signal = [chirp_signal, zeros(1, desired_length - length(chirp_signal))];
end

% Measure Execution Time for DWT
tic;
[cA, cD] = dwt(chirp_signal, 'db1');
dwt_execution_time = toc;

% Measure Execution Time for CWT
scales = 1:64;
wavelet = 'cmor1-1.5';
tic;
[CWT, ~] = cwt(chirp_signal, scales, wavelet, 'SamplingPeriod', 1/fs);
cwt_execution_time = toc;

% Measure Execution Time for SWT
tic;
[~, cD_swt] = swt(chirp_signal, level, 'db1');
swt_execution_time = toc;

% Display Execution Times
disp('Execution Time for DWT (seconds):');
disp(dwt_execution_time);

disp('Execution Time for CWT (seconds):');
disp(cwt_execution_time);

disp('Execution Time for SWT (seconds):');
disp(swt_execution_time);
