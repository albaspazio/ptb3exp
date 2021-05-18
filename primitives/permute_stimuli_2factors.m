% 3x2 experiment: 


FACTOR1_TYPES               = [1 2 3];     
N_FACTOR1                   = length(FACTOR1_TYPES1);    

FACTOR2_TYPES               = [1,2];
N_FACTOR2                   = length(FACTOR2_TYPES);    
    
N_TRIALS_X_COND             = 60;                                         ... 60
N_TRIALS                    = N_TRIALS_X_COND * N_FACTOR1 * N_FACTOR2;    ... 60 * 3 * 2 = 360

TRIAL_LENGTH                = 5;                                          ... 3 mov +iti
EXP_DURATION                = (N_TRIALS * TRIAL_LENGTH) / 60;             ... 30 min 


% DEFINITION OF THE PERMUTATION OVER THE FIRST FACTOR

MIN_TRIAL_X_BLOCK1          = N_FACTOR1 * N_FACTOR2;                      ...  3 * 2 = 6;
MAX_BLOCK1                  = N_TRIALS / MIN_TRIAL_X_BLOCK1;              ... 360 / 6 = 60

N_BLOCK1                    = 10;
N_TRIALS_X_BLOCK1           = N_TRIALS / N_BLOCK1;                        ... 360 / 10 = 36
BLOCK1_REPETITION_FACTOR    = N_TRIALS_X_BLOCK1 / N_FACTOR1;              ... 36 / 3 = 12

% DO PERMUTATION


factor1_list=[]; ... [1xN_TRIALS]
for f2=1:N_BLOCK1
    ordered_list = repmat(FACTOR1_TYPES, 1, BLOCK1_REPETITION_FACTOR);         ... 1x3 => 1x36
    permutation  = randperm(N_TRIALS_X_BLOCK1);
    factor1_list  = [factor1_list ordered_list(permutation)];
end

%---------------------------------------------------------------------------------------------
% DEFINITION OF THE PERMUTATION OVER THE SECOND FACTOR
% within each CONFLICT_TYPE I have to permute the number of directions

N_TRIALS2                   = N_TRIALS / N_FACTOR1;                                  ... 360 / 3 = 120;

MIN_TRIAL_X_BLOCK2          = N_FACTOR2;                                             ... 2
MAX_BLOCK2                  = N_TRIALS2 / MIN_TRIAL_X_BLOCK2;                           ... 120 / 2 = 60;    
    
N_BLOCK2                    = 15;
N_TRIALS_X_BLOCK2           = N_TRIALS2 / N_BLOCK2;                                     ... 120 / 15 = 8;
BLOCK2_REPETITION_FACTOR    = N_TRIALS_X_BLOCK2 / N_FACTOR2;                         ... 8 / 2 = 4

% DO PERMUTATION

factor2_list                = zeros(N_FACTOR1, N_TRIALS2);   ... 3*120

for f1=1:N_FACTOR1
    temp_factor2_list=[];
    for f2=1:N_BLOCK2
        ordered_list = repmat(FACTOR2_TYPES, 1, BLOCK2_REPETITION_FACTOR);   ... 1x2 => 1x8
        permutation  = randperm(N_TRIALS_X_BLOCK2);
        temp_factor2_list  = [temp_factor2_list ordered_list(permutation)];
    end
    factor2_list(f1,:) = temp_factor2_list;
end

%---------------------------------------------------------------------------------------------
% clean up

clear temp_CONFL_TYPE_list
clear ordered_list
clear permutation
clear f1
clear f2