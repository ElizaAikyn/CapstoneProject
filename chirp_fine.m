% Generate a Chirp Signal
fs = 1000; % Sampling frequency
t = 0:1/fs:1; % Time vector
f0 = 100; % Initial frequency
f1 = 200; % Final frequency
chirp_signal = chirp(t, f0, 1, f1);

% Initialize variables for fine details
dwt_fine_details = [];
cwt_fine_details = [];
swt_fine_details = [];

% Perform Discrete Wavelet Transform (DWT)
wavelet_name = 'db1'; % Daubechies 1 wavelet for demonstration
[cA, cD] = dwt(chirp_signal, wavelet_name);
dwt_fine_details = cD;

% Perform Continuous Wavelet Transform (CWT)
scales = 1:64;
wavelet = 'cmor1-1.5'; % Example continuous Morlet wavelet
[CWT, ~] = cwt(chirp_signal, scales, wavelet, 'SamplingPeriod', 1/fs);
cwt_fine_details = CWT;

% Perform Stationary Wavelet Transform (SWT)
level = 4; % Number of decomposition levels compatible with the signal length
% Extend the signal to be compatible with SWT
extended_signal_length = 2^level * ceil(length(chirp_signal) / 2^level);
extended_signal = chirp_signal;
if length(chirp_signal) < extended_signal_length
    extended_signal = [extended_signal, zeros(1, extended_signal_length - length(chirp_signal))];
end
[cA, cD] = swt(extended_signal, level, wavelet_name);
swt_fine_details = cD;

% Plot Fine Details
subplot(3, 1, 1);
plot(1:length(dwt_fine_details), dwt_fine_details);
title('DWT Fine Details');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(3, 1, 2);
imagesc(1:length(cwt_fine_details), scales, abs(cwt_fine_details));
colormap(jet);
title('CWT Fine Details');
xlabel('Sample Index');
ylabel('Scale');

subplot(3, 1, 3);
imagesc(1:length(swt_fine_details), 1:level, abs(swt_fine_details));
colormap(jet);
title('SWT Fine Details');
xlabel('Sample Index');
ylabel('Scale');
