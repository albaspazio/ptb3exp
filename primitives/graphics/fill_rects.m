function fill_rects(windows, backcolor)

    if iscell(windows)
        for w=1:length(windows)
            Screen('FillRect', windows{w}, backcolor);
            Screen('Flip', windows{w});              
        end
    else
        Screen('FillRect', windows, backcolor);
        Screen('Flip', windows);               
    end
end