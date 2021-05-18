function arrwcs = open_webcam_screens(mainwnd, arrwcs, varargin)

    % ----------------------------------------------------------------------
    % check if filename and dropframe differ from standard values
    nvararg=length(varargin);
    % default
    filename=arrwcs.settings.filename;
    drop_frames=arrwcs.settings.drop_frames_playback;
    for var=1:2:nvararg
        switch varargin(var)
            case 'filename'
            filename=varargin(var+1);
        end
    end
    
    
    % ----------------------------------------------------------------------

    for w=1:arrwcs.num
        if (arrwcs.wcs(w).wndptr == 0)
            arrwcs.wcs(w).wndptr=Screen('OpenWindow', mainwnd, 0, arrwcs.wcs(w).position);
        end
        arrwcs.wcs(w).grabber= Screen('OpenVideoCapture', arrwcs.wcs(w).wndptr, arrwcs.wcs(w).device_id, arrwcs.settings.cam_screen, arrwcs.settings.pixel_depth, arrwcs.settings.num_buff, arrwcs.settings.allow_fallback, filename, arrwcs.settings.rec_flags, arrwcs.settings.capt_engine);

    end

end