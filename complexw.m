% Define parameters for the complex waveform
fs = 1000;         % Sampling frequency
t = 0:1/fs:1;      % Time vector
frequency = 10;    % Frequency of the complex waveform (10 Hz)
amplitude = 1;     % Amplitude of the complex waveform

% Generate a complex waveform
complex_waveform = amplitude * (cos(2*pi*frequency*t) + 1i * sin(2*pi*frequency*t));

% Perform Discrete Wavelet Transform (DWT)
wavelet_name = 'db1'; % Daubechies 1 wavelet for demonstration
level = 4;
[cA_dwt, ~] = dwt(real(complex_waveform), wavelet_name);

% Perform Continuous Wavelet Transform (CWT)
scales = 1:64;
wavelet = 'cmor1-1.5'; % Example continuous Morlet wavelet
[CWT, frequencies] = cwt(complex_waveform, scales, wavelet, 'SamplingPeriod', 1/fs);

% Create a time vector for plotting CWT
t_cwt = (0:1/fs:(length(complex_waveform) - 1) / fs);

% Plot the Results
figure;

% Plot the complex waveform (real and imaginary parts)
subplot(2, 2, 1);
plot(t, real(complex_waveform));
title('Complex Waveform (Real)');

subplot(2, 2, 2);
plot(t, imag(complex_waveform));
title('Complex Waveform (Imaginary)');

% Plot the DWT Approximation Coefficients (Real part)
subplot(2, 2, 3);
plot(linspace(0, 1, length(cA_dwt)), cA_dwt);
title('DWT - Approximation Coefficients (Real)');

% For CWT, create a time-frequency grid for plotting
[time_grid, scale_grid] = meshgrid(t_cwt, scales);

subplot(2, 2, 4);
pcolor(time_grid, scale_grid, abs(CWT));
shading interp; % Interpolate the colors for better visualization
title('CWT - Scalogram');
xlabel('Time (s)');
ylabel('Scale');
colormap('jet');

% Adjust plot layout
sgtitle('Complex Waveform and Wavelet Transforms', 'FontSize', 14);
