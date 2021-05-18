%   show a 'lenght' seconds countdown panel

function exp_show_countdown(experiment, windows, lenght, message1, message2, color, wrapat, backcolor)

    start_time=GetSecs;
    while 1 
        elapsed=GetSecs-start_time;
        left=ceil(lenght-elapsed);
        
        exp_show_text(experiment, windows, [message1 num2str(left)], 'forecolor', color, 'wrapat', wrapat);

        if elapsed > lenght
            
            exp_show_text(experiment, windows, message2);
            WaitSecs(1);
            fill_rects(windows, backcolor);
            
            break;
        end
    end

end