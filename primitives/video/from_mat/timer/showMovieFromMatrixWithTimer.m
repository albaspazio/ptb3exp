%% function showMovieFromMatrixWithTimer(video_mat, win, varargin)
% functions:
% play a movie previously stored in a custom mat file created by the function "storeMovie" and display each frame with a timer function
% in this case the function WON'T BLOCK the code execution.
% it display the first frame in the StartFcn then it executes the TimerFcn for (numframes-1) times
%
% video_mat         structure containing the following fields:
%                       - frames:     number of frame in the video
%                       - fps:        original frame rate. NOTE: can be overwritten with a varargin param
%                       - matrix:     array (height, width, rbg) of uint8
%                       - width & heigth
%
% WIN:              window where the video is reproduced
% varargin:         may contain one of the followings: 'rotation', 'output_rect', 'input_rect', 'sound_obj=(ao, audio_frame, audio_file)'
% AO                object mapping the device used to reproduce the audio. can be a device :instantiated with Data Aquisition Toolbox OR opened and accessed with Psychtoolbox
%                   the object contains:
%                       - handle
%                       - num_channels
%                       - chans     (win)
%                       - @prepare_playback
%                       - @trigger_playback
%                       - @close_sound

%%
function showMovieFromMatrixWithTimer(file_video, win, varargin)
    
    global video_mat;
     
    video_mat        = load(file_video);
    
    if nargin < 1 || isempty(video_mat)
        if video_mat.frames < 1
            disp('frames number is zero');
        end
        if isempty(video_mat.matrix)
            disp('input matrix is empty');
        end
        help showMovieFromMatrixWithTimer
        return
    end

    % ----------------------------------------------------------------------
    nvararg=length(varargin);
    % default
    params.rotation         = 0;
    params.output_rect      = [];
    params.input_rect       = [];
    sound_obj               = []; 
    trigger_obj             = [];
    
    for var=1:2:nvararg
        switch varargin{var}
            case 'rotation'
                params.rotation     = varargin{var+1};
            case 'output_rect'
                params.output_rect  = varargin{var+1};        
            case 'input_rect'
                params.input_rect   = varargin{var+1};        
            case 'framerate'
                params.framerate    = varargin{var+1};        
            case 'sound_obj'
                sound_obj           = varargin{var+1}; 
            case 'trigger_obj'
                trigger_obj         = varargin{var+1};                  
            case 'end_callback'
                params.end_callback = varargin{var+1};                  
        end
    end
    % ----------------------------------------------------------------------
    % VIDEO
    params.framerate    = video_mat.fps;
    params.ifi          = round((1/params.framerate)*1000)/1000;

    params.win          = win;
    ...params.matrices     = video_mat.matrix;
    params.tot_frames   = length(video_mat.matrix);
    
    % ----------------------------------------------------------------------
    % TRIGGER
    params.lpt = [];
    if not(isempty(trigger_obj))
        
        params.lpt             = trigger_obj.lpt;
        params.trigger_start   = trigger_obj.trigger_start;
        params.trigger_end     = trigger_obj.trigger_end;
        if isfield(sound_obj, 'trigger_sound')
            params.trigger_sound = sound_obj.trigger_sound;
        end
    end    
    
    % ----------------------------------------------------------------------
    % SOUND
    params.can_trigger_audio    = 0; 
    params.sound_frame          = 0;
    
    if not(isempty(sound_obj))
        params.can_trigger_audio    = 1; 
        params.ao                   = sound_obj.ao;
        
        % check that either audio_frame OR audio_time is present and > 0...only one of them must be valid
        if isfield(sound_obj, 'audio_frame'), if sound_obj.audio_frame, sframe_ok = 1; else sframe_ok = 0; end
        else sframe_ok = 0; 
        end

        if isfield(sound_obj, 'audio_time'), if sound_obj.audio_time  , stime_ok = 1;  else stime_ok = 0;  end
        else stime_ok = 0;  
        end

        if stime_ok && not(sframe_ok),     params.sound_frame = round(sound_obj.audio_time*video_mat.fps);
        elseif not(stime_ok) && sframe_ok, params.sound_frame = sound_obj.audio_frame;
        else                               error('showMovieFromMatrix: you must specify at least one valid audio_time or audio_frame parameter'); 
        end        
        params.ao.prepare_playback(sound_obj.ao.handle, sound_obj.audio_file);
    end
    
    timer_id            = timer( 'name', 'video_timer','Period', params.ifi, 'StartDelay', 0, 'TasksToExecute', params.tot_frames-1, 'BusyMode','drop','ExecutionMode','fixedRate');
    timer_id.TimerFcn   = {@cbkOnFrame, params};
    timer_id.StopFcn    = {@cbkOnStop, params};
    timer_id.StartFcn   = {@cbkOnStart, params};
    
    start(timer_id);         

end
% =====================================================================================================================
% =====================================================================================================================
% =====================================================================================================================
% =====================================================================================================================
% =====================================================================================================================
function cbkOnStart(obj, event, params)
    global video_mat;
    ...disp(['cbkOnStart:' num2str(params.framerate)]);
    showFrame(video_mat.matrix{1}, params);
    
end
% ----------------------------------------------------------------------
function cbkOnStop(obj, event, params)
    ...disp(['cbkOnStop']);
    stop(obj);
    clearvars -global video_mat;
    if isfield(params, 'end_callback')
       params.end_callback(params);
    end
end
% ----------------------------------------------------------------------
function cbkOnFrame(obj, event, params)
    global video_mat;
    frame_counter = obj.TasksExecuted + 1;

    ...disp(['cbkOnFrame:' num2str(frame_counter)]);
    
    if isempty(video_mat.matrix{frame_counter}) 
        cbkOnStop(obj, event, params);
    else
        showFrame(video_mat.matrix{frame_counter}, params);
    end
    
    if (frame_counter == params.sound_frame)
        params.ao.trigger_playback(params.ao.handle);
        params.can_trigger_audio = 0;
    end
end
% ----------------------------------------------------------------------
function showFrame(frame_matrix, params)

    try
        % make texture from input matrix
        tex = Screen('MakeTexture', params.win, frame_matrix);  if tex<=0, return; end;
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', params.win, tex, params.input_rect, params.output_rect, params.rotation);
        % Update display:
        Screen('Flip', params.win);

        Screen('Close', tex);
    catch err
        err
    end
end
% ----------------------------------------------------------------------