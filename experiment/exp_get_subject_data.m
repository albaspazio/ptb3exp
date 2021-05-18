function experiment = exp_get_subject_data(experiment)

    [experiment.design.session_number, experiment.log.file, experiment.log.fp] = get_subject_data(experiment.paths.subjects_data);
    
    experiment.design.str_session_number = num2str(experiment.design.session_number);

end
