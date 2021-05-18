%% function matrix = storeMovie(file_video, win, output_file, varargin)
% functions:
% play a movie
%
% FILE_VIDEO        full path of the video file to be reproduced
% WIN:              window where the video is reproduced
% varargin:         may contain one of the followings: 'rotation', 'output_rect', 'input_rect'

%%
function matrix = storeShowMovie(file_video, win, output_file, varargin)

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

    matrix = cell(1, count);

    % Start playback engine:
    Screen('PlayMovie', movie, 1);

    frame_counter=0;
        
    while 1
        
        frame_counter = frame_counter+1;      
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', win, movie);

        % Valid texture returned? A negative value means end of movie reached:
        if tex<=0
            % We're done, break out of loop:
            break;
        end;

        Screen('DrawTexture', win, tex, input_rect, output_rect, rotation);

        % Update display:
        Screen('Flip', win);
        
        matrix{frame_counter} = Screen('GetImage', win);                ... skip 0 frame
        
        % Release texture:
        Screen('Close', tex);
    end;

    % Stop playback:
    Screen('PlayMovie', movie, 0);

    % Close movie:
    Screen('CloseMovie', movie);

    frames      = frame_counter-1;
    video_name  = file_video;
    
    save(output_file,'video_name');
    save(output_file,'frames', '-append');
    save(output_file,'width', '-append');
    save(output_file,'height', '-append');
    save(output_file,'fps', '-append');
    
    save(output_file,'matrix', '-append');
    
    disp(['stored movie file:' file_video ', composed by ' num2str(frames-1) ' frames']);
    catch
        psychrethrow(psychlasterror);
        sca;
    end
end