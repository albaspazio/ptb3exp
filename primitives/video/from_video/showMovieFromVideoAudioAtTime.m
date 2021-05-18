%% showMovieFromVideoAudioDatAtTime(file_video, file_audio, win, audio_latency, ao, varargin)
% functions:
% play a movie and load a sound (located in a separate file)
% at a specified video time onset
%
% FILE_VIDEO and FILE_AUDIO:    respective full paths of the files containing the video and the audio (supposed to be in .wav format) to be reproduced
% WIN:                          window where the video is reproduced
% AUDIO_LATENCY:                latency (in secs) of the video when the audio should be reproduced
% AO:                           object mapping the device used to reproduce the audio. can be a device :instantiated with Data Aquisition Toolbox OR opened and accessed with Psychtoolbox
%                               the object contains:
%                                   - handle
%                                   - num_channels
%                                   - chans     (win)
%                                   - @prepare_playback
%                                   - @trigger_playback
%                                   - @close_sound
% varargin:                     may contain one of the followings: 'rotation', 'output_rect', 'input_rect'

%%
function showMovieFromVideoAudioAtTime(file_video, file_audio, win, audio_latency, ao, varargin)

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
                rotation=varargin{var+1};
            case 'output_rect'
                output_rect=varargin{var+1};        
            case 'input_rect'
                input_rect=varargin{var+1};        
        end
    end
    % ----------------------------------------------------------------------
    
    try

    ao.prepare_playback(ao.handle, file_audio);
    
    % Open movie file:
    [movie,duration,fps,width,height,count,aspectRatio]=Screen('OpenMovie', win, file_video);

    % Start playback engine:
    Screen('PlayMovie', movie, 1);

    start_time          = GetSecs;
    can_trigger_audio   = 1;
    frame_counter       = 0;

    % Playback loop: Runs until end of movie or keypress:
    while 1 ...frame_counter<(count-1)

        frame_counter=frame_counter+1;
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

        if can_trigger_audio
            if ( (GetSecs-start_time) >= audio_latency)
                ao.trigger_playback(ao.handle); ... reproduce audio pre-loaded in the sound card
                can_trigger_audio=0;
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
end