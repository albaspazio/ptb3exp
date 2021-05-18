%% showCross(window, waitseconds, forecolor, linewidth, keepimage, backcolor)
%  show cross with forecolor and linewidth specs
%  can stop execution for waitsecond (if > 0) seconds
%  in that case can, at the end, substitute it (if keepimage = 0) with a backcolor windows
%%
function showCross(window, waitseconds, forecolor, linewidth, keepimage, backcolor)

    if nargin < 5
        keepimage = 1;
    end
    
    [W, H]          = Screen('WindowSize', window); 
    cross_center    = [W/2-12 W/2+12 W/2 W/2; H/2 H/2 H/2-12 H/2+12];
    
    % draw the cross and wait for display_time seconds
    Screen('DrawLines', window, cross_center, linewidth, forecolor);
    Screen('Flip', window);

    if waitseconds
        start_time = GetSecs;
        while 1 
            elapsed = GetSecs - start_time;
            if elapsed > waitseconds
                break;
            end
        end 
        
        if ~keepimage
            fill_rects(win, backcolor);
        end        
    end
    
end