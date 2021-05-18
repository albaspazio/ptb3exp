%% function play_whitenoise(ao, duration, [wait_completion])
%
% AO:                           object mapping the device used to reproduce the audio. can be a device :instantiated with Data Aquisition Toolbox OR opened and accessed with Psychtoolbox
%                               the object must contains:
%                                   - device_id  (actually, set it to 0 if empty)
%                                   - handle
%                                   - fc
%                                   - num_channels
%                                   - @prepare_playback
%                                   - @trigger_playback
%                                   - @close_sound
%       
%
%
%%
function play_whitenoise_sound(ao, duration, varargin)

    if nargin < 3
        wait_completion = 0;
    else
        wait_completion = varargin{1};
    end
    
    whitenoise = rand(ao.num_channels, ao.fc*duration)*0.4;
    PsychPortAudio('FillBuffer', ao.handle, whitenoise);
    PsychPortAudio('Start', ao.handle, 1, 0, 1);
    
    if wait_completion
        WaitSecs(duration);
    end

end