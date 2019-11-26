%% RUN_DEMO
% Emma Holmes 21/09/2019


%% Add scripts and sound files to path

% Specify folders
root_dir      	= pwd;
sound_dir       = fullfile(root_dir, 'sound_files');
script_dir   	= fullfile(root_dir, 'scripts');

% Check folders exist
if ~exist(sound_dir, 'dir')
    fprintf('\n\nSearching for folder: %s\n', sound_dir);
    error('Error: Could not folder! Check "sound_files" directory is a valid sub-directory');
end
if ~exist(script_dir, 'dir')
    fprintf('\n\nSearching for folder: %s\n', script_dir);
    error('Error: Could not folder! Check "scripts" directory is a valid sub-directory');
end

% Add scripts directory to path
addpath(script_dir);


%% Check SPM version

% Check spm in path
try
    [~,version] = spm('Ver','',1); 
    version = str2double(version);
catch
    error('Error: SPM cannot be found in MATLAB path.');
end

% Check using SPM12
if ~strcmpi(spm('Ver'), 'SPM12')
    error('Error: Please add SPM12 to you MATLAB path.');
end

% Check version of SPM
if version ~= 7487
    fprintf('\n\nYour version of SPM: %d\n', version);
    warning('Warning: These scripts have been tested to work with SPM version 7487, and may not work with your version');
end
    

%% Run active listening demo
spm_voice(sound_dir);
cd(root_dir);
fprintf('\n\nDemo complete!\n')