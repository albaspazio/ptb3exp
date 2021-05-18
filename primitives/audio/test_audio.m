
audio_input_folder          = 'E:\EEG\PAP\blinded_al\experiment\resources\audio';
audio_input_folder          = '\\geo.humanoids.iit.it\repository\groups\behaviour_lab\Projects\PAP\blinded_al\experiment\resources\audio';

list_audio                  = {'clap_clap_n', 'window_break_02_n','train_n','toc_toc5_n','fingers_n','fax_n','clock_n','bottle_n'};
...list_audio                  = {'19_'};

[os_ver, os_bit, matlab_ver, matlab_bit, matlab_tlbx] = get_pc_settings();

audio.num_channels          = 2;
audio.device_id             = 3;
audio.fc                    = 44100;
audio.use_dat               = 0;
if  strcmp('Linux', os_ver)
    InitializePsychSound;
    % pahandle = PsychPortAudio('Open' [, deviceid][, mode][, reqlatencyclass][, freq][, channels][, buffersize][, suggestedLatency][, selectchannels][, specialFlags=0]);
    audio.handle            = PsychPortAudio('Open', audio.device_id, 1, 0, audio.fc, audio.num_channels);
    audio.prepare_playback  = @prepare_sound_playback_ptb;    
    audio.trigger_playback  = @trigger_sound_playback_ptb;    
    audio.close_sound       = @close_sound_ptb;    
else
    
    % AUDIO
    existDAT = 0;
    for tlbx=1:length(matlab_tlbx)
       if  strcmp(matlab_tlbx(tlbx).Name, 'Data Aquisition Toolbox') && audio.use_dat
           existDAT = 1;
            break;
       end
    end
    
    if existDAT
        audio.handle            = analogoutput('winsound');                         % set the sound card to load and send audios when required. create an object mapping the soundcard
        audio.chans             = addchannel(audio.handle,audio.num_channels);      % add audio channel(s) to the sound card to reproduce the sound
        audio.prepare_playback  = @prepare_sound_playback_dat;
        audio.trigger_playback  = @trigger_sound_playback_dat;
        audio.close_sound       = @close_sound_dat;    
        set(audio.handle,'TriggerType','Manual');                       % set the trigger to manual to use the trigger() and get a faster sound reproduction
        
    else
        InitializePsychSound;
        % pahandle = PsychPortAudio('Open' [, deviceid][, mode][, reqlatencyclass][, freq][, channels][, buffersize][, suggestedLatency][, selectchannels][, specialFlags=0]);
        audio.handle            = PsychPortAudio('Open', audio.device_id, 1, 0, audio.fc, audio.num_channels);
        audio.prepare_playback  = @prepare_sound_playback_ptb;
        audio.trigger_playback  = @trigger_sound_playback_ptb;
        audio.close_sound       = @close_sound_ptb;    
    end    
end

for s=1:length(list_audio)
    audio_file = fullfile(audio_input_folder, [list_audio{s} '.wav']);
    ...tic;
    duration = audio.prepare_playback(audio.handle, audio_file);
    ...toc
    ...tic;
    audio.trigger_playback(audio.handle);
    WaitSecs(duration);
    WaitSecs(1);
    ...toc
end
% STOP SOUND & eventually close the resource depends on the needs:
... the following options block code until sound completion
... 1) PsychPortAudio('Stop', audio.handle, 1); ... wait untill
... 2) while strcmp(audio.handle.Running,'On')
...    end
...pause(3);

...audio.close_sound(audio.handle);
