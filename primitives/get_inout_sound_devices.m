% pahandle = PsychPortAudio('Open' [, deviceid][, mode][, reqlatencyclass][, freq][, channels][, buffersize][, suggestedLatency][, selectchannels][, specialFlags=0]);
% 
% handles(1) = playback
% handles(2) = recording
% 
% 
% 
function handles = get_inout_sound_devices(fc, ch)

    InitializePsychSound
    devices = PsychPortAudio('GetDevices');
    
    try
        %-----------------------------------------------------------
        % PURE PLAYBACK
        for s=1:length(devices)
            device = devices(s);
            if device.NrOutputChannels && not(device.NrInputChannels)
                handle = PsychPortAudio('Open', device.DeviceIndex, 1, 0, fc, ch);

                if exist('handle', 'var')
                    handles(1) = devices(s);    
                    clear handle
                    PsychPortAudio('Close'); 
                    break;
                end
            end
        end
        clear handle

        %-----------------------------------------------------------
        % PURE RECORDING
        for s=1:length(devices)
            device = devices(s);
            if device.NrInputChannels && not(device.NrOutputChannels)
                handle = PsychPortAudio('Open', device.DeviceIndex, 2, 0, fc, ch);

                if exist('handle', 'var')
                    handles(2) = devices(s);
                    clear handle
                    PsychPortAudio('Close');            
                    break;
                end
            end
            
        end
        clear handle
        %-----------------------------------------------------------


        if not(exist('handles', 'var'))
            handles = [];
        end
        
    catch err
        
         disp(['error in device ' num2str(s)]);
         PsychPortAudio('Close');    
         handles = [];
    end
end