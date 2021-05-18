%% function showMovieTrigger(input_file, win, lpt, trigger_start, trigger_end, varargin)
% functions:
% redirect to proper function playing a movie
% sending a trigger at the first & last frames
%
% input_file        file .mat or any other video file
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
% trigger_end:      value of video end trigge
% varargin:         may contain one of the followings: 'rotation', 'output_rect', 'input_rect', 'framerate'

%%
function showMovieTrigger(input_file, win, lpt, trigger_start, trigger_end, varargin)

    if nargin < 5 || isempty(input_file) || win < 1 
        help showMovieTrigger
        disp('current INPUTS:');
        disp(['input_file: ' input_file ', win id: ' win ', varargin: ' varargin{:}]);
        return
    end

    [path, name, ext] = fileparts(input_file);
    
    switch ext
        case '.mat'
            video_mat = load(input_file);
            showMovieFromMatrixTrigger(video_mat, win, lpt, trigger_start, trigger_end, varargin{:});
        otherwise
            showMovieFromVideoTrigger(input_file, win, lpt, trigger_start, trigger_end, varargin{:});
    end
end