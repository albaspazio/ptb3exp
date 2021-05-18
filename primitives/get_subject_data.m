function [session_number, log_file, log_fp] = get_subject_data(subject_data_path)

    if ~ isequal(exist(subject_data_path, 'dir'),7)
        mkdir(subject_data_path);
    end
    
    session_number   = 1;
    log_file         = fullfile(subject_data_path, ['log_subject' num2str(session_number) '.txt']);

    % get first available session ID
    while exist(log_file, 'file')
        session_number   = session_number+1;
        log_file         = fullfile(subject_data_path, ['log_subject' num2str(session_number) '.txt']);
    end

    % ask for confirmation, and check if available
    while 1
        str_session_number    = input(['please insert SUBJECT ID (should be ' num2str(session_number) ') :'],'s');
        log_file              = fullfile(subject_data_path, ['log_subject' str_session_number '.txt']);
        if ~exist(log_file, 'file')
            break;
        end
    end
    session_number   = str2num(str_session_number);

    [log_fp, message]  = fopen(log_file,'w+');
    if log_fp == -1
        disp('---------------------------------------')
        disp('error opening file descriptor');
        disp(message);
        disp('---------------------------------------')
        error('stop');
    end
end