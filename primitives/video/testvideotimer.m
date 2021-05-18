% PSYCHTOOLBOX video test: multisensory Action Observation for adults and children (healthy and Cerebral Palsy)
% Author: Alberto Inuggi, November 2013.


function testvideotimer(win, file_video, trigger_value, sound_obj, trigger_obj)

    showCross(win, 0, [255 255 255], 3);        ... showCross(window2, 0,,  white, 3); 
    WaitSecs(0.5);
    scope = 'testvideotimer';
    ...showMovieFromMatrixWithTimer(file_video, window1, 'sound_obj', sound_obj, 'end_callback', @onNextVideo);
    video = cShowMovieTimer(file_video, win, 'sound_obj', sound_obj, 'end_callback', @onNextVideo);
end

function onNextVideo(par)

    scope = 'onNextVideo';

    num_video               = evalin('base', 'length(video_list)');
    evalin('base', 'curr_video=curr_video+1;');
    curr_video              = evalin('base', 'curr_video;');
    
    if curr_video <= num_video
        file_video              = evalin('base', 'fullfile(input_video_folder, [video_list{curr_video} video_file_extension])');
        file_audio              = evalin('base', 'fullfile(input_audio_folder, [audio_list{curr_video} audio_file_extension])');
        trigger_value           = evalin('base', 'triggers_list{curr_video}');
        trigger_obj             = evalin('base', 'trigger_obj');
        win                     = evalin('base', 'window1');


        sound_obj               = evalin('base', 'sound_obj');
        sound_obj.file_audio    = file_audio;

        testvideotimer(win, file_video, trigger_value, sound_obj, trigger_obj);    
    end
end