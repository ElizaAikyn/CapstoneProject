% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Ensure 'y' is a column vector
y = y(:);

% Parameters for DWT
waveletName = 'db4'; % Wavelet to use
level = 5;           % Number of decomposition levels

% Start measuring CPU time
totalTimeStart = tic;

% Perform the DWT decomposition
dwtTimeStart = tic;
[c, l] = wavedec(y, level, waveletName);
dwtTime = toc(dwtTimeStart);

% Calculate the threshold for denoising (universal threshold for soft thresholding)
sigma = median(abs(c))/0.6745; % Estimate of the noise standard deviation
threshold = sigma * sqrt(2 * log(length(y)));

% Apply soft thresholding to the DWT coefficients
thresholdingTimeStart = tic;
cDenoised = wthresh(c, 's', threshold);
thresholdingTime = toc(thresholdingTimeStart);

% Reconstruct the denoised signal
reconstructionTimeStart = tic;
yDenoised = waverec(cDenoised, l, waveletName);
reconstructionTime = toc(reconstructionTimeStart);

% Stop measuring CPU time
totalTime = toc(totalTimeStart);

% Display CPU time for different parts of the code
fprintf('DWT execution time: %.4f seconds\n', dwtTime);
fprintf('Thresholding execution time: %.4f seconds\n', thresholdingTime);
fprintf('Reconstruction execution time: %.4f seconds\n', reconstructionTime);
fprintf('Total execution time: %.4f seconds\n', totalTime);
