% CONTEXT:  when different wcs are present but ONLY ONE can record data
% OPERATIONS: stop recording in active wcs (if present) and start recording in the selected one
% set recording_wcs=0 to stop all recordings
% if recording_wcs is already recording, nothing happens
function arrwcs = switch_webcam_screens_recording(recording_wcs, filename, arrwcs)
    
    for w=1:arrwcs.num
        if (arrwcs.wcs(w).isRecording && recording_wcs ~= w)
            % stop recording ( & capturing)
            arrwcs.wcs(w).isRecording=0;
            Screen('StopVideoCapture', arrwcs.wcs(w).grabber);
            fname = sprintf('SetNewMoviename=%s', '');
            Screen('SetVideoCaptureParameter', arrwcs.wcs(w).grabber, fname);
            % restart in display mode
            Screen('StartVideoCapture', arrwcs.wcs(w).grabber, arrwcs.settings.fps, arrwcs.settings.drop_frames_playback);
        end
    end
    if (recording_wcs && arrwcs.wcs(recording_wcs).isRecording == 0)
        arrwcs.wcs(recording_wcs).isRecording=1;
        Screen('StopVideoCapture', arrwcs.wcs(recording_wcs).grabber);
        fname = sprintf('SetNewMoviename=%s', filename);
        Screen('SetVideoCaptureParameter', arrwcs.wcs(recording_wcs).grabber, fname);
        % restart in display mode
        disp(['saving to ' fname])
        Screen('StartVideoCapture', arrwcs.wcs(recording_wcs).grabber, arrwcs.settings.fps, arrwcs.settings.drop_frames_recording);
    end
end