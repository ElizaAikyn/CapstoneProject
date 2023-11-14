% Generate a Complex Sinusoidal Signal
fs = 1000; % Sampling frequency
t = 0:1/fs:1; % Time vector
frequency = 5; % Frequency of the complex waveform (5 Hz)
amplitude = 1; % Amplitude of the complex waveform

% Create a complex waveform
complex_waveform = amplitude * (cos(2 * pi * frequency * t) + 1i * sin(2 * pi * frequency * t));

% Signal Length
signal_length = length(complex_waveform);

% Perform Stationary Wavelet Transform (SWT) on real part
level = 4; % Number of decomposition levels
wavelet_name = 'db1'; % Wavelet for demonstration
tic;
[cA_swt_real, cD_swt_real] = swt(real(complex_waveform), level, wavelet_name);
swt_execution_time_real = toc;

% Perform Stationary Wavelet Transform (SWT) on imaginary part
tic;
[cA_swt_imag, cD_swt_imag] = swt(imag(complex_waveform), level, wavelet_name);
swt_execution_time_imag = toc;

% Combine the real and imaginary parts if needed
cA_swt_combined = cA_swt_real + 1i * cA_swt_imag;
cD_swt_combined = cD_swt_real + 1i * cD_swt_imag;

% Display Execution Times
fprintf('SWT (Real Part) Execution Time: %.4f seconds\n', swt_execution_time_real);
fprintf('SWT (Imaginary Part) Execution Time: %.4f seconds\n', swt_execution_time_imag);
