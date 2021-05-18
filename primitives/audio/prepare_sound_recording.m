function pahandle = prepare_sound_recording(device_id, maxsecs, freq)

    % Open the audio device : device_id
    % with mode 2 (== Only audio capture),
    % a required latencyclass of zero 0 == no low-latency mode
    % a frequency of freq Hz and 2 sound channels for stereo capture.
    % This returns a handle to the audio device:
    ...disp(['opening audio devide ' num2str(device_id)]);
    pahandle = PsychPortAudio('Open', device_id, 2, 0, freq, 2);

    % Preallocate an internal audio recording  buffer with a capacity of maxsecs seconds:
    PsychPortAudio('GetAudioData', pahandle, (maxsecs + 0.04));
end