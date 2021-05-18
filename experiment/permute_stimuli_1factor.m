% 3x2 experiment: 


experiment.design.FACTOR1_TYPES                 = [1 2 3];     
experiment.design.N_FACTOR1                     = length(experiment.design.FACTOR1_TYPES);    

experiment.design.N_TRIALS_X_COND               = 60;                                         ... 60
experiment.design.N_TRIALS                      = experiment.design.N_TRIALS_X_COND * experiment.design.N_FACTOR1;                ... 60 * 3 = 180

experiment.design.TRIAL_LENGTH                  = 0.1;                                        ... 3 mov +iti
experiment.design.EXP_DURATION                  = (experiment.design.N_TRIALS * experiment.design.TRIAL_LENGTH) / 60;             ... 30 min 


% DEFINITION OF THE PERMUTATION OVER THE FIRST FACTOR

experiment.design.MIN_TRIAL_X_BLOCK1            = experiment.design.N_FACTOR1;                                    ...  3;
experiment.design.MAX_BLOCK1                    = experiment.design.N_TRIALS / experiment.design.MIN_TRIAL_X_BLOCK1;                ... 180 / 3 = 60

experiment.design.N_BLOCK1                      = 20;
experiment.design.N_TRIALS_X_BLOCK1             = experiment.design.N_TRIALS / experiment.design.N_BLOCK1;                        ... 180 / 20 = 9
experiment.design.BLOCK1_REPETITION_FACTOR      = experiment.design.N_TRIALS_X_BLOCK1 / experiment.design.N_FACTOR1;              ... 9 / 3 = 3

% DO PERMUTATION


experiment.design.factor1_list=[]; ... [1xN_TRIALS]
for f2=1:experiment.design.N_BLOCK1
    ordered_list                        = repmat(experiment.design.FACTOR1_TYPES, 1, experiment.design.BLOCK1_REPETITION_FACTOR);         ... 1x3 => 1x36
    permutation                         = randperm(experiment.design.N_TRIALS_X_BLOCK1);
    experiment.design.factor1_list     = [experiment.design.factor1_list ordered_list(permutation)];
end


%---------------------------------------------------------------------------------------------
% questions & rest

experiment.design.N_RANDOM_QUESTIONS    = 24; 
experiment.design.QUESTIONS_JITTER      = 2;                        
experiment                              = exp_define_questions_onsets(experiment);

experiment.design.rest_appearence      = zeros(1, experiment.design.N_TRIALS);
%---------------------------------------------------------------------------------------------
% clean up

clear ordered_list
clear permutation
clear f2
