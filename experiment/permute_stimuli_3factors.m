% 3x2x3 experiment: 


experiment.design.FACTOR1_TYPES                 = [1 2 3];     
experiment.design.N_FACTOR1                     = length(experiment.design.FACTOR1_TYPES);    

experiment.design.FACTOR2_TYPES                 = [1,2];
experiment.design.N_FACTOR2                     = length(experiment.design.FACTOR2_TYPES);

experiment.design.FACTOR3_TYPES                 = [1,2,3];
experiment.design.N_FACTOR3                     = length(experiment.design.FACTOR3_TYPES);    

experiment.design.N_TRIALS_X_COND               = 60;                                         ... 60
experiment.design.N_TRIALS                      = experiment.design.N_TRIALS_X_COND * experiment.design.N_FACTOR1 * experiment.design.N_FACTOR2 * experiment.design.N_FACTOR3;    ... 60 * 3 * 2 * 3 = 1080

experiment.design.TRIAL_LENGTH                  = 5;                                          ... 3 mov +iti
experiment.design.EXP_DURATION                  = (experiment.design.N_TRIALS * experiment.design.TRIAL_LENGTH) / 60;             ... 30 min 


%---------------------------------------------------------------------------------------------
% DEFINITION OF THE PERMUTATION OVER THE FIRST FACTOR

experiment.design.MIN_TRIAL_X_BLOCK1            = experiment.design.N_FACTOR1 * experiment.design.N_FACTOR2 * experiment.design.N_FACTOR3;          ...  3 * 2 * 3 = 18;
experiment.design.MAX_BLOCK1                    = experiment.design.N_TRIALS / experiment.design.MIN_TRIAL_X_BLOCK1;              ... 1080 / 18 = 60

experiment.design.N_BLOCK1                      = 10;
experiment.design.N_TRIALS_X_BLOCK1             = experiment.design.N_TRIALS / experiment.design.N_BLOCK1;                        ... 360 / 10 = 36
experiment.design.BLOCK1_REPETITION_FACTOR      = experiment.design.N_TRIALS_X_BLOCK1 / experiment.design.N_FACTOR1;              ... 36 / 3 = 12

% DO PERMUTATION


experiment.design.factor1_list=[]; ... [1xN_TRIALS]
for f2=1:experiment.design.N_BLOCK1
    ordered_list = repmat(experiment.design.FACTOR1_TYPES, 1, experiment.design.BLOCK1_REPETITION_FACTOR);         ... 1x3 => 1x36
    permutation  = randperm(experiment.design.N_TRIALS_X_BLOCK1);
    experiment.design.factor1_list  = [experiment.design.factor1_list ordered_list(permutation)];
end

%---------------------------------------------------------------------------------------------
% DEFINITION OF THE PERMUTATION OVER THE SECOND FACTOR
% within each FACTOR1 level I have to permute over the number level of FACTOR2 (N_FACTOR2)
% keeping in mind that my minimum block must be composed by at least (N_FACTOR2 * N_FACTOR3) cells

experiment.design.N_TRIALS2                   = experiment.design.N_TRIALS / experiment.design.N_FACTOR1;                                 ... 1080 / 3 = 360;

experiment.design.MIN_TRIAL_X_BLOCK2          = experiment.design.N_FACTOR2 * experiment.design.N_FACTOR3;                                ... 2 * 3
experiment.design.MAX_BLOCK2                  = experiment.design.N_TRIALS2 / experiment.design.MIN_TRIAL_X_BLOCK2;                       ... 360 / 6 = 60;    
    
experiment.design.N_BLOCK2                    = 15;
experiment.design.N_TRIALS_X_BLOCK2           = experiment.design.N_TRIALS2 / experiment.design.N_BLOCK2;                                 ... 360 / 15 = 24;
experiment.design.BLOCK2_REPETITION_FACTOR    = experiment.design.N_TRIALS_X_BLOCK2 / experiment.design.N_FACTOR2;                        ... 24 / 2  = 12

% DO PERMUTATION

experiment.design.factor2_list                = zeros(experiment.design.N_FACTOR1, experiment.design.N_TRIALS2);                             ... 3*360

for f1=1:experiment.design.N_FACTOR1
    temp_factor2_list=[];
    for f2=1:experiment.design.N_BLOCK2
        ordered_list = repmat(experiment.design.FACTOR2_TYPES, 1, experiment.design.BLOCK2_REPETITION_FACTOR);          ... 1x2 => 1x24
        permutation  = randperm(experiment.design.N_TRIALS_X_BLOCK2);
        temp_factor2_list  = [temp_factor2_list ordered_list(permutation)];
    end
    experiment.design.factor2_list(f1,:) = temp_factor2_list;
end



%---------------------------------------------------------------------------------------------
% DEFINITION OF THE PERMUTATION OVER THE THIRD FACTOR
% within each FACTOR1 level and FACTOR2 level I have to permute over the number level of FACTOR3 (N_FACTOR3)

experiment.design.N_TRIALS3                   = experiment.design.N_TRIALS / (experiment.design.N_FACTOR2 * experiment.design.N_FACTOR3);                   ... 1080 / 2*3 = 180;

experiment.design.MIN_TRIAL_X_BLOCK3          = experiment.design.N_FACTOR3;                                            ... 3
experiment.design.MAX_BLOCK3                  = experiment.design.N_TRIALS3 / experiment.design.MIN_TRIAL_X_BLOCK3;                       ... 180 / 3 = 60;    
    
experiment.design.N_BLOCK3                    = 15;
experiment.design.N_TRIALS_X_BLOCK3           = experiment.design.N_TRIALS3 / experiment.design.N_BLOCK3;                                 ... 180 / 15 = 12;
experiment.design.BLOCK3_REPETITION_FACTOR    = experiment.design.N_TRIALS_X_BLOCK3 / experiment.design.N_FACTOR3;                        ... 12 / 3  = 4

% DO PERMUTATION

experiment.design.factor3_list                = zeros(experiment.design.N_FACTOR1,experiment.design.N_FACTOR2, experiment.design.N_TRIALS3);                ... 3*2*180

for f1=1:experiment.design.N_FACTOR1
    for f2=1:experiment.design.N_FACTOR2
        temp_factor3_list=[];
        for f3=1:experiment.design.N_BLOCK3
            ordered_list = repmat(experiment.design.FACTOR3_TYPES, 1, experiment.design.BLOCK3_REPETITION_FACTOR);   ... 1x3 => 1x12
            permutation  = randperm(experiment.design.N_TRIALS_X_BLOCK3);
            temp_factor3_list  = [temp_factor3_list ordered_list(permutation)];
        end
        experiment.design.factor3_list(f1,f2,:) = temp_factor3_list;
    end
end


%---------------------------------------------------------------------------------------------
% questions & rest

experiment.design.N_RANDOM_QUESTIONS    = 24; 
experiment.design.QUESTIONS_JITTER      = 2;                        
experiment                              = exp_define_questions_onsets(experiment);

% define when to rest : two pauses are planned for children (mode 0), 4 pauses for adults (mode 1 & 2)
experiment.design.rest_appearence      = zeros(1, experiment.design.N_TRIALS);


%---------------------------------------------------------------------------------------------
% clean up

clear temp_factor2_list
clear temp_factor3_list
clear ordered_list
clear permutation
clear f1
clear f2
clear f3
