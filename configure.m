function [freq_range, bw] = configure()
    min_freq_prompt = "Please enter the start frequency (MHz) of the sweep: ";
    max_freq_prompt = "Please enter the end frequency (MHz) of the sweep: ";
    bw_prompt = "Please enter the bandwidth (MHz): ";
    min_freq = input(min_freq_prompt);
    max_freq = input(max_freq_prompt);
    %Check for valid min frequency
    if(min_freq < 70)
        min_freq = 70;
    elseif(min_freq > 6000)
        min_freq = 6000;
    elseif(min_freq > max_freq)
        temp = max_freq;
        max_freq = min_freq;
        min_freq = temp;
    end
    %Check for valid max freq
    if(max_freq < 70)
        max_freq = 70;
    elseif(max_freq > 6000)
        max_freq = 6000;
    end
    freq_range = [min_freq, max_freq] .* 1e6;
    bw = input(bw_prompt);
    if(bw < 0.01)
        bw = 0.01;
    elseif(bw > 40)
        bw = 40;
    end
    bw = bw * 1e6;
end