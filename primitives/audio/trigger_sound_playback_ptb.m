function trigger_sound_playback_ptb(handle)

    % startTime = PsychPortAudio('Start', pahandle [, repetitions=1] [, when=0] [, waitForStart=0] [, stopTime=inf] [, resume=0]);
    PsychPortAudio('Start', handle, 1, 0, 1);
    
end