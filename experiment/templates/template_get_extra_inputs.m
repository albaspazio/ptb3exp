function experiment = get_extra_inputs(experiment)

    % number of conditions =====================================================
    while 1
        str_num_cond = input('please specify how many conditions you want to display (press : 2 or 3): ', 's');
        switch str_num_cond
            case {'2','3'}
                break;
            otherwise
                disp('accepted sides are: 2 & 3');
        end
    end    
    experiment.runtime.str_condition = ['_' str_num_cond '_conditions'];

    % skip training  =====================================================
    experiment.runtime.do_training = 1;     ... default: do training
    while 1
        str_skip_training = input('do you want to skip the training (press : y or n): ', 's');
        switch str_skip_training
            case {'y','n'}
                if strcmp(str_skip_training, 'y')
                    experiment.runtime.do_training = 0;
                end
                break;
            otherwise
                disp('accepted sides are: y & n');
        end
    end        
    
    
    % metti in pausa durante le domande  =====================================================
    experiment.runtime.do_question_pause = 0; ... default: don't wait
    while 1
        str_wait_answers = input('do you want to wait for subject answers to the questions (press : y or n): ', 's');
        switch str_wait_answers
            case {'y','n'}
                if strcmp(str_wait_answers, 'y')
                    experiment.runtime.do_question_pause = 1;
                end
                break;
            otherwise
                disp('accepted sides are: y & n');
        end
    end        
end