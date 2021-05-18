function showCountDownEx(windows, lenght, message1, message2, color, fontsize, backcolor)

    num_scr=length(windows);
    % show a 'lenght' seconds countdown panel
    start_time=GetSecs;
    while 1 
        elapsed = GetSecs-start_time;
        left    = ceil(lenght-elapsed);
        for w=1:num_scr
            [nx, ny, textbounds] = DrawFormattedText(windows{w},[message1 num2str(left)],'center','center',color, fontsize ,[],[],1.5);
            Screen('Flip', windows{w});
        end
        if elapsed > lenght
            for w=1:num_scr
                [nx, ny, textbounds] = DrawFormattedText(windows{w},message2,'center','center',color, fontsize ,[],[],1.5);
                Screen('Flip', windows{w});
            end
            WaitSecs(1);
            fill_rects(windows, backcolor);
            break;
        end
    end

end