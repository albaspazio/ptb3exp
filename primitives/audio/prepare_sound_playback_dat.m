function prepare_sound_playback_dat(handle, file_audio)

    if ~exist(wavname, 'file')
        disp(['ERROR: input wave file ' wavname ' does not exists....']);
        return;
    end

    % read the audio file: collect the signal and the sampling frequency
    [s,fc] = wavread(file_audio);
    
    %set the sound card to the right sampling frequency
    set(handle,'SampleRate',fc);
    
    %load the sound to the sound card
    putdata(handle,s);
    
    %initialize the soundcard
    start(handle);
end