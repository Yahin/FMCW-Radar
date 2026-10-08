clc;
close all;

% Radar Params
fs = 1000;

f1 = 500;
f2 = 600;
B = f2-f1;

Tc = 0:1/fs:1-1/fs;
t1 = Tc - 0.5;

x = chirp(Tc,f1,0.5,f2);
A = 8;    % Number of sensors
N_chirps = 128;   % Number of chirps in the chirp train

Sensor_data = zeros(N_chirps, A, length(Tc));

% Radar Params
R = 50;
v = 30;           % Velocity in m/s
theta = 30;       % Angle in degrees

c = 1500;
for ch=1:N_chirps
    for sens=1:A
        tau = 2*R/c;
        phase_shift = (sens-1)*90;
        y = chirp(Tc-tau,f1,0.5,f2,"linear",phase_shift);
        Sensor_data(ch,sens,:) = x.*y;
    end
    R = R + 0.03;
end


Radar_fft = fftn(Sensor_data);
[max_val, linear_index] = max(Radar_fft(:));
[doppler_bin, angle_bin, range_bin] = ind2sub(size(Radar_fft), linear_index);
disp('🎯 TARGET DETECTED 🎯');
disp(['Range Bin:   ', num2str(range_bin)]);
disp(['Doppler Bin: ', num2str(doppler_bin)]);
disp(['Angle Bin:   ', num2str(angle_bin)]); 