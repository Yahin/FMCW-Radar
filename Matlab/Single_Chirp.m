clc;
close all;

fs = 1000;
t = 0:1/fs:1-1/fs;
t1 = t - 0.5;
f1 = 50;
f2 = 100;
x = chirp(t,f1,0.5,f2);

% Single Chirp
y = chirp(t1,f1,0.5,f2);
y(t<0.5)=0;
beat = (x .* y);
beat_filtered = lowpass(beat,f2-f1,fs);
figure;
plot(t, beat_filtered);
title('beat filtered');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;