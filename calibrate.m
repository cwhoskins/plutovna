function [offset, gain] = calibrate(freq_range,bw)
offset_prompt = "Enter Y when PLUTO is in offset calibration configuration\n";
gain_prompt = "Enter Y when PLUTO is in gain calibration configuration\n";
txt = "n";
while(upper(txt) ~= "Y")
    txt = upper(input(offset_prompt,"s"));
end
[~, offset, ~] = capture(freq_range,bw);
txt = "n";
while(upper(txt) ~= "Y")
    txt = upper(input(gain_prompt,"s"));
end
[freq, gain, ~] = capture(freq_range,bw);
gain = gain - offset;
end