% % Programma per eseguire il test dei video
%
% % TEST 1
% % Inizializzazione delle psychtoolbox
% screenNumbers=Screen('Screens');
% screenN = max(screenNumbers);
% [win,rect]=Screen('OpenWindow',screenN ,[0 0 0]);
% moviefile = 'C:\Users\Marco\Documents\WorkingDIR\EEG_Tools\global_scripts\ptb3\FINAL\video\ao01.mp4';
%
%
% % Open movie file:
% [movie,duration,fps,width,height,count,aspectRatio]=Screen('OpenMovie', win, moviefile);
%
%
% % Start playback engine:
% droppedframe = Screen('PlayMovie', movie, 1);
% tex = zeros(count,1);
% to = GetSecs;
% for j = 1:count
%     % Wait for next movie frame, retrieve texture handle to it
%     tex(j) = Screen('GetMovieImage', win, movie);
% end
% Tread = GetSecs - to;
%
% for j = 1:count-1
% % Draw the new texture immediately to screen:
% Screen('DrawTexture', win, tex(j));
%
% % Update display:
% Screen('Flip', win);
% Screen('Close', tex(j));
% end
% % Release texture:
%
% % Stop playback:
% Screen('PlayMovie', movie, 0);
% % Close movie:
% Screen('CloseMovie', movie);
% sca



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Programma per eseguire il test dei video
% 
% % TEST 2
% % Inizializzazione delle psychtoolbox
% Screen('Preference','SkipSyncTests')
% screenNumbers=Screen('Screens');
% screenN = max(screenNumbers);
% [win,rect]=Screen('OpenWindow',screenN ,[0 0 0]);
% moviefile = 'C:\Users\Marco\Documents\WorkingDIR\EEG_Tools\global_scripts\ptb3\FINAL\video\ao05.mp4';
% 
% 
% % Open movie file:
% [movie,duration,fps,width,height,count,aspectRatio]=Screen('OpenMovie', win, moviefile);
% 
% % Start playback engine:
% droppedframe = Screen('PlayMovie', movie, 1);
% to = GetSecs;
% 
% 
% 
% Tread = GetSecs - to;
% %Delta = zeros(89,1);
% for j = 1:90
%     %to = GetSecs;
%     [tex] = Screen('GetMovieImage', win, movie,[],[],[0],[0]);
%     %Delta(j) = GetSecs - to;
%     
%     % Draw the new texture immediately to screen:
%     Screen('DrawTexture', win, tex);
%     if j == 1 || j == 89
%         Screen('FillRect', win, [255 255 255 ] ,[0 0 250 250] );
%     end
%     
%     % Update display:
%     Screen('Flip', win);
%     Screen('Close', tex);
%     j
% end
% % Release texture:
% 
% % Stop playback:
% droppedframe = Screen('PlayMovie', movie, 0);
% % Close movie:
% Screen('CloseMovie', movie);
% sca
% hold on
% plot(Delta,'.-')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TEST3
% Inizializzazione delle psychtoolbox
AssertOpenGL

screenNumbers=Screen('Screens');
screenN = max(screenNumbers);
[win,rect]=Screen('OpenWindow',screenN ,[0 0 0]);
moviefile = 'C:\Users\Marco\Documents\WorkingDIR\EEG_Tools\global_scripts\ptb3\FINAL\video\prova50.avi';
Screen('Flip', win);

% Open movie file:
%[movie movieduration fps imgw imgh] = Screen('OpenMovie', win, moviename, [], preloadsecs, [], pixelFormat, maxThreads);
[movie,duration,fps,width,height,count,aspectRatio]=Screen('OpenMovie', win, moviefile,[],[],[],[],[]);

try
    frame_counter=0;
    droppedframe = Screen('PlayMovie', movie, 1);
    
    j = 0;
    Delta = zeros(count,1);
    to = GetSecs;
    while j<(count-1)
        j = j+ 1;
        %to = GetSecs;
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', win, movie);
        %Delta(j) = GetSecs - to;
        %if j == 1 || j == count-1
        %    Screen('FillRect', win, [255 255 255 ] ,[0 0 250 250] );
        %end
        
        % Valid texture returned? A negative value means end of movie reached:
        
        if tex<=0
            
            % We're done, break out of loop:
            break;
        end;
        
        
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', win, tex);
        
        % Update display:
    
        Screen('Flip', win);
        if j == 1
            to = GetSecs;
        end
        
        if j == (count-1)
           Dt = GetSecs - to;
        end
        
        frame_counter=frame_counter+1;
        
        %     if (frame_counter == 1)
        %         if~test
        %             put_trigger(video_trigger_value,dio,duration);
        %         end
        %
        %      elseif (frame_counter == audio_frame)
        %         %reproduce audio pre-loaded in the sound card
        %         trigger(ao);
        %         if~test
        %             put_trigger(audio_trigger_value,dio,duration);
        %         end
        %     end
        
        % Release texture:
        Screen('Close', tex);
    end;
    %Ttot = GetSecs - to;
    
    % Stop playback:
    Screen('PlayMovie', movie, 0);
    
    % Close movie:
    Screen('CloseMovie', movie);
    sca
    plot(Delta,'.-')
    
catch
    psychrethrow(psychlasterror);
    sca;
end