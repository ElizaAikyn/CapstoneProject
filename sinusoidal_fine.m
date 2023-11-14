% Generate a Sinusoidal Signal
fs = 1000;          
t = 0:1/fs:1;       
frequency = 5;     
amplitude = 1;     

signal_length = 1024;  
t = 0:(1/fs):(signal_length/fs);
sinusoidal_signal = amplitude * sin(2 * pi * frequency * t);

% Perform Discrete Wavelet Transform (DWT)
[cA, cD] = dwt(sinusoidal_signal, 'db1');
fine_details_dwt = cD;

% Perform Continuous Wavelet Transform (CWT)
scales = 1:64;
wavelet = 'cmor1-1.5';
[CWT, frequencies] = cwt(sinusoidal_signal, scales, wavelet, 'SamplingPeriod', 1/fs);
scale = 16;
fine_details_cwt = CWT(scales == scale, :);

% Perform Stationary Wavelet Transform (SWT)
level = 4;
extended_signal_length = signal_length + 2^(level+1);
extended_signal = extend_signal(sinusoidal_signal, extended_signal_length);
[~, cD] = swt(extended_signal, level, 'db1');
fine_details_swt = cD;

% Plot the Fine Details
subplot(3, 1, 1);
plot(t, sinusoidal_signal);
title('Original Sinusoidal Signal');

subplot(3, 1, 2);
plot(fine_details_dwt);
title('DWT - Fine Details');

subplot(3, 1, 3);
plot(fine_details_cwt);
title('CWT - Fine Details');

figure;
subplot(2, 1, 1);
plot(t, sinusoidal_signal);
title('Original Sinusoidal Signal');

subplot(2, 1, 2);
plot(fine_details_swt);
title('SWT - Fine Details');

function extended_signal = extend_signal(signal, target_length)
    extended_signal = signal;
    while length(extended_signal) < target_length
        extended_signal = [extended_signal, 0];
    end
end
