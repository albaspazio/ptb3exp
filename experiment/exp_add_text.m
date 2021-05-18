function txt_dimensions = exp_add_text(experiment, windows, text, varargin) 

    txt_dimensions = cell(1, length(windows));
    
    hAlign      = experiment.graphics.text.hAlign;
    vAlign      = experiment.graphics.text.vAlign;
    forecolor   = experiment.graphics.forecolor;
    wrapat      = experiment.graphics.text.wrapat;
    vSpacing    = experiment.graphics.text.vSpacing;
    
    for v=1:2:length(varargin)
        if isempty(varargin{v+1})
            continue
        end
        
        switch varargin{v}
            case 'hAlign'
                hAlign = varargin{v+1};
            case 'vAlign'
                vAlign = varargin{v+1};
            case 'forecolor'
                forecolor = varargin{v+1};        
            case 'wrapat'
                wrapat = varargin{v+1};   
            case 'vSpacing'
                vSpacing = varargin{v+1};                   
        end
    end

    for w=1:length(windows)
         txt_dimensions{w} = DrawFormattedText(windows{w}, text, hAlign, vAlign, forecolor, wrapat , [], [], vSpacing);
    end
end