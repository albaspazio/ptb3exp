%% function showMovieFromMatrixTrigger(video_mat, win, lpt, trigger_start, trigger_end, varargin)
% functions:
% play a movie
% send a trigger at the first & last frames
%
% matrices          array (height, width, rbg) of uint8
% WIN:              window where the video is reproduced
% framerate         display rate
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
% trigger_end:      value of video end trigge
% varargin:         may contain one of the followings: 'rotation', 'output_rect', 'input_rect'

%%
function showMovieFromMatrixTrigger(video_mat, win, lpt, trigger_start, trigger_end, varargin)

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
        
        if frame_counter == 1
            if ~isempty(lpt)
                lpt.put_trigger(lpt, trigger_start);
            end
        end        

        % Release texture:
        Screen('Close', tex);
    end;

    % send end video trigger
    if ~isempty(lpt)
        lpt.put_trigger(lpt, trigger_end);
    end
    
    catch
        psychrethrow(psychlasterror);
        sca;
    end
end