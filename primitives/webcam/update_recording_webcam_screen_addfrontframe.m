function [pts, nrdropped] = update_recording_webcam_screen_addfrontframe(wcs, varargin)
    
    % ----------------------------------------------------------------------
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
    [tex, pts, nrdropped]=Screen('GetCapturedImage', wcs.wndptr, wcs.grabber, 1); 

    if (tex>0)
        Screen('DrawTexture', wcs.wndptr, tex, [], [], rotation);
        Screen('Flip', wcs.wndptr);
        ...Screen('AddFrameToMovie', wcs.wndptr, [], 'frontBuffer', [],1); 
        Screen('AddFrameToMovie', wcs.wndptr, [], 'frontBuffer', [], 1 + nrdropped); 
         if nrdropped
             disp([num2str(nrdropped) ' df @ pt:' num2str(pts)]);
         end
%             for df=1:nrdropped
%                 Screen('AddFrameToMovie', wcs.wndptr, [], 'frontBuffer', [],1);
%             end
%         end        
        Screen('Close', tex);
    end 
end