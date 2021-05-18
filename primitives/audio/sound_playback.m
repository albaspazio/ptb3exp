%% sound_playback(audio_file, ao)
%

%%
function sound_playback(audio_file, ao)

    if isempty(audio_file)
        disp('input audio file name not specified');
        return
    end

    if ~exist(audio_file, 'file')
        disp(['input audio file name (' audio_file ') not specified']);
        return
    end
    
    try
        ao.prepare_playback(ao.handle, audio_file);
        ao.trigger_playback(ao.handle); 
    catch
        psychrethrow(psychlasterror);
    end
end