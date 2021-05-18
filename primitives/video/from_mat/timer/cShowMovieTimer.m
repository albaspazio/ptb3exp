%% class cShowMovieTimer(file_video, win, varargin)
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
classdef cShowMovieTimer < handle
    
    properties (SetAccess = protected)
        scope               = 'cShowVideoTimer';
        file_video          = '';
        tot_frames          = 0;
        frame_counter       = 0;
        framerate           = 0;
        ifi                 = 0;
        rotation            = 0;
        output_rect         = [];
        input_rect          = [];
        sound_frame         = 0;
        auto_play           = 1;
    end
        
    properties (Access = protected)
        can_trigger_audio   = 0;
        video_mat           = [];
        win                 = 0;
        timer_id            = [];
        end_callback        = [];
        start_frame         = 1;
        
        lpt                 = [];
        trigger_start       = 0;
        trigger_end         = 0;
        trigger_sound       = 0;
        ao                  = [];
        caller
    end
    
    
    methods
        function this = cShowMovieTimer(file_video, win, varargin)
            
            % check input params
            if isempty(file_video) || win < 1 || not(exist(file_video, 'file'))
                help cShowMovieTimer
                return
            end
            
            this.file_video     = file_video;
            this.win            = win;
            
            this.video_mat      = load(file_video);
            if isempty(this.video_mat.matrix)
                disp('input matrix is empty');
            end
            
            this.tot_frames     = this.video_mat.frames;
            if this.tot_frames < 1
                disp('frames number is zero');
            end

            this.framerate      = this.video_mat.fps;
            this.ifi            = round((1/this.framerate)*1000)/1000;
            
            % ----------------------------------------------------------------------
            trigger_obj         = [];
            sound_obj           = [];
            % ----------------------------------------------------------------------
            nvararg=length(varargin);
            for var=1:2:nvararg
                switch varargin{var}
                    case 'auto_play'
                        this.auto_play      = varargin{var+1};
                    case 'start_frame'
                        this.start_frame    = varargin{var+1};
                    case 'rotation'
                        this.rotation       = varargin{var+1};
                    case 'output_rect'
                        this.output_rect    = varargin{var+1};        
                    case 'input_rect'
                        this.input_rect     = varargin{var+1};        
                    case 'framerate'
                        this.framerate      = varargin{var+1};        
                    case 'sound_obj'
                        sound_obj           = varargin{var+1}; 
                    case 'trigger_obj'
                        trigger_obj         = varargin{var+1};                  
                    case 'end_callback'
                        this.end_callback   = varargin{var+1};                  
                end
            end
            
            % ----------------------------------------------------------------------
            % TRIGGER
            this.lpt = [];
            if not(isempty(trigger_obj))

                this.lpt                = trigger_obj.lpt;
                this.trigger_start      = trigger_obj.trigger_start;
                this.trigger_end        = trigger_obj.trigger_end;
                if isfield(sound_obj, 'trigger_sound')
                    this.trigger_sound = sound_obj.trigger_sound;
                end
                
            end    
            % ----------------------------------------------------------------------
            % SOUND
            this.can_trigger_audio    = 0; 
            this.sound_frame          = 0;

            if not(isempty(sound_obj))
                this.can_trigger_audio    = 1; 
                this.ao                   = sound_obj.ao;

                % check that either audio_frame OR audio_time is present and > 0...only one of them must be valid
                if isfield(sound_obj, 'audio_frame'), if sound_obj.audio_frame, sframe_ok = 1; else sframe_ok = 0; end
                else sframe_ok = 0; 
                end

                if isfield(sound_obj, 'audio_time'), if sound_obj.audio_time  , stime_ok = 1;  else stime_ok = 0;  end
                else stime_ok = 0;  
                end

                if stime_ok && not(sframe_ok),     this.sound_frame = round(sound_obj.audio_time*this.video_mat.fps);
                elseif not(stime_ok) && sframe_ok, this.sound_frame = sound_obj.audio_frame;
                else                               error('showMovieFromMatrix: you must specify at least one valid audio_time or audio_frame parameter'); 
                end        
                this.ao.prepare_playback(this.ao.handle, sound_obj.audio_file);
            end
            % ----------------------------------------------------------------------
            this.StartAtFrame(this.start_frame, this.auto_play);
        end
        % --------------------------------------------------------------------------------------------------------------
        function frame = Pause(this)
            stop(this.timer_id);
            frame = this.frame_counter;
        end
        % --------------------------------------------------------------------------------------------------------------
        function frame = Resume(this)
            StartAtFrame(this.frame_counter, 1);
            frame = this.frame_counter;
        end
        % --------------------------------------------------------------------------------------------------------------
        function StartAtFrame(this, frame, auto_start)
            this.start_frame = frame;
            this.timer_id = timer('name', 'video_timer','Period', this.ifi, 'StartDelay', 0, 'TasksToExecute', this.tot_frames-this.start_frame, 'BusyMode','drop','ExecutionMode','fixedRate' ...
                                  ,'TimerFcn', @this.cbkOnFrame, 'StopFcn', @this.cbkOnStop, 'StartFcn', @this.cbkOnStart);

            if auto_start
                start(this.timer_id);         
            end
        end
        % --------------------------------------------------------------------------------------------------------------
        % END PUBLIC METHODS
        % --------------------------------------------------------------------------------------------------------------
    end
    
    %% ================================================================================================================================================================================
    % P R O T E C T E D   M E M B E R S
    %  ================================================================================================================================================================================ 
    methods (Access = protected)        
        
        function cbkOnStart(this, obj, event)
            this.showFrame(this.video_mat.matrix{this.start_frame});
            if not(isempty(this.lpt))
                this.lpt.instance.SendMarker(this.trigger_start);
                ...this.lpt.put_trigger(this.lpt, this.trigger_start);
            end            
        end
        % ----------------------------------------------------------------------
        function cbkOnStop(this, obj, event)
            
            if not(isempty(this.lpt))
                this.lpt.instance.SendMarker(this.trigger_end);
                ....this.lpt.put_trigger(this.lpt, this.trigger_start);
            end             
            ...disp(['cbkOnStop']);
            stop(obj);
            delete(obj);
            clear obj;
            
            clearvars this.video_mat;
            if not(isempty(this.end_callback))
               this.end_callback(this);
            end
        end
        % ----------------------------------------------------------------------
        function cbkOnFrame(this, obj, event)

            this.frame_counter = obj.TasksExecuted + this.start_frame;

            if isempty(this.video_mat.matrix{this.frame_counter}) 
                this.cbkOnStop(obj, event);
            else
                this.showFrame(this.video_mat.matrix{this.frame_counter});
            end

            if (this.frame_counter == this.sound_frame)
                this.ao.trigger_playback(this.ao.handle);
                this.can_trigger_audio = 0;
            
                if not(isempty(this.lpt))
                    ....this.lpt.put_trigger(this.lpt, this.trigger_sound);
                    this.lpt.instance.SendMarker(this.trigger_sound);
                end
            end
        end
        % ----------------------------------------------------------------------
        function showFrame(this, frame_matrix)
            try
                % make texture from input matrix
                tex = Screen('MakeTexture', this.win, frame_matrix);  if tex<=0, return; end;
                % Draw the new texture immediately to screen:
                Screen('DrawTexture', this.win, tex, this.input_rect, this.output_rect, this.rotation);
                % Update display:
                Screen('Flip', this.win);

                Screen('Close', tex);
            catch err
                err
            end
        end
        % ----------------------------------------------------------------------
    end
end