%% function showMovieTimer(input_file, win, framerate, varargin)
% functions:
% redirect to proper function playing a movie
%
% input_file        file .mat or any other video file
% WIN:              window where the video is reproduced
% varargin:         may contain one of the followings: 'rotation', 'output_rect', 'input_rect', 'framerate'

%%
function showMovieTimer(input_file, win, varargin)

    if nargin < 2 || isempty(input_file) || win < 1 || not(exist(input_file, 'file'))
        help showMovieTimer
        disp('current INPUTS:');
        disp(['input_file: ' input_file ', win id: ' win]);
        return
    end
    
    [path, name, ext] = fileparts(input_file);
    
    nv = length(varargin);
    varargin{nv+1} = 'internal_callback';
    varargin{nv+2} = @onEndVideo;
    
    ...video_mat = load(input_file);
    showMovieFromMatrixWithTimer(input_file, win, varargin{:});
    
end

function onEndVideo()

end