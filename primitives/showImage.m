function tex = showImage(file_image, win)

    if isempty(file_image) 
        disp('input file name not specified');
        tex = 0;
        return
    elseif ~exist(file_image, 'file')
        disp(['input file does not exist (' file_image ')']);
        tex = 0;
        return
    end
    if ~iscell(win)
        win = {win};
    end
    
    tex = Screen('MakeTexture', win{1}, imread(file_image));
    
    for w=1:length(win)
        
        Screen('DrawTexture', win{w}, tex)    
        Screen('Flip',win{w});
        
    end
    Screen('Close', tex);    

end