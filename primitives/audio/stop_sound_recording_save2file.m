function stop_sound_recording_save2file(snd_handle, output_wav, freq)

    % Stop capture:
    PsychPortAudio('Stop', snd_handle);

    % Perform a last fetch operation to get all remaining data from the capture engine:
    audiodata = PsychPortAudio('GetAudioData', snd_handle);

    % Close the audio device:
    PsychPortAudio('Close', snd_handle);

    % Shall we store recorded sound to wavfile?
    if ~isempty(output_wav)
        wavwrite(transpose(audiodata), freq, 16, output_wav)
    end
end