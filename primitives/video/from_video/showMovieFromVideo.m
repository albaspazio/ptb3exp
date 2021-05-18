%% function showMovieFromMatrix(video_mat, win, varargin)
% functions:
% play a movie previously stored in a custom mat file created by the function "storeMovie"
% can also playback a sound at a specific frame
%
% video_mat         structure containing the following fields:
%                       frames:     number of frame in the video
%                       fps:        original frame rate. NOTE: can be overwritten with a varargin param
%                       matrix:     array (height, width, rbg) of uint8
%                       width & heigth
% WIN:              window where the video is reproduced
% varargin:         may contain one of the followings: 'rotation', 'output_rect', 'input_rect','sound_obj=(ao, audio_frame/audio_time, audio_file, trigger_sound)', trigger_obj=(lpt,trigger_start, trigger_end)
%
% sound_obj.ao      object mapping the device used to reproduce the audio. can be a device :instantiated with Data Aquisition Toolbox OR opened and accessed with Psychtoolbox
%                   the object contains:
%                       - handle
%                       - num_channels
%                       - chans     (win)
%                       - @prepare_playback
%                       - @trigger_playback
%                       - @close_sound
%
% trigger_obj.lpt:  object containing the following fields:
%                       - data_address
%                       - status_address
%                       - control_address
%                       - trigger_duration
%                       - @put_trigger
%                       - @io_obj         (win)
%                       - instance        (win)
%                       - status          (win)
%                       - portnum         (linux)

%%
function showMovieFromVideo(file_video, win, varargin)

    if nargin < 1 || isempty(file_video)
        disp('input file name not specified');
        help showMovieFromMatrix
        return
    end

    % ----------------------------------------------------------------------
    % check if filename and dropframe differ from standard values
    nvararg=length(varargin);
    
    % default
    rotation        = 0;
    output_rect     = [];
    input_rect      = [];
    sound_obj       = [];
    trigger_obj     = [];
    
    for var=1:2:nvararg
        switch varargin{var}
            case 'rotation'
                rotation=varargin{var+1};
            case 'output_rect'
                output_rect=varargin{var+1};        
            case 'input_rect'
                input_rect=varargin{var+1};   
            case 'sound_obj'
                sound_obj   = varargin{var+1};                 
            case 'trigger_obj'
                trigger_obj = varargin{var+1};                  
        end
    end
    % ----------------------------------------------------------------------
    % ----------------------------------------------------------------------
    % SOUND
    sound_frame         = 0;
    can_trigger_audio   = 0; 
    if not(isempty(sound_obj))
        ao = sound_obj.ao;
        
        % check that either audio_frame OR audio_time is present and > 0...only one of them must be valid
        if isfield(sound_obj, 'audio_frame'), if sound_obj.audio_frame, sframe_ok = 1; else sframe_ok = 0; end
        else sframe_ok = 0; 
        end

        if isfield(sound_obj, 'audio_time'), if sound_obj.audio_time  , stime_ok = 1;  else stime_ok = 0;  end
        else stime_ok = 0;  
        end

        if stime_ok && not(sframe_ok),     sound_frame = round(sound_obj.audio_time*framerate);
        elseif not(stime_ok) && sframe_ok, sound_frame = sound_obj.audio_frame;
        else                               error('showMovieFromMatrix: you must specify at least one valid audio_time or audio_frame parameter'); 
        end
        
        ao.prepare_playback(ao.handle, sound_obj.audio_file);
        can_trigger_audio = 1;
    end
    % ----------------------------------------------------------------------
    % TRIGGER
    lpt = [];
    if not(isempty(trigger_obj))
        
        lpt             = trigger_obj.lpt;
        trigger_start   = trigger_obj.trigger_start;
        trigger_end     = trigger_obj.trigger_end;
        if isfield(sound_obj, 'trigger_sound')
            trigger_sound = sound_obj.trigger_sound;
        end
    end    
    % ----------------------------------------------------------------------
    
    try

        % Open movie file:
        [movie,duration,fps,width,height,count,aspectRatio] = Screen('OpenMovie', win, file_video);

        % Start playback engine:
        Screen('PlayMovie', movie, 1);

        frame_counter=0;

        % Playback loop: Runs until end of movie
        while 1 ...frame_counter<(count-1)

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

            % send end video trigger
            if ~isempty(lpt)
                if frame_counter == 1
                    lpt.put_trigger(lpt, trigger_start);
                end
            end   

            if frame_counter >= sound_frame && can_trigger_audio
                ao.trigger_playback(ao.handle);
                can_trigger_audio = 0;
                if ~isempty(lpt)
                    lpt.put_trigger(lpt, trigger_sound);
                end 
            end        

            % Release texture:
            Screen('Close', tex);
        end;

        % send end video trigger
        if ~isempty(lpt)
            lpt.put_trigger(lpt, trigger_end);
        end 

        % Stop playback:
        Screen('PlayMovie', movie, 0);

        % Close movie:
        Screen('CloseMovie', movie);

    catch
        psychrethrow(psychlasterror);
        sca;
    end
end