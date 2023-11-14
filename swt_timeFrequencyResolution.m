% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Parameters for SWT
nLevels = 4;  % Choose the number of decomposition levels
waveletName = 'db4';  % Choose an appropriate wavelet

% Ensure 'y' is a column vector
y = y(:);

% Calculate the desired signal length that is compatible with nLevels
desiredLength = 2^nLevels * ceil(length(y) / 2^nLevels);

% If the signal length is not compatible, pad it or crop it
if length(y) > desiredLength
    y = y(1:desiredLength);  % Crop the signal
elseif length(y) < desiredLength
    % Pad the signal with zeros to the desired length
    y = padarray(y, [desiredLength - length(y), 0], 0, 'post');
end

% Measure time-frequency resolution
swc = swt(y, nLevels, waveletName);

% Visualize time-frequency resolution by plotting SWT coefficients
figure;
imagesc(abs(swc));  % Plot the magnitude of SWT coefficients
title('Time-Frequency Resolution (SWT Coefficients)');
xlabel('Time Samples');
ylabel('Frequency Bins');

colormap('jet');  % Use a colormap for better visualization

% Optionally, you can zoom in or analyze specific subbands or scales
