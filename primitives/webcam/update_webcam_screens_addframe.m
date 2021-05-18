function nrdropped = update_webcam_screens_addframe(arrwcs, wcs_id, varargin)
    
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
    old_tex=0;
    tex=0;
    for w=1:arrwcs.num
        [tex pts nrdropped]=Screen('GetCapturedImage', arrwcs.wcs(w).wndptr, arrwcs.wcs(w).grabber, 0, old_tex); 
        if (tex>0)
            % Perform first-time setup of transformations, if needed:
            Screen('DrawTexture', arrwcs.wcs(w).wndptr, tex, [], [], rotation);
            Screen('Flip', arrwcs.wcs(w).wndptr);
            
            if (w == wcs_id)
               Screen('AddFrameToMovie', arrwcs.wcs(w).wndptr, [], 'frontBuffer', [],1); 
               disp(pts);
               disp(num2str(nrdropped));
            end
            old_tex = tex;
            Screen('Close', tex);
        else
            % Perform first-time setup of transformations, if needed:
            Screen('DrawTexture', arrwcs.wcs(w).wndptr, tex, [], [], rotation);
            Screen('Flip', arrwcs.wcs(w).wndptr);
            
            if (w == wcs_id)
               Screen('AddFrameToMovie', old_tex, [], 'frontBuffer', [],1); 
               disp(pts);
               disp(num2str(nrdropped));
            end            
        end;            
    end
end