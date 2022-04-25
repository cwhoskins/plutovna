
txt = "";
help_prompt = "Please Enter VNA Mode: \nH: Help\nX: Exit\nT: Thru Calibration\nR: Reflect Calibration\nL: Line Calibration\nQ: Measurement\n";
prompt = help_prompt;
while(upper(txt) ~= "X")
    txt = upper(input(prompt,"s"));
    switch(txt)
        case "T"
            disp('Starting Thru Calibration')
        case "R"
            disp('Starting Refelct Calibration')
        case "L"
            disp('Starting Line Calibration')
        case "Q"
            disp('Starting Measurement Mode')
        case "X"
            disp('Exiting PlutoVNA Application')
        case "H"
            printf(help_prompt)
        otherwise
            disp('Could not parse input')
    end
    prompt = "Action Completed, please enter new command:\n";
end