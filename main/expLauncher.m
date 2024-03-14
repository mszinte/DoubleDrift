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
% 0.5 s of fixation with fixation check
% 1.5 s of downward motion
% 0.5 s of response with beep feedback
% subject report the perceived direction of external motion (cw or ccw)
% fade in / fade out of 0.100 ms

% To do
% -----
% - adapt to latest change of BEP020
% - make instructions
% - debug wrapper 
% - make stimulus and constant values of it

% First settings
Screen('CloseAll'); clear all; clear mex; clear functions; close all; ...
    home; AssertOpenGL;

% General settings
const.expName = 'DoubleDrift';          % experiment name
const.expStart = 0;                     % Start of a recording (0 = NO, 1 = YES)
const.checkTrial = 0;                   % Print trial conditions (0 = NO, 1 = YES)
const.mkVideo = 0;                      % Make a video (0 = NO, 1 = YES)

% External controls
const.tracker = 0;                      % run with eye tracker (0 = NO, 1 = YES)
const.training = 0;                     % training session (0 = NO, 1 = YES)

% Desired screen setting
const.desiredFD = 30; %120                  % Desired refresh rate
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