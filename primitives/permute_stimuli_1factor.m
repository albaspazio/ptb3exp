% 3x2 experiment: 


FACTOR1_TYPES               = [1 2 3];     
N_FACTOR1                   = length(FACTOR1_TYPES);    

N_TRIALS_X_COND             = 60;                                         ... 60
N_TRIALS                    = N_TRIALS_X_COND * N_FACTOR1;                ... 60 * 3 = 180

TRIAL_LENGTH                = 0.1;                                        ... 3 mov +iti
EXP_DURATION                = (N_TRIALS * TRIAL_LENGTH) / 60;             ... 30 min 


% DEFINITION OF THE PERMUTATION OVER THE FIRST FACTOR

MIN_TRIAL_X_BLOCK1          = N_FACTOR1;                                    ...  3;
MAX_BLOCK1                  = N_TRIALS / MIN_TRIAL_X_BLOCK1;                ... 180 / 3 = 60

N_BLOCK1                    = 20;
N_TRIALS_X_BLOCK1           = N_TRIALS / N_BLOCK1;                        ... 180 / 20 = 9
BLOCK1_REPETITION_FACTOR    = N_TRIALS_X_BLOCK1 / N_FACTOR1;              ... 9 / 3 = 3

% DO PERMUTATION


factor1_list=[]; ... [1xN_TRIALS]
for f2=1:N_BLOCK1
    ordered_list = repmat(FACTOR1_TYPES, 1, BLOCK1_REPETITION_FACTOR);         ... 1x3 => 1x36
    permutation  = randperm(N_TRIALS_X_BLOCK1);
    factor1_list  = [factor1_list ordered_list(permutation)];
end


%---------------------------------------------------------------------------------------------
% clean up

clear ordered_list
clear permutation
clear f2