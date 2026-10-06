clc;
close all;

fs = 1000;
t = 0:1/fs:1-1/fs;
t1 = t - 0.5;
f1 = 10;
f2 = 100;
x = chirp(t,f1,0.5,f2);

N_chirps = 128;
Beat_matrix = zeros(N_chirps,length(t));

R = 50;
c = 1500;

for i=1:N_chirps
    tau = 2*R/c;
    y = chirp(t-tau,f1,0.5,f2);
    Beat_matrix(i,:) = x.*y;
    R = R + 0.03;
end    

Range_dopp = fft2(Beat_matrix);
figure;
imagesc(abs(Range_dopp)); 