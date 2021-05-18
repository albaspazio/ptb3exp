% functions:
% play a movie and load a sound at a specified frame

% showMovieAudio(FILE_VIDEO, FILE_AUDIO, WIN, AUDIO_FRAME, AO) where 
%
% FILE_VIDEO and FILE_AUDIO:    respective full paths of the files containing the video and the audio (supposed to be in .wav format) to be reproduced
% WIN:                          window where the video is reproduced
% AUDIO_FRAME:                  frame of the video when the audio should be reproduced
% AO:                           object mapping the device used to reproduce the audio. At the moment it is the soundcard but in feauture release a NI card could be used instead 

% AO creation example
% set the sound card to load and send audios when required. create an object mapping the soundcard
%ao = analogoutput('winsound');
% set the trigger to manual to use the trigger() and get a faster sound reproduction
%set(ao,'TriggerType','Manual')
%add an audio channel to the sound card to reproduce the sound
%chans = addchannel(ao,1);

function showMovieAudio(file_video, file_audio, win, audio_frame, ao)

isWindow=0;
if  strncmp(system_dependent('getos'),'Microsoft',9)
    isWindow=1;
end

 %set the sound card to the right sampling frequency
 if isWindow
     % read the audio file: collect the signal and the sampling frequency
     [s,fc] = wavread(file_audio);
     set(ao,'SampleRate',fc);
     %load the sound to the sound card
     putdata(ao,s(:,1));
     %initialize the soundcard
     start(ao);
 end

if nargin < 1 || isempty(file_video)
    disp('input file name not specified');
    return
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
    
    if (frame_counter == audio_frame)   
        %reproduce audio pre-loaded in the sound card
          if isWindow
             trigger(ao);
         end
    end      

    % Release texture:
    Screen('Close', tex);
end;

% Stop playback:
Screen('PlayMovie', movie, 0);

% Close movie:
Screen('CloseMovie', movie);

catch
  psychrethrow(psychlasterror);
  sca;
end

return;