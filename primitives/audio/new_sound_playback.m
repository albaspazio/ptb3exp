%% new_sound_playback(ao, wavname)
%
% AO:                           object mapping the device used to reproduce the audio. can be a device :instantiated with Data Aquisition Toolbox OR opened and accessed with Psychtoolbox
%                               the object must contains:
%                                   - device_id  (actually, set it to 0 if empty)
%                                   - @prepare_playback
%                                   - @trigger_playback
%                                   - @close_sound
%       
%
%
%%
function [ao, duration] = new_sound_playback(ao, audio_file)

    [y, orig_freq]  = wavread(audio_file);
    wavedata        = y';
    nrchannels      = size(wavedata, 1);  ... Number of rows == number of channels.
    nrsamples       = size(wavedata, 2);

    duration        = nrsamples/orig_freq;
    if ~isfield(ao, 'device_id')
        ao.device_id = 0;
    end
    
    ao.handle       = PsychPortAudio('Open', ao.device_id, [], 0, orig_freq, nrchannels);
    duration        = ao.prepare_playback(ao.handle, audio_file);
    ao.trigger_playback(ao.handle);
    
   
    % Stop playback:
    ...PsychPortAudio('Stop', pahandle, 1);

    % Close the audio device:
    ...PsychPortAudio('Close', pahandle);    

end