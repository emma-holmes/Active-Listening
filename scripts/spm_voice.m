function spm_voice(PATH)
% Creates lexical and prosody cell arrays from sound file exemplars
% FORMAT spm_voice(PATH)
%
% PATH         -  directory containing sound files of exemplar words
%                 (and a test.wav file in a subdirectory /test)
%
% saves VOX.mat
%
% VOX.LEX(w,k) -  structure array for k variants of w words
% VOX.PRO(p)   -  structure array for p aspects of prosody
% VOX.WHO(w)   -  structure array for w aspects of identity
%
%  This routine creates structure arrays used to infer the lexical class,
%  prosody and speaker identity of a word. It uses a library of sound
%  files, each containing 32 words spoken with varying prosody. The name of
%  the sound file labels the word in question. These exemplars are then
%  transformed (using a series of discrete cosine transforms) into a set of
%  parameters, which summarise the lexical content and prosody. The inverse
%  transform generates  timeseries that can be played to articulate a word.
%  The transform operates on a word structure xY to create lexical and
%  prosody parameters (Q and P respectively). The accuracy of  lexical
%  inference (i.e., voice the word recognition) is assessed  using the
%  exemplar (training) set and a narrative sound file called '../test.wav'
%  (and associated '../test.txt'). The operation of each subroutine can be
%  examined using graphical outputs by selecting the appropriate options in
%  a voice recognition specific global variable VOX. this structure is
%  saved in the sound file for subsequent use.
%
%  Auxiliary routines will be found at the end of the script. These include
%  various optimisation schemes and illustrations of online voice
%  recognition
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: spm_voice.m 7653 2019-08-09 09:56:25Z karl $


%% setup options and files
%==========================================================================

% directory of sound files if necessary
%--------------------------------------------------------------------------
clear global VOX
close all
%clear all
clc
if ~nargin
    PATH = fullfile(pwd, 'sound_files');
end

global VOX
VOX.analysis = 0;
VOX.graphics = 0;
VOX.interval = 0;
VOX.onsets   = 0;
VOX.mute     = 1;


%% get training corpus
%==========================================================================
fprintf('\n\nAnalysing training corpus...\n');
[xY,word,NI] = spm_voice_get_xY(PATH); save xY xY word NI


%% set VOX (LEX, PRO and WHO) and parameters; e.g., timbre  = mean(P(:,4));
%==========================================================================
spm_voice_get_LEX(xY,word,NI);


%% articulate every word under all combinations of (5 levels) of prosody
% {VOX.PRO.str}: {'amp','lat','dur','tim','Tu','Tv''Tf',Tw','p0','p1','p2'}
% {VOX.WHO.str}: {'ff0','ff1'}
%--------------------------------------------------------------------------
VOX.mute     = 0;
VOX.graphics = 1;
VOX.RAND     = 1/8;

nw    = numel(VOX.LEX);                       % number of lexical features
np    = numel(VOX.PRO(1).pE);                 % number of prosody features
k     = [1 np];
f     = fix(np/2);
for w = 1:nw
    for i = k
        for j = k
            spm_voice_speak(w,[8;1;f;8;j;f;f;f;i;f;f],[3;3]); pause(1/2)
        end
    end
end

VOX.RAND = 0;


%% invert a test file of 87 words & optimise basis function order (nu,nv)
%==========================================================================
fprintf('\n\nInverting test file...\n');
wtest   = fullfile(PATH,'test','test.wav');
ttest   = fullfile(PATH,'test','test.txt');
spm_voice_test(wtest,ttest);


%% save structure arrays in sound file directory
%--------------------------------------------------------------------------
VOX.analysis = 0;
VOX.graphics = 0;
VOX.interval = 0;
VOX.onsets   = 0;
VOX.mute     = 1;
DIR   = fileparts(which('spm_voice.m'));
save(fullfile(DIR,'VOX'),'VOX')


%% read the first few words of a test file
%==========================================================================
VOX.graphics = 0;

% prior words (first words are the spoken words)
%--------------------------------------------------------------------------
clear str
str{1} = {'is'};
str{2} = {'there'};
str{3} = {'a'};
str{4} = {'triangle','square'};
str{5} = {'below','above'};
str{6} = {'no','yes'};
str{7} = {'is','there'};
str{8} = {'is','there'};
[i,P]  = spm_voice_i(str);

% Read test file
%--------------------------------------------------------------------------
spm_voice_read(wtest,P);



%% recover funcdamental and formant formant frequencies
%--------------------------------------------------------------------------
try
    VOX = rmfield(VOX,{'F0','F1'});
end

VOX.formant = 1;
for i = 1:4
   spm_voice_identity(wtest,P);
end


%% illustrate accuracy (i.e., inference) using training corpus
%==========================================================================
fprintf('\n\nPlotting accuracy of inferred words...\n');

% likelihood of training set
%--------------------------------------------------------------------------
[nw,ns] = size(xY);
    
q     = [];
p     = [];
r     = 0;
for i = 1:nw
    for j = 1:16:ns
        
        % evaluate lexical (L) and prosody (M) likelihoods
        %------------------------------------------------------------------
        [L,M] = spm_voice_likelihood(xY(i,j));
        L(:)  = spm_softmax(L(:));
        M     = spm_softmax(M);
        L     = sum(L,2);
        
        % inferred and true lexical outcome
        %------------------------------------------------------------------
        q(:,end + 1) = L;
        p(i,end + 1) = 1;
        r        = r + M;
    end
end

% show results
%--------------------------------------------------------------------------
spm_figure('GetWin','Accuracy (training)'); clf
subplot(2,1,1); imagesc(q)
a     = 1 - sum((p(:) - q(:)) > 1/8)/sum(p(:));
str   = sprintf('Lexical classification accuracy %-2.0f p.c.',100*a);
title(str,'FontSize',16), xlabel('exemplars'), ylabel('words')
set(gca,'Ytick',1:nw),set(gca,'YtickLabel',{VOX.LEX.word})

subplot(3,1,3); imagesc(r'), axis image
j     = numel(VOX.PRO);
k     = numel(VOX.PRO(1).pE);
xlabel('level'), ylabel('attribute'), title('Prosody','FontSize',16)
set(gca,'Xtick',1:k),set(gca,'Ytick',1:j),set(gca,'YtickLabel',{VOX.PRO.str})


%% P300 demonstration
%==========================================================================
fprintf('\n\nShowing simulated neuronal responses...\n');
spm_voice_P300(PATH)


%% auxiliary code
%==========================================================================
return

%% optmise regularization with respect to classification accuracy
%==========================================================================
clear VOX
global VOX
load VOX
wtest = fullfile(PATH,'test','test.wav');
ttest = fullfile(PATH,'test','test.txt');
load(fullfile(PATH,'xY.mat'));

% reporting options
%--------------------------------------------------------------------------
VOX.graphics = 0;
VOX.mute     = 1;
VOX.onsets   = 0;

% search over variables
%--------------------------------------------------------------------------
E     = [1 2 4 8 16]*2;
G     = [1 2 4 8 16]/2;
for i = 1:numel(E)
    
    try VOX = rmfield(VOX,'E'); end
    try VOX = rmfield(VOX,'G'); end
    % VOX.E = E(i);
    VOX.G = G(i);
    P     = spm_voice_get_LEX(xY,word,NI);
    A(i)  = spm_voice_test(wtest,ttest)   
end

subplot(2,3,6), plot(E,A,'.','MarkerSize',16), axis square
title('Accuracy (E)','FontSize',16),drawnow


