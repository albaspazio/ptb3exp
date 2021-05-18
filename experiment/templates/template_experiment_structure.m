%% ===================================================================
% 1) STRING DEFINITION 
% ===================================================================
experiment.text.pre_samplevideos            ='Preparati! ti mostreremo alcuni video di esempio\n\n\n'; ...'Get ready! we'll show you some sample video\n\n\n'
experiment.text.letsgo                      = 'Cominciamo!';   ...'Let's go!'
experiment.text.start_question_subjects     = 'Se ti e` tutto chiaro possiamo iniziare con l`esperimento\nPremi S per iniziare \nun qualsiasi altro tasto per rivedere i video'; ...'If everything is clear, we can start the experiment \nPress S key to start \nor any other key to review the videos'
experiment.text.start_question_experimenter = 'Premi un tasto per iniziare l`esperimento'; ...'If everything is clear, we can start the experiment \nPress S key to start \nor any other key to review the videos'
experiment.text.start_iti_experimenter      = 'Premi p per mettere in pausa e q per uscire'; ...If everything is clear, we can start the experiment \nPress S key to start \nor any other key to review the videos'
experiment.text.start_iti_subjects          = '';
experiment.text.pause                       = 'esperimento in PAUSA';...'PAUSE ...'
experiment.text.pause_resume                = 'Preparati! stiamo per ripartire\n\n\n'; ...'Get Ready! The experiment is going to start\n\n\n', 'Let's start!
experiment.text.big_pause                   ='Questa parte dell esperimento e` finita\nriposati qualche minuto\nquando sei pronto, avvisa lo sperimentatore';  ...'This part of the experiment is finished Relac for a few minutes, when you're ready, warns the experimenter'
experiment.text.big_pause_resume            ='Fai un cenno quando sei pronto per ricominciare';... 'when you are ready, make a sign'

experiment.text.font                        = '-schumacher-clean-bold-r-normal--8-80-75-75-c-80-iso646.1991-irv';

%% =========================================================================
% 2) INPUT-OUTPUT
% =========================================================================
[experiment.sys.os_ver, experiment.sys.os_bit, ... 
 experiment.sys.matlab_ver, experiment.sys.matlab_bit, ...
 experiment.sys.matlab_tlbx]                = get_pc_settings();

experiment.io.lpt.data_address              = hex2dec('1020');  % LPT1 output port data address
experiment.io.lpt.status_address            = 1 + experiment.io.lpt.data_address;  % LPT1 output port status address
experiment.io.lpt.control_address           = 2 + experiment.io.lpt.data_address;  % LPT1 output port control address
experiment.io.lpt.trigger_duration          = 0.02;   % time between trigger value X and trigger value 0 = duration of the trigger in sec. (to avoid trigger overlapping AND trigger detection even subsampling)

experiment.io.audio.num_channels            = 2;
experiment.io.audio.device_id               = 3;
experiment.io.audio.fc                      = 44100;

if  strcmp('Linux', experiment.sys.os_ver)
    
    %% LINUX
    experiment.sys.isLinux                  = 1;
    experiment.sys.newline                  = char([13 10]);
    
    InitializePsychSound;
    PsychPortAudio('Close');
    % pahandle                              = PsychPortAudio('Open' [, deviceid]                [, mode][, reqlatencyclass][, freq][, channels][, buffersize][, suggestedLatency][, selectchannels][, specialFlags=0]);
    experiment.io.audio.handle              = PsychPortAudio('Open', experiment.io.audio.device_id, 1       , 0   , experiment.io.audio.fc, experiment.io.audio.num_channels);
    experiment.io.audio.prepare_playback    = @prepare_sound_playback_ptb;    
    experiment.io.audio.trigger_playback    = @trigger_sound_playback_ptb;    
    experiment.io.audio.close_sound         = @close_sound_ptb; 
    
    ...also needs experiment.io.lpt.data_address
    experiment.io.lpt.put_trigger           = @put_trigger_linux_fast;   
    experiment.io.lpt.portnum               = 0;  ... parport1
        
else
    %% WINDOWS
    experiment.sys.isWin                        = 1;
    experiment.sys.newline                      = char(10);

    experiment.io.useDatIfAvailable             = 0;
    existDAT                                    = 0;
    
    for tlbx=1:length(experiment.sys.matlab_tlbx)
       if  strcmp(experiment.sys.matlab_tlbx(tlbx).Name, 'Data Aquisition Toolbox')
           existDAT = 1;
            break;
       end
    end
    
    % Audio
    if existDAT && experiment.io.useDatIfAvailable
        disp('****** using Data Aquisition Toolbox to output audio ******');
        experiment.io.audio.handle              = analogoutput('winsound');             % set the sound card to load and send audios when required. create an object mapping the soundcard
        experiment.io.audio.chans               = addchannel(experiment.io.audio.handle, experiment.io.audio.num_channels); % add an audio channel to the sound card to reproduce the sound
        experiment.io.audio.prepare_playback    = @prepare_sound_playback_dat;    
        experiment.io.audio.trigger_playback    = @trigger_sound_playback_dat;    
        experiment.io.audio.close               = @close_sound_dat;         
        set(experiment.io.audio.handle,'TriggerType','Manual');                     % set the trigger to manual to use the trigger() and get a faster sound reproduction
    else
        InitializePsychSound;
        PsychPortAudio('Close');
        experiment.io.audio.handle              = PsychPortAudio('Open', experiment.io.audio.device_id, 1, 0, experiment.io.audio.fc, experiment.io.audio.num_channels);
        experiment.io.audio.prepare_playback    = @prepare_sound_playback_ptb;    
        experiment.io.audio.trigger_playback    = @trigger_sound_playback_ptb;    
        experiment.io.audio.close               = @close_sound_ptb; 
    end    
    
    % LPT through parallel port
    experiment.io.lpt.lpt_root_paths            = experiment.paths.lpt_scripts;
    experiment.io.lpt.init                      = @init_windows_lpt;
    experiment.io.lpt.close                     = @close_windows_lpt;
    
    % LPT through NI card with standard daq (Data Aquisition Toolbox) or cdaq custom library
    experiment.io.lpt.device_id                 = 1;
    experiment.io.lpt.port                      = 0;
    experiment.io.lpt.num_lines                 = 3;
    experiment.io.lpt.channel                   = 3;
    experiment.io.lpt.trigger_duration          = 0.02;
    experiment.io.lpt.put_trigger               = @put_trigger_ni_daq;  ... put_trigger_ni_cdaq
    experiment.io.lpt.init                      = @init_ni_lpt_daq;     ... init_ni_lpt_cdaq
    experiment.io.lpt.close                     = @close_ni_lpt_daq;    ... cdaqDO_close

end

%% COMMON
% ===================================================
% TO PREVENT LPT TRIGGERING, comment it if using it
experiment.io.lpt                           = [];  
% ===================================================
    
% init LPT object
if ~isempty(experiment.io.lpt) && strcmp(experiment.sys.os_ver, 'Windows')
    experiment.io.lpt.init(experiment.io.lpt);
end
%% ===================================================================
% 3) TEMPORAL & GRAPHICS SETTINGS
% ===================================================================
% ==== temporal 
experiment.time.fix                 = [];                 % fixation cross display time
experiment.time.stimulus            = 3;
experiment.time.iti_fixed           = 2;                  % fixed inter stimulus time in seconds (actual ITI = 1.5 + rand(1) )
experiment.time.iti_variable        = 1;
experiment.time.countdown           = 3;
experiment.time.pauses              = 3;
experiment.time.countdown           = 3;
experiment.time.question_time       = 4;                    % time of question panel 
experiment.time.sound_start_onset   = 1.5;                  % latency, within each video, where audio must be triggered
experiment.time.sound_start_frame   = 45;                   % frame, within each video, where audio must be triggered

% ==== graphics 
experiment.graphics.colors.black    = [0 0 0];
experiment.graphics.colors.white    = [255 255 255];

experiment.graphics.dot_size        = 4;
experiment.graphics.line_width      = 3;
experiment.graphics.forecolor       = experiment.graphics.colors.white;
experiment.graphics.backcolor       = experiment.graphics.colors.black;
experiment.graphics.text.wrapat     = 55;
experiment.graphics.text.vSpacing   = 1.5;
experiment.graphics.text.hAlign     = 'center';
experiment.graphics.text.vAlign     = 'center';

%% ===================================================================
%  4) OUTPUTS (TRIGGERS)
% ===================================================================

experiment.triggers.start_experiment_value  = 1;
experiment.triggers.pause_value             = 2;                    % start: pause, feedback and rest period
experiment.triggers.resume_value            = 3;                   % end: pause, feedback and rest period
experiment.triggers.end_experiment_value    = 4;
experiment.triggers.end_trial_value         = 5;

experiment.triggers.question_value          = 6;
experiment.triggers.AOCS_audio_value        = 7;
experiment.triggers.AOIS_audio_value        = 8;
experiment.triggers.cross_value             = 9;

experiment.triggers.conditions_value        = { ...
                                                11,12,13,14,15,16; ...
                                                21,22,23,24,25,26; ...
                                                31,32,33,34,35,36; ...
                                                41,42,43,44,45,46  ...
                                              };
        
experiment.log.fp                           = [];
experiment.log.file                         = [];     

%% ===================================================================
%  5) INPUTS 
% ===================================================================
% used keys
experiment.keys.q_key = KbName('q');    ... q: to quit experiment
experiment.keys.s_key = KbName('s');    ... s: to start experiment after training
experiment.keys.r_key = KbName('r');    ... r: to resume after a manual pause
experiment.keys.p_key = KbName('p');    ... p: to manually pause the experiment
experiment.keys.y_key = KbName('y');    ... y: subject response positive
experiment.keys.n_key = KbName('n');    ... n: subject response negative

    
%% =========================================================================
%  6) MEDIA    
% =========================================================================

experiment.media.video_file = { ...
            'ctrl01','ctrl02','ctrl03','ctrl04','ctrl05','ctrl06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'  ...
            };
        
experiment.media.audio_file = { ...
            'none','none','none','none','none','none'; ...
            'none','none','none','none','none','none'; ...
            'cs01','cs02','cs03','cs04','cs05','cs06'; ...
            'is01','is02','is03','is04','is05','is06'  ...
            }; 

experiment.media.fb_roots = { ...
            'feedback_1', 'feedback_2', 'feedback_3'
            };

% arranged according to the 8 questions within each of the 3 blocks (last two lines, refer both the third block)
experiment.media.feedback_files = { ...
            'fb1_1.jpg','fb1_2.jpg','fb1_3.jpg','fb1_4.jpg','fb1_5.jpg','fb1_6.jpg','fb1_7.jpg','fb1_8.jpg'; ...
            'fb2_1.png','fb2_2.png','fb2_3.png','fb2_4.png','fb2_5.png','fb2_6.png','fb2_7.png','fb2_8.png'; ...
            'fb3_1.jpg','fb3_2.jpg','fb3_3.jpg','fb3_4.jpg','fb3_5.jpg','fb3_6.jpg','fb3_7.jpg','fb3_8.jpg'; ...
            'fb3_1.mp4','fb3_2.mp4','fb3_3.mp4','fb3_4.mp4','fb3_5.mp4','fb3_6.mp4','fb3_7.mp4','fb3_8.mp4'  ...
            };
              
experiment.media.pause_videos           = {'pause_1.avi',   'pause_2.mp4'};
experiment.media.prepause_photos        = {'prePause1.jpg', 'prePause2.png'};

experiment.media.end_video              = 'end_video.mp4';
experiment.media.start_video            = 'start_video.avi';
experiment.media.success_audio          = 'sound_success.wav';
experiment.media.instruction_image      = 'descrizione_compito.jpg';
experiment.media.question_image         = 'question.jpg';

experiment.media.video_file_extension   = '.mp4';
experiment.media.audio_file_extension   = '.wav';
        
%% ====================================================================================================================================
%  7) SCREENS VARS
%====================================================================================================================================
                     
experiment.screens.subjects = {};
experiment.screens.experimenter = [];
experiment.screens.all = {};

experiment.screens.mainW = [];
experiment.screens.mainH = [];


experiment.screens.debugW = 800;
experiment.screens.debugH = 600;


experiment.screens.main = [];

%% ==================================================================================================================================
%  8) RUNTIME VARS
%====================================================================================================================================

...HideCursor;
experiment.runtime.curr_stimulus_num        = 0;
experiment.runtime.is_paused                = 0;
experiment.runtime.can_pause                = 0;
experiment.runtime.do_quit                  = 0;

% must correspond to : experiment.design.N_FACTOR1
% experiment.design.N_FACTOR1                 = 4;
experiment.runtime.factor1_counter          = zeros(1, 4);

experiment.runtime.experiment_start_time    = [];

experiment.runtime.curr_block               = 1;
experiment.runtime.rest_appearence          = [];

experiment.runtime.send_out_trigger         = 0;

experiment.runtime.session_number           = [];
experiment.runtime.str_session_number       = [];

experiment.runtime.fb_answers               = {0,0,0};     ... stores number of correct answers


