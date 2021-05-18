function showCountDown(window, lenght, message1, message2, color, fontsize, backcolor)

    if iscell(window)
        showCountDownEx(window, lenght, message1, message2, color, fontsize, backcolor)
    else
        % show a 'lenght' seconds countdown panel
        start_time=GetSecs;
        while 1 
            elapsed=GetSecs-start_time;
            left=ceil(lenght-elapsed);
            [nx, ny, textbounds] = DrawFormattedText(window,[message1 num2str(left)],'center','center',color, fontsize ,[],[],1.5);
            Screen('Flip', window);
            if elapsed > lenght
                [nx, ny, textbounds] = DrawFormattedText(window,message2,'center','center',color, fontsize ,[],[],1.5);
                Screen('Flip', window);
                WaitSecs(1);
                fill_rects(window, backcolor);
                break;
            end
        end
    end
end