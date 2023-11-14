% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Ensure 'y' is a column vector
y = y(:);

% Parameters for CWT
waveletName = 'morl'; % Wavelet to use (Morlet wavelet is commonly used for CWT)
scales = 1:128; % Define the range of scales for the CWT

% Perform CWT
cwtCoeffs = cwt(y, scales, waveletName);

% Define the desired time and scale resolutions for interpolation
desiredTimeResolution = 0.001; % Set your desired time resolution (in seconds)
desiredScaleResolution = 1; % Set your desired scale resolution

% Create a grid of time and scale values
t = 0:desiredTimeResolution:(length(y) - 1) / fs;
scales = 1:desiredScaleResolution:max(scales);

% Interpolate the CWT coefficients
interpolatedCWT = interp2(t, scales, abs(cwtCoeffs), t, scales', 'spline');

% Visualize the interpolated CWT coefficients
figure;
imagesc(t, scales, interpolatedCWT);
colormap('jet');
axis xy; % Flip the y-axis to have low frequencies at the bottom
xlabel('Time (s)');
ylabel('Scale');
title('Interpolated Continuous Wavelet Transform');
colorbar;

% Play the original audio
sound(y, fs);
pause(length(y)/fs);
