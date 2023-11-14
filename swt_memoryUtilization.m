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

% Measure memory utilization before SWT
initialMemoryInfo = memory;

% Perform SWT
swc = swt(y, nLevels, waveletName);

% Measure memory utilization after SWT
finalMemoryInfo = memory;

% Calculate memory usage change
memoryChange = finalMemoryInfo.MemUsedMATLAB - initialMemoryInfo.MemUsedMATLAB;

% Display memory utilization
disp(['Initial Memory Usage: ', num2str(initialMemoryInfo.MemUsedMATLAB / 1e6), ' MB']);
disp(['Final Memory Usage: ', num2str(finalMemoryInfo.MemUsedMATLAB / 1e6), ' MB']);
disp(['Memory Utilization Change: ', num2str(memoryChange / 1e6), ' MB']);
