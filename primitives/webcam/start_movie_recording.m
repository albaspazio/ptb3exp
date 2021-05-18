% CONTEXT:  when different wcs are present but ONLY ONE can record data
% OPERATIONS: stop recording in active wcs (if present) and start recording in the selected one
% set recording_wcs=0 to stop all recordings
% if recording_wcs is already recording, nothing happens
function arrwcs = start_movie_recording(recording_wcs, filename, arrwcs)
    
    for w=1:arrwcs.num
        if (arrwcs.wcs(w).isRecording && recording_wcs ~= w)
            arrwcs.wcs(w).isRecording=0;
        end
    end
    if (recording_wcs)
        if (arrwcs.wcs(recording_wcs).isRecording == 0)
            arrwcs.wcs(recording_wcs).isRecording=1;
            arrwcs.wcs(recording_wcs).file_ptr=Screen('CreateMovie', arrwcs.wcs(recording_wcs).wndptr,filename,[],[],[], arrwcs.settings.codec);
        end
    end
end