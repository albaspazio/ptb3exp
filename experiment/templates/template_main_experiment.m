
% PSYCHTOOLBOX experiment : template
%
%
% Author: Alberto Inuggi, October 2014.
%
% SECTIONS:
%   1)  local paths
%   2)  Init data (structure, permutations, user input)
%   3)  Screens definition
%   4)  Start experiment
%   5)  Close experiment
%
close all

do_debug=1;

%% =========================================================================
% 1) PATHS
% =========================================================================

% PC dependent
experiment.paths.experiment_root    = '/data/projects/PAP/cp_aos/experiment';       ... folder used to contain media (images, audio, video , etc) and write logs, stat, results files
experiment.paths.svn_root           = '/data/behavior_lab_svn/behaviourPlatform';   ... folder containing svn root 

...experiment.paths.experiment_root    = 'C:\Users\pippo\Documents\BEHAVIOUR_PLATFORM\behaviourPlatform@local\cpchildren\';
...experiment.paths.svn_root           = 'C:\Users\pippo\Documents\BEHAVIOUR_PLATFORM\behaviourPlatform@svn\';

% Standard
experiment.paths.global_scripts     = fullfile(experiment.paths.svn_root,'CommonScript',''); addpath(experiment.paths.global_scripts);
experiment.paths.script_project     = fullfile(experiment.paths.svn_root, 'PAP', 'adult_aos', 'ptb3', ''); 

experiment.paths.ptb3_scripts       = fullfile(experiment.paths.global_scripts, 'ptb3', '');
experiment.paths.lpt_scripts        = fullfile(experiment.paths.global_scripts, 'io', '');

addpath(experiment.paths.script_project);
addpath(genpath2(experiment.paths.ptb3_scripts));
addpath(genpath2(experiment.paths.eeg_tools_scripts));
addpath(genpath2(experiment.paths.lpt_scripts));

experiment.paths.resources          = fullfile(experiment.paths.experiment_root, 'resources', '');
experiment.paths.subjects_data      = fullfile(experiment.paths.experiment_root, 'subjects_data', '');

%% =========================================================================
% 2) INIT DATA
try
        
    dispstat('','init');

    % Check if Psychtoolbox is properly installed:
    AssertOpenGL;

    % GET SUBJECT ID & LOG
    experiment.runtime.str_condition = '';              ... default value

    experiment = exp_get_subject_data(experiment);
    experiment = get_extra_inputs(experiment);          ... not mandatory, you can remove it if you don't need extra information

    dispstat('permuting stimuli....');
    eval(['permute_stimuli' experiment.runtime.str_condition]);
    dispstat('stimuli permuted', 'keepthis');

    dispstat('loading experiment parameters....');
    eval(['experiment_structure' experiment.runtime.str_condition]);
    dispstat('experiment parameters loaded', 'keepthis');

    experiment = set_paths_other_processing(experiment);    ... not mandatory, you can remove it if you don't need to perform post extra-input addition

    %% =========================================================================
    % 3) SCREENS DEFINITION

    Screen('Preference', 'SkipSyncTests', 0);
    Screen('Preference', 'SuppressAllWarnings', 0);

    % Create Screens
    if (do_debug == 1)
        experiment.screens.mainW    = experiment.screens.debugW; 
        experiment.screens.mainH    = experiment.screens.debugH;
        rec                         = [0, 0, experiment.screens.mainW, experiment.screens.mainH]; 
    else
        rec                         = Screen('Rect',0);
        [experiment.screens.mainW, experiment.screens.mainH] = Screen('WindowSize', 0);
    end


    ...[experiment.screens.experimenter, rect]         = Screen('OpenWindow', 0, experiment.graphics.backcolor, rec);
    [wnd_1, rect]                       = Screen('OpenWindow', 0, experiment.graphics.backcolor, rec);

    experiment.screens.all              = {wnd_1};
    experiment.screens.subjects         = {wnd_1};
    experiment.screens.num_subject_scr  = length( experiment.screens.subjects);

    experiment.screens.main             = wnd_1;

    experiment.graphics.cross_center    = [experiment.screens.mainW/2-12 experiment.screens.mainW/2+12 experiment.screens.mainW/2 experiment.screens.mainW/2; experiment.screens.mainH/2 experiment.screens.mainH/2 experiment.screens.mainH/2-12 experiment.screens.mainH/2+12]; % cross

    for w=1:length(experiment.screens.all)
        [oldFontName,oldFontNumber]     = Screen('TextFont', experiment.screens.all{w}, experiment.text.font);
    end

    ...ListenChar(2);

    %% ====================================================================================================================================
    % 4) START EXPERIMENT  
    %====================================================================================================================================

    if experiment.runtime.do_training
       show_training(experiment, experiment.design.N_FACTOR2); 
    else
        % show TEXT and wait for keypress
        exp_show_text(experiment, experiment.screens.all, experiment.text.start_question_experimenter);
        KbWait;    
    end

    % start experiment trigger
    if ~isempty(experiment.io.lpt)
        experiment.io.lpt.put_trigger(experiment.io.lpt, experiment.triggers.start_experiment_value);
    end

    experiment.runtime.experiment_start_time = GetSecs;
    fwrite(experiment.log.fp, ['0' ': start experiment  @time: ' num2str(GetSecs-experiment.runtime. experiment_start_time) experiment.sys.newline]);

    showCross(experiment.screens.main, 0, experiment.graphics.forecolor, experiment.graphics.line_width);
    WaitSecs(experiment.time.pauses);

    for f1_type = experiment.runtime.factor1_list

        experiment.runtime.f1_type              = f1_type;
        experiment.runtime.curr_stimulus_num    = experiment.runtime.curr_stimulus_num + 1;

        % if is paused, check for a 'r' press in order to resume the experiment
        experiment = exp_check_resume(experiment);

        % show trial
        experiment = show_trial(experiment);

        % check if QUESTION must be shown
        experiment = check_question(experiment);

        % check if REST must be shown
        experiment = check_rest(experiment);

        % ITI + check if CAN PAUSE (press p)
        experiment = exp_check_pause_iti(experiment);

        % QUIT ???
        if experiment.runtime.do_quit
           break;
        end
    end

    %% ====================================================================================================================================
    % 5) CLOSE EXPERIMENT 
    if ~isempty(experiment.io.lpt)
        experiment.io.lpt.put_trigger(experiment.io.lpt, experiment.triggers.end_experiment_value);
        experiment.io.lpt.close();
    end

    if experiment.log.fp ~= -1
        fclose(experiment.log.fp);
    end

    if ~isempty(experiment.io.audio)
        experiment.io.audio.close_sound();
    end

    ShowCursor;
    ...ListenChar(0);
    Screen('CloseAll');
    sca;

catch err
    ListenChar(0);
    % This "catch" section executes in case of an error in the "try" section above.  Importantly, it closes the onscreen window if it's open.
    ...psychrethrow(psychlasterror);
    if ~isempty(experiment.io.lpt)        
        experiment.io.lpt.close();
    end
    
    if experiment.log.fp ~= -1
        fclose(experiment.log.fp);
    end
    
    Screen('CloseAll');
    err 
    err.message
    err.stack(1)
    
    if ~isempty(experiment.io.audio)
        experiment.io.audio.close_sound();
    end
end



% =========================================================================================================
% =========================================================================================================
% LAST MODS
% =========================================================================================================
% =========================================================================================================
% 21/7/2014
% First version
% 15/10/2014
% set init/close of lpt, lpt_ni_daq, lpt_ni_cdaq, audio_ptb, audio_dat
% 25/11/2014
% refined parameters loading and design permutation

