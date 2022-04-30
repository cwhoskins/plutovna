function [freq,mag,pha] = capture(freq_range,bw)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Setup Receiver
min_center_freq = freq_range(1);
max_center_freq = freq_range(2);
samples_per_frame = 2e4;
%Connect to PLUTO
tx = sdrtx('Pluto','RadioID','usb:0','CenterFrequency',freq_range(1),'BasebandSampleRate',bw,'Gain',0);
rx=sdrrx(   'Pluto','RadioID', 'usb:0','OutputDataType','double',...
            'BasebandSampleRate', bw, 'SamplesPerFrame',samples_per_frame,...
            'GainSource','Manual', 'Gain', 5);   
steps = ceil((max_center_freq -min_center_freq) / bw);
center_freq = min_center_freq;
mag = zeros(steps,1);
pha = zeros(steps,1);
sine = dsp.SineWave('Frequency',5e3,...
                    'SampleRate',bw,...
                    'SamplesPerFrame', samples_per_frame,...
                    'ComplexOutput', true);
% Receive and view sine
for k=1:steps
    % Update LO Frequency
    tx.CenterFrequency = center_freq;
    rx.CenterFrequency = center_freq;
    %Start Transmission at new LO frequency
    tx.transmitRepeat(sine());
    % Capture data from PLUTO, read multiple times to ensure clear buffer
    for n=1:10
        sig = fft(rx());
    end
    avg_mag = 0;
    cur_pha = 0;
    %Average signals out 10 times to reduce noise
    for n=1:10
        % Remove DC Component
        sig(1) = 0;
        sig = fftshift(sig);
        cur_mag = abs(sig);
        [mMag, mIdx] = max(cur_mag);
        avg_mag = avg_mag + mMag;
        cur_pha = cur_pha + angle(sig(mIdx));
    end
    mag(k) = avg_mag / 10;
    pha(k) = cur_pha / 10;
    center_freq = center_freq + bw;
end
% Create frequency vector
freq = linspace(min_center_freq,max_center_freq,steps);
end