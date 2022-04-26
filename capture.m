function [freq,mag,pha] = capture(freq_range,bw)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Setup Receiver
min_center_freq = freq_range(1);
max_center_freq = freq_range(2);
samples_per_frame = 2e4;
overlap = 4;
%Connect to PLUTO
tx = sdrtx('Pluto','RadioID','usb:0','CenterFrequency',freq_range(1),'BasebandSampleRate',bw,'Gain',-10);
rx=sdrrx('Pluto','RadioID', 'usb:0','OutputDataType','double','BasebandSampleRate', bw, 'SamplesPerFrame',samples_per_frame, 'GainSource','AGC Slow Attack');   
configurePlutoRadio('AD9364','usb:0');
steps = ceil((max_center_freq -min_center_freq) / (bw/overlap)) - (overlap-1);
span = ceil((max_center_freq -min_center_freq) / bw);
center_freq = min_center_freq;
mag = zeros((samples_per_frame*span),1);
pha = zeros((samples_per_frame*span),1);
% Receive and view sine
for k=1:steps
    % Update LO Frequency
    release(tx)
    tx.CenterFrequency = center_freq;
    transmitRepeat(tx, complex(ones(samples_per_frame,1)));
    rx.CenterFrequency = center_freq;
    % Capture data from PLUTO
    sig = fft(rx());
    % Remove DC Component
    sig(1) = sig(2);
    sig = fftshift(sig);
    cur_mag = abs(sig);
    cur_pha = angle(sig);
    start_idx = ((k-1)*(samples_per_frame/overlap))+1;
    end_idx = start_idx + samples_per_frame-1;
    mag(start_idx:end_idx) = mag(start_idx:end_idx) + cur_mag;
    pha(start_idx:end_idx) = pha(start_idx:end_idx) + cur_pha;
    center_freq = center_freq + (bw/overlap);
end
% Average out the overlapped signals
mag = mag ./ overlap;
pha = pha ./ overlap;
% Normalize fft vector
% mag = mag ./ max(mag);
% Create frequency vector
freq = linspace((min_center_freq-(bw/2)),(max_center_freq+(bw/2)),numel(mag));
end