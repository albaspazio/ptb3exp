% functions:


function keypressed = showImageNseconds(file_image, win, waitseconds, keepimage, color)

    if nargin < 4 || isempty(keepimage)
        keepimage = 1;
    end

    keypressed = [];

    tex = showImage(file_image, win);

    if ~tex
        return;
    end
    
    if waitseconds == 0
        [a, keypressed, c] = KbWait;
        WaitSecs(0.5);
    elseif waitseconds > 0
       WaitSecs(waitseconds);
    end

    if ~keepimage
        fill_rects(win, color);
    end
end