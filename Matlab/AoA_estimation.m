clc;
close all;

fs = 1000;
t = 0:1/fs:1-1/fs;
t1 = t - 0.5;
f1 = 500;
f2 = 600;
x = chirp(t,f1,0.5,f2);

A = 4;
Beat_matrix = zeros(A,length(t));

R = 50;
c = 1500;

for i=1:A
    tau = 2*R/c;
    if i==3
        phase_shift = (i-1)*90+105;
    else    
        phase_shift = (i-1)*90;
    end
    y = chirp(t-tau,f1,0.5,f2,"linear",phase_shift);
    Beat_matrix(i,:) = x.*y;
end    

Range_dopp = fft2(Beat_matrix);
Out = CFAR_2D(Range_dopp);
figure;
imagesc(abs(Range_dopp)); 