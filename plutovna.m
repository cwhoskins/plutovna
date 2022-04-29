
txt = "";
help_prompt = "Please Enter VNA Mode: \nH: Help\nX: Exit\nP: Configure\nC: Calibration\nS: S-Parameter Measurement\n";
prompt = help_prompt;

% File names
cfg_file = "cfg.csv";
cal_file = "calibration_data.csv";

%Constant configuration parameters
samples_per_frame = 2e4;

% Read existing configuration or load defaults
% Read existing calibration data if it exists, otherwise load in default
% values
if exist(cfg_file, 'file')
    disp('Loading Configuration')
    x = readmatrix(cfg_file);
    freq_range = [x(1), x(2)];
    bw = x(3);
else
    disp('Could not file configuration file. Loading Defaults')
    freq_range = [1.5e9 2.5e9];
    bw = 10e6;
end
% Read existing calibration data if it exists, otherwise load in 0
if exist(cal_file, 'file')
   disp('Loading Calibration Data')
    x = readmatrix(cal_file);
    offset = x(:,1);
    gain = x(:,2);
    % Check if the calibration data matches the parameters
    if numel(offset) ~= ((freq_range(2)-freq_range(1))/bw)
        disp('Error: Calibration Data Invalid. Please Calibrate before using')
        offset = zeros((freq_range(2)-freq_range(1))/bw, 1);
        gain = zeros((freq_range(2)-freq_range(1))/bw, 1);
    end
else
    disp('plutoVNA is uncalibrated. Please Calibrate before using')
    offset = zeros((freq_range(2)-freq_range(1))/bw, 1);
    gain = zeros((freq_range(2)-freq_range(1))/bw, 1);
end

while(upper(txt) ~= "X")
    txt = upper(input(prompt,"s"));
    switch(txt)
        case 'P'
            disp('Updating Configuration Parameters. Please note that this invalidates calibration data')
            [freq_range, bw] = configure();
            writematrix([freq_range, bw], cfg_file);
            offset = zeros((freq_range(2)-freq_range(1))/bw, 1);
            gain = zeros((freq_range(2)-freq_range(1))/bw, 1);
        case "C"
            disp('Starting Calibration')
            [offset, gain] = calibrate(freq_range, bw);
            writematrix([offset, gain], cal_file);
        case "S"
            disp('Starting Measurement Mode')
            [freq, mag, phase] = capture(freq_range, bw);
            mag = mag - offset;
            mag = 20 .* log10(mag ./ gain);
            figure
            plot((freq./1e9), mag, 'b');
            title('S-Parameter Magnitude')
            xlabel('Frequency (GHz)')
            ylabel('|S| (dB)')

        case "X"
            disp('Exiting PlutoVNA Application')
        case "H"
            printf(help_prompt)
        otherwise
            disp('Could not parse input')
    end
    prompt = "Action Completed, please enter new command:\n";
end