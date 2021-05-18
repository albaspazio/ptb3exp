% 3x2x3 experiment: 


FACTOR1_TYPES               = [1 2 3];     
N_FACTOR1                   = length(FACTOR1_TYPES1);    

FACTOR2_TYPES               = [1,2];
N_FACTOR2                   = length(FACTOR2_TYPES);

FACTOR3_TYPES               = [1,2,3];
N_FACTOR3                   = length(FACTOR3_TYPES);    

N_TRIALS_X_COND             = 60;                                         ... 60
N_TRIALS                    = N_TRIALS_X_COND * N_FACTOR1 * N_FACTOR2 * N_FACTOR3;    ... 60 * 3 * 2 * 3 = 1080

TRIAL_LENGTH                = 5;                                          ... 3 mov +iti
EXP_DURATION                = (N_TRIALS * TRIAL_LENGTH) / 60;             ... 30 min 


%---------------------------------------------------------------------------------------------
% DEFINITION OF THE PERMUTATION OVER THE FIRST FACTOR

MIN_TRIAL_X_BLOCK1          = N_FACTOR1 * N_FACTOR2 * N_FACTOR3;          ...  3 * 2 * 3 = 18;
MAX_BLOCK1                  = N_TRIALS / MIN_TRIAL_X_BLOCK1;              ... 1080 / 18 = 60

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
% within each FACTOR1 level I have to permute over the number level of FACTOR2 (N_FACTOR2)
% keeping in mind that my minimum block must be composed by at least (N_FACTOR2 * N_FACTOR3) cells

N_TRIALS2                   = N_TRIALS / N_FACTOR1;                                 ... 1080 / 3 = 360;

MIN_TRIAL_X_BLOCK2          = N_FACTOR2 * N_FACTOR3;                                ... 2 * 3
MAX_BLOCK2                  = N_TRIALS2 / MIN_TRIAL_X_BLOCK2;                       ... 360 / 6 = 60;    
    
N_BLOCK2                    = 15;
N_TRIALS_X_BLOCK2           = N_TRIALS2 / N_BLOCK2;                                 ... 360 / 15 = 24;
BLOCK2_REPETITION_FACTOR    = N_TRIALS_X_BLOCK2 / N_FACTOR2;                        ... 24 / 2  = 12

% DO PERMUTATION

factor2_list                = zeros(N_FACTOR1, N_TRIALS2);                             ... 3*360

for f1=1:N_FACTOR1
    temp_factor2_list=[];
    for f2=1:N_BLOCK2
        ordered_list = repmat(FACTOR2_TYPES, 1, BLOCK2_REPETITION_FACTOR);          ... 1x2 => 1x24
        permutation  = randperm(N_TRIALS_X_BLOCK2);
        temp_factor2_list  = [temp_factor2_list ordered_list(permutation)];
    end
    factor2_list(f1,:) = temp_factor2_list;
end



%---------------------------------------------------------------------------------------------
% DEFINITION OF THE PERMUTATION OVER THE THIRD FACTOR
% within each FACTOR1 level and FACTOR2 level I have to permute over the number level of FACTOR3 (N_FACTOR3)

N_TRIALS3                   = N_TRIALS / (N_FACTOR2 * N_FACTOR3);                   ... 1080 / 2*3 = 180;

MIN_TRIAL_X_BLOCK3          = N_FACTOR3;                                            ... 3
MAX_BLOCK3                  = N_TRIALS3 / MIN_TRIAL_X_BLOCK3;                       ... 180 / 3 = 60;    
    
N_BLOCK3                    = 15;
N_TRIALS_X_BLOCK3           = N_TRIALS3 / N_BLOCK3;                                 ... 180 / 15 = 12;
BLOCK3_REPETITION_FACTOR    = N_TRIALS_X_BLOCK3 / N_FACTOR3;                        ... 12 / 3  = 4

% DO PERMUTATION

factor3_list                = zeros(N_FACTOR1,N_FACTOR2, N_TRIALS3);                ... 3*2*180

for f1=1:N_FACTOR1
    for f2=1:N_FACTOR2
        temp_factor3_list=[];
        for f3=1:N_BLOCK3
            ordered_list = repmat(FACTOR3_TYPES, 1, BLOCK3_REPETITION_FACTOR);   ... 1x3 => 1x12
            permutation  = randperm(N_TRIALS_X_BLOCK3);
            temp_factor3_list  = [temp_factor3_list ordered_list(permutation)];
        end
        factor3_list(f1,f2,:) = temp_factor3_list;
    end
end
%---------------------------------------------------------------------------------------------
% clean up

clear temp_factor2_list
clear temp_factor3_list
clear ordered_list
clear permutation
clear f1
clear f2
clear f3