% PSYCHTOOLBOX video test: multisensory Action Observation for adults and children (healthy and Cerebral Palsy)
% Author: Alberto Inuggi, November 2013.


clear all 
close all

% =========================================================================
% 1) LOCAL PATHS
% =========================================================================

root_dir = 'C:\Documents and Settings\finisguerra\My Documents\MATLAB\cpchildren';
global_scripts_path='C:\Documents and Settings\finisguerra\My Documents\MATLAB\EEG_tools_svn\global_scripts\';
ptb3_scripts_path=fullfile(global_scripts_path, 'ptb3');

%root_dir = 'X:\projects\cp_action_observation'; % '/data/projects/cp_action_observation';
%global_scripts_path='X:\behavior_lab_svn\behaviourPlatform\EEG_Tools\global_scripts\ptb3'; %'/data/behavior_lab_svn/behaviourPlatform/EEG_Tools/global_scripts/ptb3';

addpath(ptb3_scripts_path);

% =========================================================================
% 2) DATA ACQUISITION OBJECTS
% =========================================================================
% if test ~ 0 run in test modality (without sending values to serial ports), if test==0 active 2 is supposed to be connected
test=0;
if ~test
    ao = analogoutput('winsound');  % set the sound card to load and send audios when required. create an object mapping the soundcard
    set(ao,'TriggerType','Manual'); % set the trigger to manual to use the trigger() and get a faster sound reproduction
    chans = addchannel(ao,1);       %add an audio channel to the sound card to reproduce the sound
    
    dio=digitalio('parallel','LPT1');% crea oggetto porta parallela usando le impostazioni di default
    line=addline(dio,0:7,'out');     % aggiunge una linea dati in output di 8 bit
else
    ao='none';
    chans='none';
    dio='none';
end



try
    
% Check if Psychtoolbox is properly installed:
AssertOpenGL;


% ===================================================================
% 3) STIMULI & TASK DEFINITION 
% ===================================================================
% --- files
video_file={'ctrl01','ctrl02','ctrl03','ctrl04','ctrl05','ctrl06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'};
        
audio_file={'none'      ,'none'      ,'none'      ,'none'      ,'none'      ,'none'       ;...
            'none'      ,'none'      ,'none'      ,'none'      ,'none'      ,'none'       ;...
            'cs01','cs02','cs03','cs04','cs05','cs06'; ...
            'is01','is02','is03','is04','is05','is06'};         

% ===================================================================
% 4) TEMPORAL & GRAPHICS SETTINGS
% ===================================================================

% ==== temporal 
trigger_duration=0.02;  % duration of the trigger in sec. (to avoid trigger overlapping AND trigger detection even subsampling)
sound_frame=45;         % frame at which start audio and send trigger (thought to be 1.5 sec @ 30 fps)
sound_start_onset=1.5;  % latency, within each video, where audio must be triggered

% ==== graphics 
black = [0 0 0];
white = [255 255 255];
dot_size = 4;

% ===================================================================
%  5) OUTPUTS (TRIGGERS)
% ===================================================================
% Control video:                    11,12,13,14,15,16
% action observation (AO):          21,22,23,24,25,26
% AO + congruent audio (AOCS):      31,32,33,34,35,36
% AO + incongruent audio (AOIS):    41,42,43,44,45,46

conditions_triggers_values={11,12,13,14,15,16; ...
            21,22,23,24,25,26; ...
            31,32,33,34,35,36; ...
            41,42,43,44,45,46};

start_experiment_trigger_value = 1;
pause_trigger_value = 2;                    % start: pause, feedback and rest period
resume_trigger_value = 3;                   % end: pause, feedback and rest period
end_experiment_trigger_value = 4;

videoend_trigger_value = 5;
question_trigger_value = 6;
AOCS_audio_trigger_value = 7;
AOIS_audio_trigger_value = 8;
cross_trigger_value = 9;

video_side = 'r';

input_video_folder = fullfile(root_dir, 'video', ['video_' video_side], '');
input_audio_folder = fullfile(root_dir, 'video', 'audio', '');

video_file_extension='.mp4';
audio_file_extension='.wav';

% ===================================================================
% 7) SCREEN SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

%W=800; H=600; rec = [0,0,W,H]; 
rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);

[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
monitor_freq = 1/monitorFlipInterval;

%====================================================================================================================================
% 8) INIT VARS
cross_center = [W/2-12 W/2+12 W/2 W/2; H/2 H/2 H/2-12 H/2+12]; % cross

%====================================================================================================================================

%====================================================================================================================================
trials_list=[1 2 3 4 3 4];
for iter = trials_list

    % draw the cross and wait for half a second
    showCross(window, 0.5, white, 3); 
 
    % 10.2) ========================================= show videos
    switch iter

        case 1
            file_video=fullfile(input_video_folder, [video_files_list{iter,1} video_file_extension]);
            control_trigger_value=conditions_triggers_values{iter,1};
            showMovieTrigger2(file_video, window, dio, control_trigger_value, videoend_trigger_value, test, trigger_duration);

        case 2
            file_video=fullfile(input_video_folder, [video_files_list{iter,1} video_file_extension]);
            AO_trigger_value=conditions_triggers_values{iter,1};
            showMovieTrigger2(file_video, window, dio, AO_trigger_value, videoend_trigger_value, test, trigger_duration);

        case 3
            file_video=fullfile(input_video_folder, [video_files_list{iter,1} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_files_list{iter,1} audio_file_extension]);            
            AOCS_trigger_value=conditions_triggers_values{iter,1};
            showMovieAudioTriggers2(file_video, file_audio, window, dio, AOCS_trigger_value, videoend_trigger_value, sound_start_onset, AOCS_audio_trigger_value, test, trigger_duration, ao);    % also send the frame at which send the second trigger

        case 4
            file_video=fullfile(input_video_folder, [video_files_list{iter,1} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_files_list{iter,1} audio_file_extension]);            
            AOIS_trigger_value=conditions_triggers_values{iter,1};
            showMovieAudioTriggers2(file_video, file_audio, window, dio, AOIS_trigger_value, videoend_trigger_value, sound_start_onset, AOIS_audio_trigger_value, test, trigger_duration, ao);    % also send the frame at which send the second trigger
    end
    

    Screen('FillRect', window, black, rect);
    Screen('Flip', window);
    iti=round(iti_time+rand(1));

end
