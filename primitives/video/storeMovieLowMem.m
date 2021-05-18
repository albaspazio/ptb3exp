%% function matrix = storeMovieLowMem(file_video, win, outmat, varargin)
% functions:
% play a movie
%
% FILE_VIDEO        full path of the video file to be reproduced
% WIN:              window where the video is reproduced
% varargin:         may contain one of the followings: 'rotation', 'output_rect', 'input_rect'

%%
function matrix = storeMovieLowMem(file_video, win, output_file, varargin)

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
    % Open movie file:
    [movie,duration,fps,width,height,count,aspectRatio] = Screen('OpenMovie', win, file_video);

    matrix = zeros(height, width,3);

    % Start playback engine:
    Screen('PlayMovie', movie, 1);

    frame_counter=0;
        
    % Playback loop: Runs until end of movie or keypress:
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

        variable = sprintf('frame_%d',frame_counter);
        str=[variable '= Screen(''GetImage'', tex);' ]; eval(str);
        str=['save(output_file, ''' variable ''', ''-append'')']; eval(str);

        % Release texture:
        Screen('Close', tex);
    end;
    
    frames = frame_counter-1;

    % Stop playback:
    Screen('PlayMovie', movie, 0);

    % Close movie:
    Screen('CloseMovie', movie);

    video_name  = file_video;
    
    save(output_file,'video_name');
    save(output_file,'frames', '-append'); 
    save(output_file,'width', '-append');
    save(output_file,'height', '-append');
    save(output_file,'fps', '-append');
    
    catch
        psychrethrow(psychlasterror);
        sca;
    end
end
