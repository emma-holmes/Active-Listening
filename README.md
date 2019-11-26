# Active-Listening
Demo code for active listening, compatible with SPM12 version 7487

## Background and purposes
This code has been extracted from a local version of SPM at the Wellcome Trust Centre for Neuroimaging, which—at the time of writing—is not yet in the public SPM release. The code accompanies a paper on Active Listening, which provides an overview of the framework. At the time of writing, the paper is under review. The purpose of distributing this code on GitHub is so that interested readers can run the code with the current public SPM release (SPM12, version 7487). 
<BR><BR>
Here, I provide a simple script: [RUN_DEMO.m](RUN_DEMO.m). The demo generates figures that demonstrate key principles shown in the paper (e.g., better segmentation with appropriate priors, and simulated responses that look like empirically observed electrophysiological mismatch responses). Observant users will notice that the finer details of the figures differ from those in the paper. That is because the code has been updated since the paper was written. The results depend upon lexical priors that can be extended or updated--and these priors are based upon random samples that depend upon the random number seed used to generate them, which will never be reproduced exactly. Nevertheless, that the same basic principles are demonstrated implies a generalisation of the key message. In other words, the behaviour of this synthetic active listening agent is robust to small changes in parameters that are not of key interest.

## License
This project is licensed under the GNU General Public License v2.0; see the [LICENSE](LICENSE) file for details.
<BR><BR>
Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging<BR>
Author: Karl Friston<BR>
Edited by: Emma Holmes and Noor Sajid  
  
## Getting started
### Prerequisites
The code was  written using MATLAB. Users are required to have [SPM12](https://www.fil.ion.ucl.ac.uk/spm/) in their MATLAB path. The code was written for use with SPM12 version 7487. This code was tested using MATLAB 2017a, it should theoretically be compatible with any version of MATLAB that is capable of running SPM12: please refer to the [SPM website](https://www.fil.ion.ucl.ac.uk/spm/) for details.

### Running the demo
Before attempting to run the demo, first download all files contained within this repository (without changing their names or the directory structure). As an entire unit, the files can be downloaded to any folder on the user's device. The working directory should be the one containing the [RUN_DEMO.m](RUN_DEMO.m) script. The user can run the demo by typing the following command into MATLAB: 
```
RUN_DEMO
```

## Scripts
The following list briefly describes each script in the directory, for advanced users who wish to personalise the code:
- spm_voice.m: Creates lexical and prosody cell arrays from sound file exemplars using path directory
- spm_voice_get_xY.m: Creates word arrays from sound file exemplars
- spm_voice_get_LEX.m: Creates lexical, prosody and speaker structures from word structures
- spm_voice_speak.m: Generates a continuous state space word discrete causes
- spm_voice_test.m: Reads and translates a sound file to assess recognition accuracy
- spm_voice_i.m: Gets indices, word strings or priors from lexicon
- spm_voice_read.m: Reads and translates a sound file or audio source
- spm_voice_get_word.m: Evaluates the likelihood of the next word in a file or object
- spm_voice_get_next.m: finds the index 500 ms before the next spectral peak
- spm_voice_onsets.m: identifies intervals containing acoustic energy and post onset minima
- spm_voice_check.m: returns normalised spectral energy in acoustic range
- spm_voice_likelihood.m: returns the lexical likelihood
- spm_voice_segmentation.m: Plots the results of a segmented sound file or audio stream
- spm_voice_FS.m: sampling frequency and function handle for handling sound signals
- spm_voice_identity.m: Evaluates the fundamental and formant frequencies of a speaker
- spm_voice_fundamental.m: Estimates and plots fundamental and format frequencies
- spm_voice_frequency.m: segmentation of timeseries at fundamental frequency
- spm_voice_dct.m: discrete cosine transformation
- spm_voice_repeat.m: illustrates voice recognition
- spm_voice_warp.m: resamples a vector to normalise the phase at a particular frequency
- spm_voice_filter.m: Time frequency decomposition to characterise acoustic spectral envelope
- spm_voice_iQ.m: discrete cosine transform of formant coefficients
- spm_voice_Q.m: inverse discrete cosine transform of formant coefficients
- spm_voice_ff.m: decomposition at fundamental frequency
- spm_voice_iff.m: inverse decomposition at fundamental frequency
- spm_voice_P300.m: illustrates voice recognition with lexical priors
- spm_create_training_voice.m: Code to create appropriate training data
- spm_conv_full: Hanning convolution

