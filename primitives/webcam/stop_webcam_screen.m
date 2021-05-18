function stop_webcam_screen(wcs)

    Screen('StopVideoCapture', wcs.grabber);
    Screen('CloseVideoCapture', wcs.grabber);
end