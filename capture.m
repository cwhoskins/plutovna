function [freq,mag,pha] = capture(freq_range,bw)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Setup Receiver
min_center_freq = freq_range(1);
max_center_freq = freq_range(2);
samples_per_frame = 2^9;
overlap = 4;
steps = ceil((max_center_freq -min_center_freq) / (bw/overlap)) - (overlap-1);
span = ceil((max_center_freq -min_center_freq) / bw);   
rx=sdrrx('Pluto','RadioID', 'usb:0','OutputDataType','double','BasebandSampleRate', bw, 'SamplesPerFrame',samples_per_frame, 'GainSource','AGC Slow Attack');
configurePlutoRadio('AD9364','usb:0');
center_freq = min_center_freq;
fft_vec = zeros((samples_per_frame*span),1);
% Receive and view sine
for k=1:steps
    % Update LO Frequency
    rx.CenterFrequency = center_freq;
    % Capture data from PLUTO
    sig = abs(fft(rx()));
    % Remove DC Component
    sig(1) = sig(2);
    sig = fftshift(sig);
    start_idx = ((k-1)*(samples_per_frame/overlap))+1;
    end_idx = start_idx + samples_per_frame-1;
    fft_vec(start_idx:end_idx) = fft_vec(start_idx:end_idx) + sig;
    center_freq = center_freq + (bw/overlap);
end
% Average out the overlapped signals
fft_vec = fft_vec ./ overlap;
% Normalize fft vector
fft_vec(:) = fft_vec(:) ./ max(fft_vec(:));
% Create frequency vector
freq = linspace((min_center_freq-(bw/2)),(max_center_freq+(bw/2)),numel(fft_vec));
plot(freq,fft_vec);
mag = fft_vec;
pha = zeros(numel(fft_vec), 1);
end