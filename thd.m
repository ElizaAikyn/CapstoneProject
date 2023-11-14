% Generate a simple test signal
fs = 1000;  % Sampling frequency (Hz)
t = 0:1/fs:1;  % Time vector from 0 to 1 second
f1 = 50;  % Fundamental frequency (Hz)
f2 = 150;  % Harmonic frequency (Hz)
signal = sin(2*pi*f1*t) + 0.3*sin(2*pi*f2*t);  % Signal with fundamental and harmonic

% Perform DWT
wavelet = 'db4'; % Choose a wavelet type
level = 5; % Choose the level of decomposition

[cA_dwt, cD_dwt] = dwt(signal, wavelet);

% Perform CWT
scales = 1:64; % Choose the scales for the CWT
cwt_result = cwt(signal, scales, wavelet);

% Extend the signal's length to the nearest power of 2 for SWT
original_length = length(signal);
next_pow_of_2 = 2^nextpow2(original_length);
padding = next_pow_of_2 - original_length;
extended_signal = [signal, zeros(1, padding)];

% Perform SWT
[C_swt, L_swt] = swt(extended_signal, level, wavelet);

% Define the fundamental frequency
fundamental_freq = f1;

% Calculate THD for DWT
thd_dwt = calculateTHD(cA_dwt, fundamental_freq, fs);

% Calculate THD for CWT
thd_cwt = calculateTHD(sum(abs(cwt_result), 1), fundamental_freq, fs);

% Calculate THD for SWT
reconstructed_signal = iswt(C_swt, wavelet);
thd_swt = calculateTHD(reconstructed_signal, fundamental_freq, fs);

% Display THD values
fprintf('DWT - Total Harmonic Distortion (THD): %.4f\n', thd_dwt);
fprintf('CWT - Total Harmonic Distortion (THD): %.4f\n', thd_cwt);
fprintf('SWT - Total Harmonic Distortion (THD): %.4f\n', thd_swt);

% Function to calculate THD with the sampling frequency (fs) argument
function thd = calculateTHD(signal, fundamental_freq, fs)
    % Perform FFT
    fft_result = fft(signal);
    
    % Determine the frequency bin corresponding to the fundamental frequency
    fundamental_bin = round(fundamental_freq * length(signal) / fs) + 1;
    
    % Determine the frequency bins corresponding to the harmonics
    harmonics = 2:5; % Example includes the 2nd to 5th harmonics
    
    % Calculate the magnitude of the harmonic components
    harmonic_magnitudes = abs(fft_result(fundamental_bin * harmonics));
    
    % Calculate the fundamental frequency magnitude
    fundamental_magnitude = abs(fft_result(fundamental_bin));
    
    % Calculate THD as the ratio of the sum of harmonic magnitudes to the fundamental magnitude
    thd = sqrt(sum(harmonic_magnitudes.^2)) / fundamental_magnitude;
end
