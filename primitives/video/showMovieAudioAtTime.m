%% function showMovieAudioAtTime(input_file, file_audio, win, audio_latency, ao, varargin)
% functions:
% play a movie and load a sound (located in a separate file)
% at a specified video time onset
%
% input_file        file .mat or any other video file
% WIN:              window where the video is reproduced
% framerate         display rate
% AUDIO_LATENCY:                latency (in secs) of the video when the audio should be reproduced
% AO:                           object mapping the device used to reproduce the audio. can be a device :instantiated with Data Aquisition Toolbox OR opened and accessed with Psychtoolbox
%                               the object contains:
%                                   - handle
%                                   - num_channels
%                                   - chans     (win)
%                                   - @prepare_playback
%                                   - @trigger_playback
%                                   - @close_sound
% varargin:         may contain one of the followings: 'rotation', 'output_rect', 'input_rect'
%%
function showMovieAudioAtTime(input_file, file_audio, win, audio_latency, ao, varargin)

    if nargin < 2 || isempty(input_file) || isempty(file_audio) || win < 1
        help showMovieAudioAtTime
        disp('current INPUTS:');
        disp(['input_file: ' input_file ', file_audio: ' file_audio ', win id: ' win ',audio_latency: ' audio_latency ', ao: ' ao ', varargin: ' varargin{:}]);
        return
    end

    [path, name, ext] = fileparts(input_file);
    
    switch ext
        case '.mat'
            video_mat = load(input_file);
            showMovieFromMatrixAudioAtTime(video_mat, file_audio, win, audio_latency, ao, varargin{:});
        otherwise
            showMovieFromVideoAudioAtTime(input_file, file_audio, win, audio_latency, ao, varargin{:});
    end
end