function experiment = exp_check_pause_iti(experiment) 

    if experiment.time.iti_variable
        experiment.runtime.curr_iti     = round((experiment.time.iti_fixed + experiment.time.iti_variable*rand())*100)/100;
    else
        experiment.runtime.curr_iti     = experiment.time.iti_fixed;
    end
    
    experiment.runtime.can_pause    = 1;
    start_time                      = GetSecs;
    
    while experiment.runtime.is_paused == 0

        if ~isempty(experiment.screens.experimenter)
            exp_show_text(experiment, experiment.screens.experimenter, experiment.text.start_iti_experimenter);
        end
        
        if ~isempty(experiment.text.start_iti_subjects)
            exp_show_text(experiment, experiment.screens.subjects, experiment.text.start_iti_subjects);
        end

        [keyIsDown,secs, keyCode] = KbCheck;
        if (keyIsDown && experiment.runtime.can_pause == 1)
            if keyCode(experiment.keys.q_key)
                experiment.runtime.do_quit=1;
                break;
            end            
            if keyCode(experiment.keys.p_key)
                experiment.runtime.is_paused=1;
                WaitSecs(0.04);
                if ~isempty(experiment.io.lpt)
                    experiment.io.lpt.put_trigger(experiment.io.lpt, experiment.triggers.pause_value);
                end  

                fwrite(experiment.log.fp, ['enter pause @ : ' num2str(GetSecs-experiment.runtime.experiment_start_time) experiment.sys.newline]);
                exp_show_text(experiment, experiment.screens.all, experiment.text.pause,'hAlign', experiment.graphics.text.hAlign,'vAlign', experiment.graphics.text.vAlign,'forecolor', experiment.graphics.forecolor ,'wrapat', experiment.graphics.text.wrapat ,'vSpacing', experiment.graphics.text.vSpacing);
                break
            end
        end 
        elapsed=GetSecs-start_time;
        if elapsed > experiment.runtime.curr_iti
            break;
        end            
    end  
    experiment.runtime.can_pause=0;

end