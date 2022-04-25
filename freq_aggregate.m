% Setup Receiver
min_center_freq = 325.0e6;
max_center_freq = 3.8e9;
samples_per_frame = 2^12;
rx_bandwidth = 5.0e6;
steps = ceil((max_center_freq -min_center_freq) / rx_bandwidth);  
rx=sdrrx('Pluto','RadioID', 'usb:0','OutputDataType','double','BasebandSampleRate', rx_bandwidth, 'SamplesPerFrame',samples_per_frame, 'GainSource','Manual', 'Gain', 10);
configurePlutoRadio('AD9364','usb:0');
center_freq = min_center_freq;
fft_mat = zeros((samples_per_frame*steps),2);
% Receive and view sine
disp('Capturing Data');
for k=1:steps
  rx.CenterFrequency = center_freq;
  sig = abs(fft(rx()));
  sig(1) = 0; %Remove DC component
  freq = linspace((center_freq-(rx_bandwidth/2)),(center_freq+(rx_bandwidth/2)),numel(sig));
  start_idx = (((k-1)*samples_per_frame)+1);
  end_idx = (k*samples_per_frame);
  new_fft = [freq' sig];
  fft_mat(start_idx:end_idx,:) = new_fft;
  center_freq = center_freq + rx_bandwidth;
end
disp('Smoothing Data');
for k=1:4
    fft_mat(:,2) = smooth(fft_mat(:,2),11);
end
disp('Normalizing Data');
fft_mat(:,2) = fft_mat(:,2) ./ max(fft_mat(:,2));
plot(fft_mat(:,1),fft_mat(:,2));
disp('Printing Data to file');
writematrix(fft_mat,'stitched.txt');