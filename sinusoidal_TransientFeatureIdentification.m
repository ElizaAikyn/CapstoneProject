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
extended_signal_length = signal_length + 2^(level + 1);
extended_signal = extend_signal(sinusoidal_signal, extended_signal_length);
[~, cD_swt] = swt(extended_signal, level, 'db1');

% Transient Feature Identification
threshold_dwt = 0.5;
threshold_swt = 0.5;
energy_threshold_cwt = 0.5;

% Identify transient features in DWT
transient_indices_dwt = find(abs(cD) > threshold_dwt);

% Identify transient features in CWT
cwt_energy = sum(abs(CWT).^2, 1);
transient_indices_cwt = find(cwt_energy > energy_threshold_cwt);

% Identify transient features in SWT
transient_indices_swt = find(abs(cD_swt) > threshold_swt);
% Ensure the indices are within bounds
transient_indices_swt = transient_indices_swt(transient_indices_swt <= length(sinusoidal_signal));

% Visualize Transient Features
figure;
plot(t, sinusoidal_signal);
hold on;
plot(t(transient_indices_dwt), sinusoidal_signal(transient_indices_dwt), 'ro', 'MarkerSize', 5);
plot(t(transient_indices_cwt), sinusoidal_signal(transient_indices_cwt), 'go', 'MarkerSize', 5);
plot(t(transient_indices_swt), sinusoidal_signal(transient_indices_swt), 'bo', 'MarkerSize', 5);
legend('Original Signal', 'DWT Transient Features', 'CWT Transient Features', 'SWT Transient Features');
title('Transient Feature Identification');

% Plot transient feature locations in the time-frequency domain for CWT
figure;
subplot(2, 1, 1);
imagesc(1:length(sinusoidal_signal), scales, abs(CWT));
colormap(jet);
title('CWT - Scalogram');
xlabel('Time Index');
ylabel('Scale');

subplot(2, 1, 2);
plot(t(transient_indices_cwt), scales(transient_indices_cwt), 'ro', 'MarkerSize', 5);
title('CWT Transient Features');
xlabel('Time Index');
ylabel('Scale');

function extended_signal = extend_signal(signal, target_length)
    extended_signal = signal;
    while length(extended_signal) < target_length
        extended_signal = [extended_signal, 0];
    end
end
