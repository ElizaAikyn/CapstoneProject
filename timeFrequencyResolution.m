% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'tv-glitch-6245.mp3';
[y, fs] = audioread(audioFile);

% Parameters
nLevels = 5;  % Number of decomposition levels for DWT and SWT
waveletName = 'db4';  % Wavelet for DWT and SWT
scales = 1:128;  % Scales for CWT

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

% Perform DWT
[cDWT, lDWT] = wavedec(y, nLevels, waveletName);

% Perform CWT
cCWT = cwt(y, scales, 'morl');

% Perform SWT
swc = swt(y, nLevels, waveletName);

% Plot and compare the time-frequency resolution
t = 0:1/fs:(length(y) - 1) / fs;

% FWHM calculations
cwt_fwhm = calculateFWHM(abs(cCWT), scales, fs);
dwt_fwhm = calculateFWHM(abs(cDWT), lDWT, fs);
swt_fwhm = calculateFWHM(abs(swc), 1:nLevels, fs);

% Display FWHM values
fprintf('CWT FWHM: %.2f\n', cwt_fwhm);
fprintf('DWT FWHM: %.2f\n', dwt_fwhm);
fprintf('SWT FWHM: %.2f\n', swt_fwhm);

figure;
subplot(3, 1, 1);
imagesc(t, scales, abs(cCWT));
title('CWT Time-Frequency Resolution');
xlabel('Time (s)');
ylabel('Scale');
colormap('jet');

subplot(3, 1, 2);
plotDWTTimeFrequency(abs(cDWT), lDWT, fs);
colormap('jet');

subplot(3, 1, 3);
imagesc(t, 1:nLevels, abs(swc));
title('SWT Time-Frequency Resolution');
xlabel('Time (s)');
ylabel('Level');
colormap('jet');

function plotDWTTimeFrequency(c, l, fs)
    % Helper function to plot DWT coefficients in time-frequency domain
    scales = l(1) ./ (2.^(1:length(l)-2));
    t = 0:1/fs:(length(c)-1)/fs;
    imagesc(t, scales, abs(c)');
    title('DWT Time-Frequency Resolution');
    xlabel('Time (s)');
    ylabel('Scale');
end

function fwhm = calculateFWHM(data, scales, fs)
    % Calculate FWHM for CWT, DWT, or SWT
    fwhm = zeros(1, length(scales));
    
    for i = 1:length(scales)
        if isrow(data)
            scale_data = data;
        else
            scale_data = data;
        end
        
        half_max = max(scale_data) / 2;
        above_half_max = scale_data >= half_max;
        
        if any(above_half_max)
            indices = find(above_half_max);
            fwhm(i) = (indices(end) - indices(1)) / fs;
        else
            fwhm(i) = 0;
        end
    end
end
