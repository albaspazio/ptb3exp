% functions:
% play a movie

% showMovie(FILE_VIDEO, WIN) where 
%
% FILE_VIDEO and FILE_AUDIO:    respective full paths of the files containing the video and the audio (supposed to be in .wav format) to be reproduced
% WIN:                          window where the video is reproduced

function showMovieDeliverStimuli(file_video, win, stim_type, latency_interval, varargin)

if nargin < 1 || isempty(file_video)
    disp('input file name not specified');
    return
end


% ----------------------------------------------------------------------
% check if filename and dropframe differ from standard values
nvararg=length(varargin);
% default
rotation=0;
output_rect=[];
input_rect=[];
for var=1:2:nvararg
    switch varargin{var}
        case 'rotation'
        rotation=varargin{var+1};
        case 'output_rect'
        output_rect=varargin{var+1};        
        case 'input_rect'
        input_rect=varargin{var+1};        
    end
end
% ----------------------------------------------------------------------

try

% Open movie file:
movie = Screen('OpenMovie', win, file_video);

% Start playback engine:
Screen('PlayMovie', movie, 1);

start=GetSecs;

% Playback loop: Runs until end of movie or keypress:
while 1
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, movie);

    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end;

    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex, input_rect, output_rect, rotation);

    % Update display:
    Screen('Flip', win);
    
    elapsed = GetSecs-start;
    if elapsed > latency_interval
        ... apply stimuli
        switch stim_type
            case 1

            case 2

            case 3
        end
    end    
    
    
    % Release texture:
    Screen('Close', tex);
end;

% Stop playback:
Screen('PlayMovie', movie, 0);

% Close movie:
Screen('CloseMovie', movie);

catch
  psychrethrow(psychlasterror);
  sca;
end

return;