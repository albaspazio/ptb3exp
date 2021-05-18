%% function showMovieFromMatrixAudioAtFrame(video_mat, file_audio, win, audio_frame, ao, varargin)
% functions:
% play a movie and load a sound (located in a separate file)
% at a specified frame
%
% matrices          array (height, width, rbg) of uint8
% FILE_AUDIO:       full paths of the files containing the audio (supposed to be in .wav format) to be reproduced
% WIN:              window where the video is reproduced
% framerate         display rate
% AUDIO_FRAME:      frame of the video when the audio should be reproduced
% AO:               object mapping the device used to reproduce the audio. can be a device :instantiated with Data Aquisition Toolbox OR opened and accessed with Psychtoolbox
%                   the object contains:
%                       - handle
%                       - num_channels
%                       - chans     (win)
%                       - @prepare_playback
%                       - @trigger_playback
%                       - @close_sound
% varargin:         may contain one of the followings: 'rotation', 'output_rect', 'input_rect'
%
%%
function showMovieFromMatrixAudioAtFrame(video_mat, file_audio, win, audio_frame, ao, varargin)

    if nargin < 1 || isempty(video_mat)
        disp('input matrix is empty');
        return
    end

    framerate   = video_mat.fps;
    matrices    = video_mat.matrix;    
    tot_frames  = length(matrices); ...video_mat.frames;
    
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
            case 'framerate'
                framerate=varargin{var+1};        
        end
    end
    % ----------------------------------------------------------------------

    try

    ao.prepare_playback(ao.handle, file_audio);
        
    ifi         = Screen('GetFlipInterval', win); 
    skip_flip   = (1/framerate)/ifi; 
    vlb         = Screen('Flip', win);
       
    % Playback loop: Runs until end of movie
    for frame_counter=1:tot_frames
        
        if isempty(matrices{frame_counter}) 
            break;
        end
            
        % make texture from input matrix
        tex = Screen('MakeTexture', win, matrices{frame_counter}); 
        
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', win, tex, input_rect, output_rect, rotation);

        % Update display:
        vlb = Screen('Flip', win, vlb + (skip_flip - 0.5)*ifi);
        
        if (frame_counter == audio_frame)   
            ao.trigger_playback(ao.handle);   ... reproduce audio pre-loaded in the sound card
        end        

        % Release texture:
        Screen('Close', tex);
    end;

    catch
        psychrethrow(psychlasterror);
        sca;
    end
end