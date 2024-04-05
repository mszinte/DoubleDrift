%% General experimenter launcher
% By:  Martin SZINTE
% Projet: DoubleDrift
% With: Anna Montagnini & Frederic Chavane

% Description
% ----------- 
% Adaptation of experiment 1 (perception) of Lisa & Cavanagh, 2015, 
% Current Biology (http://dx.doi.org/10.1016/j.cub.2015.08.021)
% for the AMU Neuroscience Master APP 2024 courses.

% Details
% -------
% external motion presented left or right of fixation
% external motion shown with 10 different orientation (5 cw/ 5ccw, continuous stimuli method)
% external motion presented with upward or downward direction
% 5 fixation offset (signal to start saccade)
% 0.5 s of fixation with fixation check
% 2.0 s of double drift motion in theory but switched off at saccade onset
% 150 ms of stimulus contrast ramp
% 1.0 s of response
% In session 1 participant judge the orientation of the external motion (cw or ccw)
% 2 staircases with different angles of external motion are played
% In session 2 participant make saccadic eye movement to the external
% motion played with the convergent PSE angle
% stimulus offset when gaze out of 1.5 dva circle around bull's eye

% 2 runs of ~6 min (100 trials each) in session 1
% 2 runs of ~6 min (100 trials each) in session 2 

% First settings
Screen('CloseAll'); clear all; clear mex; clear functions; close all; ...
    home; AssertOpenGL;

% General settings
const.expName = 'DoubleDrift';          % experiment name
const.expStart = 1;                     % Start of a recording (0 = NO, 1 = YES)
const.checkTrial = 0;                   % Print trial conditions (0 = NO, 1 = YES)
const.mkVideo = 0;                      % Make a video (0 = NO, 1 = YES)

% External controls
const.tracker = 1;                      % run with eye tracker (0 = NO, 1 = YES)
const.display = 1;                      % diplay (1 = Display++; 2 = MacBookPro)

% Desired screen settings
const.desiredFD = 120;                  % Desired refresh rate
const.desiredRes = [1920, 1080];        % Desired resolution

% Path
dir = which('expLauncher');
cd(dir(1:end-18));

% Add Matlab path
addpath('config', 'main', 'conversion', 'eyeTracking', 'instructions',...
    'trials', 'stim');

% Subject configuration
const = sbjConfig(const);

% Main run
main(const);