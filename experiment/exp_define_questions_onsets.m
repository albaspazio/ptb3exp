function experiment = exp_define_questions_onsets(experiment)

    experiment.design.N_STIMULI_NO_QUESTIONS    = experiment.design.N_TRIALS - experiment.design.N_RANDOM_QUESTIONS;
    experiment.design.question_appearance       = zeros(1, experiment.design.N_TRIALS);

    qapp        = linspace(1, experiment.design.N_TRIALS, experiment.design.N_RANDOM_QUESTIONS+2);
    qapp        = qapp(2:end-1);
    rand_vect   = experiment.design.QUESTIONS_JITTER*(2*rand(1, experiment.design.N_RANDOM_QUESTIONS) - 1);  ... QUESTIONS_JITTER * (-1:1)
    qapp        = round(qapp+rand_vect);   ... put a random jitter on the regularly spaced vector

    for i=1:experiment.design.N_RANDOM_QUESTIONS
        experiment.design.question_appearance(qapp(i)) = 1;
    end

end