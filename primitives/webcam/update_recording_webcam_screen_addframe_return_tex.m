function [tex, pts, nrdropped] = update_recording_webcam_screen_addframe_return_tex(wcs, varargin)
    
    % ----------------------------------------------------------------------
    nvararg=length(varargin);
    % default
    rotation=0;
    prev_tex=0;
    for var=1:2:nvararg
        switch varargin{var}
            case 'rotation'
            rotation=varargin{var+1};
            case 'prev_tex'
            prev_tex=varargin{var+1};            
        end
    end
    % ----------------------------------------------------------------------
    tex=0;
    [tex, pts, nrdropped]=Screen('GetCapturedImage', wcs.wndptr, wcs.grabber, 1, prev_tex); 
    
    if prev_tex; Screen('Close', prev_tex); end
    
    if (tex>0)
        Screen('DrawTexture', wcs.wndptr, tex, [], [], rotation);
        Screen('Flip', wcs.wndptr);
        Screen('AddFrameToMovie', wcs.wndptr, [], 'frontBuffer', [],1); 
        if nrdropped
            disp([num2str(nrdropped) ' df @ pt:' num2str(pts)]);
            for df=1:nrdropped
                Screen('AddFrameToMovie', wcs.wndptr, [], 'frontBuffer', [],1);
            end
        end
        ...Screen('Close', tex);
    end 
end