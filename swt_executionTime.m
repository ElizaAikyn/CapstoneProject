% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Parameters for SWT
nLevels = 4;  % Choose the number of decomposition levels
waveletName = 'db4';  % Choose an appropriate wavelet

% Ensure 'y' is a column vector
y = y(:);

% Calculate the desired signal length that is compatible with nLevels
desiredLength = 2^nLevels;
currentLength = length(y);

% If the signal length is not compatible, truncate or pad it
if currentLength > desiredLength
    y = y(1:desiredLength);  % Truncate the signal
elseif currentLength < desiredLength
    % Pad the signal with zeros to the desired length
    y = padarray(y, [desiredLength - currentLength, 0], 0, 'post');
end

% Measure execution time
tic;  % Start timer
swc = swt(y, nLevels, waveletName);  % Perform SWT
executionTime = toc;  % Elapsed time
disp(['Execution Time: ', num2str(executionTime), ' seconds']);

% Optionally, you can work with the SWT coefficients 'swc' for further analysis
