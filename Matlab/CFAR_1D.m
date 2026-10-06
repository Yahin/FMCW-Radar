function [detection] = CFAR_1D(signal)
%CFAR Summary of this function goes here
%   Detailed explanation goes here
clc;
close all;

T = 4;
G = 2;
offset = 5;
detection = zeros(length(signal));

for j = 1:size(signal,1)
for i = T+G+1: size(signal,2)-(T+G+1)
    start_ind = i-(T+G);
    end_ind = i+(T+G); 
    TW_left = signal(start_ind:i-G-1);
    TW_right = signal(i+G+1:end_ind);
    
    noise_level = mean([TW_left,TW_right]);
    threshold = noise_level * offset;
    
    if signal(i)>threshold
        detection(i)=1;
    else 
        detection(i)=0;
    end
end

end