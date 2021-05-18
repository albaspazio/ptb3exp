% CONTEXT:  when different wcs are present but ONLY ONE can record data
% OPERATIONS: stop recording in active wcs (if present) and start recording in the selected one
% set recording_wcs=0 to stop all recordings
% if recording_wcs is already recording, nothing happens
function arrwcs = switch_capturing_webcam_screens(recording_wcs, arrwcs)
    
    for w=1:arrwcs.num
        if (arrwcs.wcs(w).isRecording && recording_wcs ~= w)
            % stop recording ( & capturing)
            arrwcs.wcs(w).isRecording=0;
            Screen('StopVideoCapture', arrwcs.wcs(w).grabber);
        end
    end
    if (recording_wcs)
        if (arrwcs.wcs(recording_wcs).isRecording == 0)
            arrwcs.wcs(recording_wcs).isRecording=1;
            % start in display mode
            Screen('StartVideoCapture', arrwcs.wcs(recording_wcs).grabber, arrwcs.settings.fps, arrwcs.settings.drop_frames_playback);
        end
    end
end