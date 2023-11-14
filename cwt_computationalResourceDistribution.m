% Start timing
tic;

% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Ensure 'y' is a column vector
y = y(:);

% Parameters for CWT
waveletName = 'morl'; % Wavelet to use (Morlet wavelet is commonly used for CWT)
scales = 1:128; % Define the range of scales for the CWT

% Measure initial memory usage
initialMemory = memory;

% Perform CWT
cwtCoeffs = cwt(y, scales, waveletName);

% Measure memory usage after performing CWT
memoryUsage = memory;

% Calculate and display the change in memory utilization
memoryIncrease = memoryUsage.MemUsedMATLAB - initialMemory.MemUsedMATLAB;
disp(['Memory utilization after CWT: ', num2str(memoryIncrease / 1024), ' KB']);

% Calculate and display the execution time for the CWT
cwtExecutionTime = toc;
disp(['CWT Execution time: ', num2str(cwtExecutionTime), ' seconds']);

% Plot the CWT coefficients
t = 0:1/fs:(length(y) - 1) / fs;
figure;
imagesc(t, scales, abs(cwtCoeffs));
colormap('jet');
axis xy; % Flip the y-axis to have low frequencies at the bottom
xlabel('Time (s)');
ylabel('Scale');
title('Continuous Wavelet Transform');
colorbar;

% Measure memory usage after plotting
memoryUsageAfterPlot = memory;

% Calculate and display the change in memory utilization after plotting
memoryIncreaseAfterPlot = memoryUsageAfterPlot.MemUsedMATLAB - memoryUsage.MemUsedMATLAB;
disp(['Memory utilization after plotting: ', num2str(memoryIncreaseAfterPlot / 1024), ' KB']);

% Stop timing and display the total execution time
totalExecutionTime = toc;
disp(['Total Execution time: ', num2str(totalExecutionTime), ' seconds']);

% Play the original audio
sound(y, fs);
pause(length(y)/fs);
