% Load the audio signal (replace 'audio.wav' with your audio file)
clean_audio = audioread('thunder.wav');

% Check the original length of the audio signal
original_length = length(clean_audio);

% Display the original length
fprintf('Original audio length: %d samples\n', original_length);
