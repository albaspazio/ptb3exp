function experiment = exp_check_resume2(experiment) 

    while experiment.runtime.is_paused == 1
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(experiment.keys.r_key)
                experiment.runtime.is_paused=0;
%                 exp_show_text(experiment, experiment.screens.all, experiment.text.pause_resume);
%                 showCountDown(experiment.screens.subjects, experiment.time.countdown, experiment.text.pause_resume, experiment.text.letsgo, experiment.graphics.forecolor, experiment.graphics.text.wrapat, experiment.graphics.backcolor); 

                if ~isempty(experiment.io.lpt)
                    experiment.io.lpt.put_trigger(experiment.io.lpt, experiment.triggers.resume_value);
                end

                fwrite(experiment.log.fp, ['exit pause @ : ' num2str(GetSecs-experiment.runtime.experiment_start_time) experiment.sys.newline]);
                 WaitSecs(experiment.time.pauses);
            end
        end 
    end
end
