% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Ensure 'y' is a column vector
y = y(:);

% Define DWT parameters
waveletName = 'db4';   % Wavelet name (choose an appropriate wavelet)
level = 5;             % Decomposition level

% Perform DWT decomposition
[c, l] = wavedec(y, level, waveletName);

% Extract detail coefficients at different scales
detailCoefficients = cell(1, level);

for k = 1:level
    % Extract detail coefficients at the current scale
    detailCoefficients{k} = detcoef(c, l, k);
    
    % Compute the power spectral density (PSD) of detail coefficients
    [psd, f] = pwelch(detailCoefficients{k}, [], [], [], fs);
    
    % Plot the PSD for each scale
    subplot(level, 1, k);
    plot(f, 10*log10(psd));
    title(['Scale ', num2str(k)]);
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
end

% Add a title for the entire figure
sgtitle('Spectral Variations at Different DWT Scales');

% If you want to save the plots (optional)
% saveas(gcf, 'spectral_variations.png');

% If you want to save the PSD data (optional)
% save('psd_data.mat', 'detailCoefficients', 'f');
