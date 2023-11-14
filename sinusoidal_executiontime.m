% Generate a Sinusoidal Signal
fs = 1000;            % Sampling frequency
t = 0:1/fs:1;         % Time vector
frequency = 5;        % Frequency of the sine wave (5 Hz)
amplitude = 1;        % Amplitude of the sine wave

% Adjust the signal length to be compatible with the SWT
signal_length = 1024;  % Choose a length that is a power of 2
t = 0:(1/fs):(signal_length/fs);
sinusoidal_signal = amplitude * sin(2 * pi * frequency * t);

% Perform Discrete Wavelet Transform (DWT)
wavelet_name = 'db1'; % Daubechies 1 wavelet for demonstration
tic;
[cA, cD] = dwt(sinusoidal_signal, wavelet_name);
dwt_execution_time = toc;

% Perform Continuous Wavelet Transform (CWT)
scales = 1:64;
wavelet = 'cmor1-1.5';  % Example continuous Morlet wavelet
tic;
[CWT, frequencies] = cwt(sinusoidal_signal, scales, wavelet, 'SamplingPeriod', 1/fs);
cwt_execution_time = toc;

% Perform Stationary Wavelet Transform (SWT)
level = 4;  % Number of decomposition levels compatible with the signal length
% Extend the signal to be compatible with SWT
extended_signal_length = signal_length + 2^(level+1);
extended_signal = extend_signal(sinusoidal_signal, extended_signal_length);
tic;
[cA, cD] = swt(extended_signal, level, wavelet_name);
swt_execution_time = toc;

% Plot the Results
subplot(3, 1, 1);
plot(t, sinusoidal_signal);
title('Original Sinusoidal Signal');

subplot(3, 1, 2);
plot(cA);
title('DWT - Approximation Coefficients');

subplot(3, 1, 3);
imagesc(t, 1:extended_signal_length, abs(CWT));
title('CWT - Scalogram');
xlabel('Time (s)');
ylabel('Scale');

figure;
subplot(3, 1, 1);
plot(t, sinusoidal_signal);
title('Original Sinusoidal Signal');

subplot(3, 1, 2);
plot(cA);
title('SWT - Approximation Coefficients');

subplot(3, 1, 3);
plot(cD);
title('SWT - Detail Coefficients');

% Display Execution Times
fprintf('DWT Execution Time: %.4f seconds\n', dwt_execution_time);
fprintf('CWT Execution Time: %.4f seconds\n', cwt_execution_time);
fprintf('SWT Execution Time: %.4f seconds\n', swt_execution_time);

% Function to Extend Signal
function extended_signal = extend_signal(signal, target_length)
    extended_signal = signal;
    while length(extended_signal) < target_length
        extended_signal = [extended_signal, 0];
    end
end
