% Generate a Sinusoidal Signal
fs = 1000;
t = 0:1/fs:1;
frequency = 5;
amplitude = 1;

signal_length = 1024;
t = 0:(1/fs):(signal_length/fs);
sinusoidal_signal = amplitude * sin(2 * pi * frequency * t);

% Perform Discrete Wavelet Transform (DWT)
[cA, cD] = dwt(sinusoidal_signal, 'db1');

% Perform Continuous Wavelet Transform (CWT)
scales = 1:64;
wavelet = 'cmor1-1.5';
[CWT, ~] = cwt(sinusoidal_signal, scales, wavelet, 'SamplingPeriod', 1/fs);

% Perform Stationary Wavelet Transform (SWT)
level = 4;
extended_signal_length = signal_length + 2^(level+1);
extended_signal = extend_signal(sinusoidal_signal, extended_signal_length);
[~, cD_swt] = swt(extended_signal, level, 'db1');

% Create a time-frequency plot for DWT
figure;
subplot(3, 1, 1);
imagesc(1:length(cA), 1:2, abs([cA; cD]));
colormap(jet);
title('DWT - Scalogram');
xlabel('Time Index');
ylabel('Scale');

% Create a time-frequency plot for CWT
subplot(3, 1, 2);
imagesc(1:length(CWT), scales, abs(CWT));
colormap(jet);
title('CWT - Scalogram');
xlabel('Time Index');
ylabel('Scale');

% Create a time-frequency plot for SWT
subplot(3, 1, 3);
imagesc(1:length(cD_swt), 1:level, abs(cD_swt));
colormap(jet);
title('SWT - Scalogram');
xlabel('Time Index');
ylabel('Scale');

function extended_signal = extend_signal(signal, target_length)
    extended_signal = signal;
    while length(extended_signal) < target_length
        extended_signal = [extended_signal, 0];
    end
end
