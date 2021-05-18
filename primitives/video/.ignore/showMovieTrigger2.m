% functions:
% play a movie
% send a trigger after the Screen('Flip') of the first frame 

% showMovieSendStartTrigger(FILE_VIDEO, WIN, DIO, VIDEO_TRIGGER_VALUE, TEST,DURATION) 
%
% FILE_VIDEO:           full path of the file containing the video to be reproduced
% WIN:                  window where the video is reproduced
% DIO:                  object mapping a parallel port. it has to be previously created by dio=dio=digitalio('parallel','PARALLEL_NAME') 
%                       and initialized by line=addline(dio,0:m,'out'); where m is the number of trigger types - 1
% VIDEO_TRIGGER_VALUE   trigger code corresponding to the video: it should be 2^(n-1) where n is the number of type of the trigger 
% TEST:                 if =1 it enables the test mode (without sending triggers) in case the parallel port is not connected
% DURATION:             required duration of the trigger (to avoid trigger overlapping AND trigger detection even subsampling)

function showMovieTrigger2(moviename, win, dio, startvideo_trigger_value, endvideo_trigger_value, test,duration)

if nargin < 1 || isempty(moviename)
    disp('input file name not specified');
    return
end

try

% Open movie file:
[movie,duration,fps,width,height,count,aspectRatio]=Screen('OpenMovie', win, moviename);

% Start playback engine:
Screen('PlayMovie', movie, 1);

frame=0;

% Playback loop: Runs until end of movie
while frame<(count-1)
    
    frame=frame+1;
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, movie);

    % should never enter the following test as we skipped the last call to
    % Screen('GetMovieImage' as it returns -1 and lasts 3-400 ms
    % Valid texture returned? A negative value means end of movie reached:
    %if tex<=0
        % We're done, break out of loop:
        %break;
    %end;

    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    % Update display:
    Screen('Flip', win);

    if (frame == 1)
        if~test 
            put_trigger(startvideo_trigger_value,dio,duration);
        end
        video_started=1;
    end
    
    % Release texture:
    Screen('Close', tex);
end;

if~test 
    put_trigger(endvideo_trigger_value, dio, duration);
end   

% Stop playback:
Screen('PlayMovie', movie, 0);

% Close movie:
Screen('CloseMovie', movie);

catch
  psychrethrow(psychlasterror);
  sca;
end

return;