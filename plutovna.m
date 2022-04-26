
txt = "";
help_prompt = "Please Enter VNA Mode: \nH: Help\nX: Exit\nC: Calibration\nS: S-Parameter Measurement\n";
prompt = help_prompt;
phase_offset = 0;
freq_range = [1.5e9 1.6e9];
bw = 10e6;
samples_per_frame = 2e4;
while(upper(txt) ~= "X")
    txt = upper(input(prompt,"s"));
    switch(txt)
        case "C"
            disp('Starting Calibration')
        case "S"
            disp('Starting Measurement Mode')
            [freq, mag, phase] = capture(freq_range, bw);
            plot(freq, mag, 'r');
            %hold on
            %plot(freq, phase, 'b');
        case "X"
            disp('Exiting PlutoVNA Application')
        case "H"
            printf(help_prompt)
        otherwise
            disp('Could not parse input')
    end
    prompt = "Action Completed, please enter new command:\n";
end