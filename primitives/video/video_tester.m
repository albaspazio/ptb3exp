% PSYCHTOOLBOX video test: multisensory Action Observation for adults and children (healthy and Cerebral Palsy)
% Author: Alberto Inuggi, November 2013.



debug = 1;
root_path = '\\VBOXSVR\data';
root_path = 'E:\Matlab';
...root_path = '/data';

% =========================================================================
global_scripts_path = fullfile(root_path, 'behavior_lab_svn', 'behaviourPlatform','CommonScript');

ptb3_scripts_path   = fullfile(global_scripts_path, 'ptb3');
addpath(genpath2(ptb3_scripts_path));


input_video_folder = fullfile(root_path, 'projects','PAP','experiments','ao_eeg','resources','video','video_l');
input_audio_folder = fullfile(root_path, 'projects','PAP','experiments','ao_eeg','resources','audio');

video_file_extension='.mat';
audio_file_extension='.wav';

% ===================================================================
video_list      = {'ao01','ao02','ao03','ao04','ao05','ao06'}; ...,'ctrl02','ctrl03','ctrl04','ctrl05','ctrl06'}; 
audio_list      = {'cs01','cs02','cs03','cs04','cs05','cs06'}; 
triggers_list   = {11,12,13,14,15,16}; 

nvideo = length(video_list);
% ===================================================================
% TEMPORAL & GRAPHICS SETTINGS
% ===================================================================

% ==== temporal 
sound_frame         = 45;   % frame at which start audio and send trigger (thought to be 1.5 sec @ 30 fps)
sound_start_onset   = 1.5;  % latency, within each video, where audio must be triggered

% ==== graphics 
black       = [0 0 0];
white       = [255 255 255];
dot_size    = 4;

try
    % Check if Psychtoolbox is properly installed:
    AssertOpenGL;

    % ===================================================================
    % AUDIO SETTINGS
    % ===================================================================
    InitializePsychSound;
    PsychPortAudio('Close');

    audio_obj.num_channels            = 2;
    audio_obj.fc                      = 44100;

    handles                           = get_inout_sound_devices(audio_obj.fc, audio_obj.num_channels); 
    audio_obj.device_id               = handles(1).DeviceIndex;

    ...audio_obj.device_id               = 8;  ... 8 is front audio of alberto linux

    audio_obj.handle              = PsychPortAudio('Open', audio_obj.device_id, 1, 0, audio_obj.fc, audio_obj.num_channels);
    audio_obj.prepare_playback    = @prepare_sound_playback_ptb;    
    audio_obj.trigger_playback    = @trigger_sound_playback_ptb;    
    audio_obj.close               = @close_sound_ptb;

    trigger_obj                   = [];
    % ===================================================================
    % SCREEN SETTINGS
    % ===================================================================
    Screen('Preference', 'SkipSyncTests', 0);
    Screen('Preference', 'SuppressAllWarnings', 0);

    if debug
        W1=640; H1=480; rec1 = [0,0,W1,H1]; 
        ...W2=800; H2=600; rec2 = [W1,0,W1+W2,H2]; 
    else
        rec1 = Screen('Rect',0); [W1, H1]=Screen('WindowSize', 0);
        ...rec2 = Screen('Rect',0); [W2, H2]=Screen('WindowSize', 2);
    end

    [window1, rect1]      = Screen('OpenWindow', 0, black, rec1);
    ...[window2, rect2]      = Screen('OpenWindow', 0, black, rec2);
    monitorFlipInterval = Screen('GetFlipInterval', window1);
    monitor_freq        = 1/monitorFlipInterval;

    %====================================================================================================================================
    % 8) INIT VARS
    cross_center = [W1/2-12 W1/2+12 W1/2 W1/2; H1/2 H1/2 H1/2-12 H1/2+12]; % cross

    %====================================================================================================================================

    %====================================================================================================================================
    sound_obj.ao            = audio_obj;
    
    curr_video = 1;

    file_video              = fullfile(input_video_folder, [video_list{curr_video} video_file_extension]);
    file_audio              = fullfile(input_audio_folder, [audio_list{curr_video} audio_file_extension]);
    trigger_value           = triggers_list{curr_video};
    
    sound_obj.audio_file    = file_audio;
    sound_obj.audio_frame   = 45; ...floor(video_matrix.frames/2);
    
    testvideotimer(window1, file_video, trigger_value, sound_obj, trigger_obj);
    
    
    
%     showCross(window1, 0, white, 3);        ... showCross(window2, 0, white, 3); 
%     WaitSecs(0.5);
% 
%     file_video              = fullfile(input_video_folder, [video_list{1} video_file_extension]);
%     file_audio              = fullfile(input_audio_folder, [audio_list{1} audio_file_extension]);
%     trigger_value           = triggers_list{1};
% 
%     sound_obj.audio_file    = file_audio;
%     sound_obj.audio_frame   = 45; ...floor(video_matrix.frames/2);
%     sound_obj.ao            = audio_obj;
% 
%     ...showMovieFromMatrixWithTimer(file_video, window1, 'sound_obj', sound_obj, 'end_callback', @onNextVideo);
%     video = cShowMovieTimer(file_video, window1, 'sound_obj', sound_obj, 'end_callback', @onNextVideo);

catch err
    err.message
    err.stack(1).name
    err.stack(1).line
end
