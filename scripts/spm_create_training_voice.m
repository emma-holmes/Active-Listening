function spm_create_training_voice(str)

% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: spm_voice.m 7653 2019-08-09 09:56:25Z karl $


%% prompt for audio file: 32 words, at one word per second
%--------------------------------------------------------------------------
audio = audiorecorder(16000,16,1);
[FS,read] = spm_voice_FS(audio);
stop(audio);

% countdown
%--------------------------------------------------------------------------
for i = 3:-1:1
    clc,disp(i);          pause(0.5)
    clc,disp('    -*- '); pause(0.5)
end

% record
%--------------------------------------------------------------------------
record(audio,34);
for i = 1:33
    clc,disp(str);        pause(0.5)
    clc,disp('    -*- '); pause(0.5)
end

% save
%--------------------------------------------------------------------------
PATH  = 'D:\PhD\Code\spm12\sound_files';
Y     = read(audio);
try
    delete(fullfile(PATH,[str '.wav']))
end
audiowrite(fullfile(PATH,[str '.wav']),Y,FS)

