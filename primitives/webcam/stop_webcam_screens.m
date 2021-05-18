function stop_webcam_screens(arrwcs)

    for w=1:arrwcs.num   
        Screen('StopVideoCapture', arrwcs.wcs(w).grabber);
        Screen('CloseVideoCapture', arrwcs.wcs(w).grabber);
    end
end