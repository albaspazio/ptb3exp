function start_sound_recording(pahandle)

    % Start audio capture immediately and wait for the capture to start.
    % We set the number of 'repetitions' to zero: record until recording is manually stopped.
    PsychPortAudio('Start', pahandle, 0, 0, 1);
end