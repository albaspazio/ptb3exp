% functions:
% play a sound

% playAudio(FILE_AUDIO, AO) where 
%
% FILE_AUDIO:    respective full paths of the files containing the video and the audio (supposed to be in .wav format) to be reproduced
% AO:                           object mapping the device used to reproduce the audio. At the moment it is the soundcard but in feauture release a NI card could be used instead 

% AO creation example
% set the sound card to load and send audios when required. create an object mapping the soundcard
%ao = analogoutput('winsound');
% set the trigger to manual to use the trigger() and get a faster sound reproduction
%set(ao,'TriggerType','Manual')
%add an audio channel to the sound card to reproduce the sound
%chans = addchannel(ao,1);

function playAudio(file_audio, ao)

if nargin < 1 || isempty(file_audio)
    disp('input audio file name not specified');
    return
end

try

 % read the audio file: collect the signal and the sampling frequency
 [s,fc] = wavread(file_audio);
 %set the sound card to the right sampling frequency
 set(ao,'SampleRate',fc);
 %load the sound to the sound card
 putdata(ao,s(:,1));
 %initialize the soundcard
 start(ao);
 trigger(ao);
 
catch
  psychrethrow(psychlasterror);
end

return;