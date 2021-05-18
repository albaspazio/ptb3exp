
% ===================================================================
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'SuppressAllWarnings', 1);

W=800; H=600; rec = [0,0,W,H]; 
...rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);

[window, rect] = Screen('OpenWindow', 0, [0 0 0], rec);


<<<<<<< .mine
showMovie('video.mp4', window);
=======
showMovie('/media/geo_repository/groups/behaviour_lab/Projects/PAP/cp_aos/experiment/media/FINAL/version2/video/compressed/video_l/ao01.mp4', window);
...showMovie('/data/behavior_lab_svn/behaviourPlatform/CommonScript/ptb3/demo_scripts/video.avi', window);
>>>>>>> .r3397
