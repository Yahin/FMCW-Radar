function [detection] = CFAR_2D(signal)
%CFAR Summary of this function goes here
%   Detailed explanation goes here
clc;
close all;

T = 4;
G = 2;
offset = 5;
detection = zeros(size(signal,1),size(signal,2));

for j = T+G+1: size(signal,1)-(T+G+1)
for i = T+G+1: size(signal,2)-(T+G+1)

    Gr = i-G:i+G;
    Gc = j-G:j+G;
    Tr = i-(T+G):i+(T+G);
    Tc = j-(T+G):j+(T+G);

    Ta = signal(Tc,Tr);
    Ga = signal(Gc,Gr);
    
    T_noise = sum(Ta,"all");
    G_noise = sum(Ga,"all");

    noise_level = T_noise-G_noise;
    
    threshold = noise_level * offset;
    
    if signal(j,i)>threshold
        detection(j,i)=1;
    else 
        detection(j,i)=0;
    end
end

end