% Load an audio signal (replace 'your_audio.wav' with your audio file)
audioFile = 'thunder.wav';
[y, fs] = audioread(audioFile);

% Ensure 'y' is a column vector
y = y(:);

% Define DWT parameters
waveletName = 'db4';   % Wavelet name (choose an appropriate wavelet)
level = 5;             % Maximum decomposition level

% Initialize a cell array to store hierarchical decomposition coefficients
hierarchicalDecomposition = cell(1, level);

% Perform hierarchical decomposition
for k = 1:level
    [c, l] = wavedec(y, k, waveletName);
    hierarchicalDecomposition{k} = c;
end

% Plot the hierarchical decomposition coefficients
figure;
for k = 1:level
    subplot(level, 1, k);
    plot(hierarchicalDecomposition{k});
    title(['Hierarchical Decomposition (Level ', num2str(k), ')']);
    xlabel('Sample Index');
    ylabel('Amplitude');
end

% If you want to save the plots (optional)
% saveas(gcf, 'hierarchical_decomposition.png');
