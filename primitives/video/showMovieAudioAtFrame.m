%% function showMovieAudioAtFrame(input_file, file_audio, win, audio_frame, ao, varargin)
% functions:
% redirect to proper function playing a movie and a sound (located in a separate file)
% at a specified frame
%
% input_file        file .mat or any other video file
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
function showMovieAudioAtFrame(input_file, file_audio, win, audio_frame, ao, varargin)

    if nargin < 2 || isempty(input_file) || isempty(file_audio) || win < 1
        help showMovieAudioAtFrame
        disp('current INPUTS:');
        disp(['input_file: ' input_file ', file_audio: ' file_audio ', win id: ' win ',audio_frame: ' audio_frame ', ao: ' ao ', varargin: ' varargin{:}]);
        return
    end

    [path, name, ext] = fileparts(input_file);
    
    switch ext
        case '.mat'
            video_mat = load(input_file);
            showMovieFromMatrixAudioAtFrame(video_mat, file_audio, win, audio_frame, ao, varargin{:});
        otherwise
            showMovieFromVideoAudioAtFrame(input_file, file_audio, win, audio_frame, ao, varargin{:});
    end
end