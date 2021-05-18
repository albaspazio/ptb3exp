% functions:
% play a movie

% showMovie(FILE_VIDEO, WIN) where 
%
% FILE_VIDEO and FILE_AUDIO:    respective full paths of the files containing the video and the audio (supposed to be in .wav format) to be reproduced
% WIN:                          window where the video is reproduced

function keypressed = showImageNseconds(file_image, win, waitseconds)

if nargin < 1 || isempty(file_image)
    disp('input file name not specified');
    return
end

try

    tex = Screen('MakeTexture',win, imread(file_image));
    Screen('DrawTexture', win, tex)    
    Screen('Flip',win);
    if waitseconds == 0
        [a, keypressed, c] = KbWait;
        WaitSecs(0.5);
    else
       WaitSecs(waitseconds);
    end
    Screen('Close', tex);
    
catch
  psychrethrow(psychlasterror);
end

return;