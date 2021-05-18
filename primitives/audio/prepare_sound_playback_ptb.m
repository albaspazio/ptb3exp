function duration = prepare_sound_playback_ptb(handle, file_audio)

    if ~exist(file_audio, 'file')
        disp(['ERROR: input wave file ' file_audio ' does not exists....']);
        return;
    end
    
    % read the audio file: collect the signal and the sampling frequency
    [y, orig_freq] = wavread(file_audio);
    % arrange data    
    wavedata = y';
    %load the sound to the sound card    
    PsychPortAudio('FillBuffer', handle, wavedata);
    duration = size(y,1)/orig_freq;
end