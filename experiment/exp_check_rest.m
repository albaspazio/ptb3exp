function experiment = exp_check_rest(experiment)

    if experiment.design.rest_appearence(1, experiment.runtime.curr_stimulus_num) == 1
        if ~isempty(experiment.io.lpt)
            experiment.io.lpt.put_trigger(experiment.io.lpt, experiment.triggers.pause_value);
        end   

        exp_show_text(experiment, experiment.screens.all, window,experiment.text.rest);
        KbWait;
        
        % show a 3 seconds countdown panel
        showCountDownEx(experiment.screens.all, experiment.time.pauses, experiment.text.pause_resume, experiment.text.letsgo ,experiment.graphics.forecolor, experiment.graphics.text.wrapat); 
        if ~isempty(experiment.io.lpt)
            experiment.io.lpt.put_trigger(experiment.io.lpt, experiment.triggers.resume_value);
        end       
        experiment.runtime.curr_block = experiment.runtime.curr_block+1;
    end
end