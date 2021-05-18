% functions:
% play a movie
% send a first trigger after the Screen('Flip') of the first frame 
% send a second trigger after the Screen('Flip') of at the frame specified [AUDIO_FRAME]

% showMovieSendDoubleTrigger(FILE_VIDEO, FILE_AUDIO, WIN, DIO, VIDEO_TRIGGER_VALUE, AUDIO_FRAME, AUDIO_TRIGGER_VALUE,TEST,DURATION,AO) where 
%
% FILE_VIDEO and FILE_AUDIO:    respective full paths of the files containing the video and the audio (supposed to be in .wav format) to be reproduced
% WIN:                          window where the video is reproduced
% DIO:                          object mapping a parallel port. it has to be previously created by dio=dio=digitalio('parallel','PARALLEL_NAME') 
%                               and initialized by line=addline(dio,0:m,'out'); where m is the number of trigger types - 1
% VIDEO_TRIGGER_VALUE:          trigger codes corresponding respectively to the video and to the audio: 
% AUDIO_TRIGGER_VALUE:          they should be 2^(n-1) where n is the number of type of the trigger 
% AUDIO_FRAME:                  frame of the video when the audio should be reproduced
% TEST:                         if =1 it enables the test mode (without sending triggers) in case the parallel port is not connected
% DURATION:                     required duration of the trigger (to avoid trigger overlapping AND trigger detection even subsampling)
% AO:                           object mapping the device used to reproduce the audio. At the moment it is the soundcard but in feauture release a NI card could be used instead\
%                               in linux is the return of:              pahandle = PsychPortAudio('Open', device_id, [], 0, [], nrchannels);
%                               in Windows with daq is the return of:   ao = analogoutput('winsound');


function showMovieAudioTriggers(file_video, file_audio, win, dio, start_video_trigger_value, audio_frame, audio_trigger_value,end_video_trigger, send_out_trigger,duration,ao)

    if isempty(file_audio) || isempty(file_video)
        disp('input file name not specified');
        return
    end

    isWindow=0;
    if  strncmp(system_dependent('getos'),'Microsoft',9)
        isWindow=1;
    end

    if isWindow
        % read the audio file: collect the signal and the sampling frequency
        [s,fc] = wavread(file_audio);
        %set the sound card to the right sampling frequency    
        set(ao,'SampleRate',fc);
        %load the sound to the sound card
        putdata(ao,s(:,1));
        %initialize the soundcard
        start(ao);
    else
        [s,fc] = wavread(file_audio);
        wavedata = s';
        PsychPortAudio('FillBuffer', ao, wavedata);    
    end

    try

        % Open movie file:
        movie = Screen('OpenMovie', win, file_video);

        % Start playback engine:
        Screen('PlayMovie', movie, 1);

        frame_counter=0;

        % Playback loop: Runs until end of movie or keypress:
        while 1
            % Wait for next movie frame, retrieve texture handle to it
            tex = Screen('GetMovieImage', win, movie);

            % Valid texture returned? A negative value means end of movie reached:
            frame_counter=frame_counter+1;
            if tex<=0
                % We're done, break out of loop:
                break;
            end;

            % Draw the new texture immediately to screen:
            Screen('DrawTexture', win, tex);

            % Update display:
            Screen('Flip', win);

            if (frame_counter == 1)
                if send_out_trigger 
                    put_trigger(start_video_trigger_value,dio,duration);
                end
            end

            if (frame_counter == audio_frame)   
                %reproduce audio pre-loaded in the sound card
                if isWindow
                    trigger(ao); 
                else
                    PsychPortAudio('Start', ao, 1, 0, 1);            
                end
                if send_out_trigger && audio_trigger_value
                    put_trigger(audio_trigger_value,dio,duration);             
                end
            end      

            % Release texture:
            Screen('Close', tex);
        end;

        % Stop playback:
        Screen('PlayMovie', movie, 0);
        PsychPortAudio('Stop', ao, 1);
        
        if send_out_trigger 
            put_trigger(end_video_trigger,dio,duration);
        end        
        % Close movie:
        Screen('CloseMovie', movie);
    catch
        psychrethrow(psychlasterror);
        sca;
    end

    return;
end