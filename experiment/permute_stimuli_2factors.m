% 3x2 experiment: 


experiment.design.FACTOR1_TYPES                 = [1 2 3 4 5 6];                ... conditions
experiment.design.N_FACTOR1                     = length(experiment.design.FACTOR1_TYPES);    

experiment.design.FACTOR2_TYPES                 = [1 2 3 4 5 6];
experiment.design.N_FACTOR2                     = length(experiment.design.FACTOR2_TYPES);    ... video types
    
experiment.design.N_TRIALS_X_COND               = 8;                                          ... 8
experiment.design.N_TRIALS                      = experiment.design.N_TRIALS_X_COND * experiment.design.N_FACTOR1 * experiment.design.N_FACTOR2;    ... 8 * 36 = 288

experiment.design.TRIAL_LENGTH                  = 5;                                          ... 3 mov +iti
experiment.design.EXP_DURATION                  = (experiment.design.N_TRIALS * experiment.design.TRIAL_LENGTH) / 60;             ... 30 min 


% DEFINITION OF THE PERMUTATION OVER THE FIRST FACTOR

experiment.design.MIN_TRIAL_X_BLOCK1            = experiment.design.N_FACTOR1 * experiment.design.N_FACTOR2;                      ...  6 * 6 = 36;
experiment.design.MAX_BLOCK1                    = experiment.design.N_TRIALS / experiment.design.MIN_TRIAL_X_BLOCK1;              ... 288 / 36 = 12

experiment.design.N_BLOCK1                      = 8;
experiment.design.N_TRIALS_X_BLOCK1             = experiment.design.N_TRIALS / experiment.design.N_BLOCK1;                        ... 288 / 8 = 36
experiment.design.BLOCK1_REPETITION_FACTOR      = experiment.design.N_TRIALS_X_BLOCK1 / experiment.design.N_FACTOR1;              ...  36 / 6 = 6

% DO PERMUTATION


experiment.design.factor1_list=[]; ... [1xN_TRIALS]
for f2=1:experiment.design.N_BLOCK1
    ordered_list = repmat(experiment.design.FACTOR1_TYPES, 1, experiment.design.BLOCK1_REPETITION_FACTOR);         ... 1x6 => 1x36
    permutation  = randperm(experiment.design.N_TRIALS_X_BLOCK1);
    experiment.design.factor1_list  = [experiment.design.factor1_list ordered_list(permutation)];
end

%---------------------------------------------------------------------------------------------
% DEFINITION OF THE PERMUTATION OVER THE SECOND FACTOR
% within each CONFLICT_TYPE, I have to permute the number of directions

experiment.design.N_TRIALS2                   = experiment.design.N_TRIALS / experiment.design.N_FACTOR1;                ... 288 / 6 = 48;

experiment.design.MIN_TRIAL_X_BLOCK2          = experiment.design.N_FACTOR2;                                             ... 6
experiment.design.MAX_BLOCK2                  = experiment.design.N_TRIALS2 / experiment.design.MIN_TRIAL_X_BLOCK2;      ... 48 / 6 = 8;    
    
experiment.design.N_BLOCK2                    = 4;
experiment.design.N_TRIALS_X_BLOCK2           = experiment.design.N_TRIALS2 / experiment.design.N_BLOCK2;                ... 48 / 4 = 12;
experiment.design.BLOCK2_REPETITION_FACTOR    = experiment.design.N_TRIALS_X_BLOCK2 / experiment.design.N_FACTOR2;       ... 12 / 6 = 2

% DO PERMUTATION

experiment.design.factor2_list = zeros(experiment.design.N_FACTOR1, experiment.design.N_TRIALS2);   ... 6*48

for f1=1:experiment.design.N_FACTOR1
    temp_factor2_list=[];
    for f2=1:experiment.design.N_BLOCK2
        ordered_list        = repmat(experiment.design.FACTOR2_TYPES, 1, experiment.design.BLOCK2_REPETITION_FACTOR);   ... 1x6 => 1x12
        permutation         = randperm(experiment.design.N_TRIALS_X_BLOCK2);
        temp_factor2_list   = [temp_factor2_list ordered_list(permutation)];
    end
    experiment.design.factor2_list(f1,:) = temp_factor2_list;
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
clear temp_factor2_list; clear ordered_list; clear permutation; clear f1; clear f2;
%---------------------------------------------------------------------------------------------

