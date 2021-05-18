function close_sound_ptb(varargin)

    if nargin
        PsychPortAudio('Stop', handle, 2);
        PsychPortAudio('Close', handle);
    else
        PsychPortAudio('Close');
    end
end