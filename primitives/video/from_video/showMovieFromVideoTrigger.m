%% function showMovieFromVideoTrigger(file_video, win, lpt, trigger_start, trigger_end, varargin)
% functions:
% play a movie
% send a trigger at the first and after last frame
%
% FILE_VIDEO        full path of the video file to be reproduced
% WIN:              window where the video is reproduced
% lpt:              object containing the following fields:
%                       - data_address
%                       - status_address
%                       - control_address
%                       - trigger_duration
%                       - @put_trigger
%                       - @io_obj         (win)
%                       - instance        (win)
%                       - status          (win)
%                       - portnum         (linux)
% trigger_start:    value of video start trigger
% trigger_end:      value of video end trigger
% varargin:         may contain one of the followings: 'rotation', 'output_rect', 'input_rect'

%%
function showMovieFromVideoTrigger(file_video, win, lpt, trigger_start, trigger_end, varargin)

    if nargin < 1 || isempty(file_video)
        disp('input file name not specified');
        return
    end

    % ----------------------------------------------------------------------
    % check if filename and dropframe differ from standard values
    nvararg=length(varargin);
    % default
    rotation        = 0;
    output_rect     = [];
    input_rect      = [];
    for var=1:2:nvararg
        switch varargin{var}
            case 'rotation'
                rotation    = varargin{var+1};
            case 'output_rect'
                output_rect = varargin{var+1};        
            case 'input_rect'
                input_rect  = varargin{var+1};        
        end
    end
    % ----------------------------------------------------------------------

    try

    % Open movie file:
    [movie, duration, fps, width, height, count, aspectRatio] = Screen('OpenMovie', win, file_video);

    % Start playback engine:
    Screen('PlayMovie', movie, 1);

    frame_counter=0;
    
    % Playback loop: Runs until end of movie or keypress:
    while 1 ...frame_counter<(count-2)
        
        frame_counter = frame_counter+1;      
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', win, movie);

        % should never enter the following test as we skipped the last call to
        % Screen('GetMovieImage' as it returns -1 and lasts 3-400 ms
        % Valid texture returned? A negative value means end of movie reached:
        if tex<=0
            % We're done, break out of loop:
            break;
        end;
        
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', win, tex, input_rect, output_rect, rotation);

        % Update display:
        Screen('Flip', win);

        if frame_counter == 1
            if ~isempty(lpt)
                lpt.put_trigger(lpt, trigger_start);
            end
        end
        % Release texture:
        Screen('Close', tex);
    end;

    % Stop playback:
    Screen('PlayMovie', movie, 0);

    % send end video trigger
    if ~isempty(lpt)
        lpt.put_trigger(lpt, trigger_end);
    end
    
    % Close movie:
    Screen('CloseMovie', movie);

    catch
        psychrethrow(psychlasterror);
        sca;
    end
end