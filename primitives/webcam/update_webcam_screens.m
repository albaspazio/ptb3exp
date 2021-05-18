function update_webcam_screens(arrwcs, varargin)
    
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
    for w=1:arrwcs.num
        [tex pts nrdropped]=Screen('GetCapturedImage', arrwcs.wcs(w).wndptr, arrwcs.wcs(w).grabber, 1); 
        if (tex>0)
            % Perform first-time setup of transformations, if needed:
            Screen('DrawTexture', arrwcs.wcs(w).wndptr, tex, [], [], rotation);
            Screen('Flip', arrwcs.wcs(w).wndptr);
            Screen('Close', tex);
            tex=0;
        end;            
    end

end