function pahandle = start_sound_playback(device_id, wavname, freq)

    [y, orig_freq] = wavread(wavname);
    wavedata = y';
    nrchannels = size(wavedata,1); % Number of rows == number of channels.
    
    pahandle = PsychPortAudio('Open', device_id, [], 0, orig_freq, nrchannels);
    PsychPortAudio('FillBuffer', pahandle, wavedata);
    PsychPortAudio('Start', pahandle, 1, 0, 1);
    
    % Stop playback:
    ...PsychPortAudio('Stop', pahandle, 1);

    % Close the audio device:
    ...PsychPortAudio('Close', pahandle);    

end