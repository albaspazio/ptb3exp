function update_webcam_screen(wcs, varargin)
    
    % ----------------------------------------------------------------------
    % check if filename and dropframe differ from standard values
    nvararg=length(varargin);
    % default
    rotation=0;
    for var=1:2:nvararg
        switch varargin{var}
            case 'rotation'
            rotation=varargin{var+1};
        end
    end
    % ----------------------------------------------------------------------

    tex=0;

    [tex pts nrdropped]=Screen('GetCapturedImage', wcs.wndptr, wcs.grabber, 1); 
    if (tex>0)
        % Perform first-time setup of transformations, if needed:
        Screen('DrawTexture', wcs.wndptr, tex, [], [], rotation);
        Screen('Flip', wcs.wndptr);
        Screen('Close', tex);
        tex=0;
    end;            
end