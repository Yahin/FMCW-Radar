Fs = 2000;              % 2 kHz sampling rate
N  = 1024;              % 1024 samples
t  = (0:N-1)' / Fs;     % Time vector
fb = 50;                % 50 Hz beat frequency

% Create the test signal with a peak amplitude of 0.8
rng(42);                % Reproducible seed
snr_target = 25;        % Target SNR in dB
sig_clean = 0.8 * cos(2 * pi * fb * t);
sig_noisy = awgn(sig_clean, snr_target, 'measured');

% Apply the Hamming window
win = hamming(N);
sig_win = sig_noisy .* win;

fft_float = fft(sig_win);
mag_float_dB = 20*log10(abs(fft_float)/max(abs(fft_float)));

sig_fi = fi(sig_win,1,16,15);
hFFt = dsp.FFT;
fft_fi = hFFt(sig_fi);

fft_fi_double = double(fft_fi);
% mag_fi = abs(fft_fi_double);
% mag_fi_dB = 20 * log10(mag_fi / max(mag_fi));

fft_out16 = fi(fft_fi/N,1,16,15);
fft_recon = double(fft_out16)*N;
mag_fi = abs(fft_recon);
mag_fi_dB = 20 * log10(mag_fi / max(mag_fi));

quant_error = abs(fft_recon - fft_float);
sp = sum(abs(fft_float).^2);
np = sum(quant_error.^2);
SQNR = 10*log10(sp/np);

freq_axis = (0:N-1) * (Fs / N);

figure('Name', 'Fixed-Point vs Floating-Point Range FFT', 'Color', 'w');

%subplot(2, 1, 1);
plot(freq_axis(1:N/2), mag_float_dB(1:N/2), 'b', 'LineWidth', 1.5, 'DisplayName', '64-bit Double Float (Reference)');
hold on;
plot(freq_axis(1:N/2), mag_fi_dB(1:N/2), 'r--', 'LineWidth', 1.2, 'DisplayName', '16-bit Fixed-Point (Hardware)');
grid on;
title(sprintf('Range FFT Spectrum Comparison (SQNR = %.2f dB)', SQNR), 'FontSize', 12);
xlabel('Frequency (Beat Frequency in Hz)');
ylabel('Normalized Magnitude (dB)');
xlim([0 Fs/4]); ylim([-80 5]);
legend('Location', 'northeast');
