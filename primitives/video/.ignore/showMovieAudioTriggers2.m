% functions:
% play a movie
% send a first trigger after the Screen('Flip') of the first frame 
% send a second trigger after the Screen('Flip') of at the frame specified [AUDIO_FRAME]

% showMovieSendDoubleTrigger(FILE_VIDEO, FILE_AUDIO, WIN, DIO, STARTVIDEO_TRIGGER_VALUE, ENDVIDEO_TRIGGER_VALUE, AUDIO_LATENCY, AUDIO_TRIGGER_VALUE,TEST,DURATION,AO) where 
%
% FILE_VIDEO and FILE_AUDIO:    respective full paths of the files containing the video and the audio (supposed to be in .wav format) to be reproduced
% WIN:                          window where the video is reproduced
% DIO:                          object mapping a parallel port. it has to be previously created by dio=dio=digitalio('parallel','PARALLEL_NAME') 
%                               and initialized by line=addline(dio,0:m,'out'); where m is the number of trigger types - 1
% STARTVIDEO_TRIGGER_VALUE:     trigger codes corresponding to video START 
% ENDVIDEO_TRIGGER_VALUE:       trigger codes corresponding to video END 
% AUDIO_TRIGGER_VALUE:          trigger codes corresponding to audio START
% AUDIO_LATENCY:                latency (in secs) of the video when the audio should be reproduced
% TEST:                         if =1 it enables the test mode (without sending triggers) in case the parallel port is not connected
% DURATION:                     required duration of the trigger (to avoid trigger overlapping AND trigger detection even subsampling)
% AO:                           object mapping the device used to reproduce the audio. At the moment it is the soundcard but in feauture release a NI card could be used instead 

function showMovieAudioTriggers2(file_video, file_audio, win, dio, startvideo_trigger_value, endvideo_trigger_value, audio_latency, audio_trigger_value,test,duration,ao)

 % read the audio file: collect the signal and the sampling frequency
 [s,fc] = wavread(file_audio);
 %set the sound card to the right sampling frequency
 set(ao,'SampleRate',fc);
 %load the sound to the sound card
 putdata(ao,s(:,1));
 %initialize the soundcard
 start(ao);

if nargin < 1 || isempty(file_video)
    disp('input file name not specified');
    return
end

try

% Open movie file:
[movie,duration,fps,width,height,count,aspectRatio]=Screen('OpenMovie', win, file_video);

% Start playback engine:
Screen('PlayMovie', movie, 1);

frame=0;
start_time = GetSecs;
can_trigger_audio=1;

% Playback loop: Runs until end of movie
while frame<(count-1)
    
    frame=frame+1;
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, movie);

    % should never enter the following test as we skipped the last call to
    % Screen('GetMovieImage' as it returns -1 and lasts 3-400 ms
    % Valid texture returned? A negative value means end of movie reached:
    %if tex<=0
        % We're done, break out of loop:
        %break;
    %end;
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    % Update display:
    Screen('Flip', win);
    
    if (frame == 1)
        if~test 
            put_trigger(startvideo_trigger_value,dio,duration);
        end
    end
    
    if can_trigger_audio
        if ( (GetSecs-start_time) >= audio_latency)
            %reproduce audio pre-loaded in the sound card
            trigger(ao);
            if~test
                put_trigger(audio_trigger_value,dio,duration);             
            end
            can_trigger_audio=0;
        end      
    end

    % Release texture:
    Screen('Close', tex);
end;

if~test 
    put_trigger(endvideo_trigger_value, dio, duration);
end  

% Stop playback:
Screen('PlayMovie', movie, 0);

% Close movie:
Screen('CloseMovie', movie);

catch
  psychrethrow(psychlasterror);
  sca;
end

return;