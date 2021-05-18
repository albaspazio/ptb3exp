function txt_dimensions = exp_show_text(experiment, windows, text, varargin) 

    txt_dimensions = exp_add_text(experiment, windows, text, varargin{:});

    for w=1:length(windows)
        Screen('Flip',windows{w});
    end
end