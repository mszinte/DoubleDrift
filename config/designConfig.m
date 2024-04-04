function expDes = designConfig(const)
% ----------------------------------------------------------------------
% expDes = designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define experimental design
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg experimental design
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Experimental variables
% Cond 1: Task
if const.mkVideo
    expDes.oneC = input(sprintf(...
        '\n\tCond 1: task (1: perception; 2: saccade): '));
    expDes.nb_cond1 = 1;
else
    if const.sesNum == 1
        expDes.oneC = 1;
        expDes.nb_cond1 = 1;
    elseif const.sesNum == 2
        expDes.oneC = 2;
        expDes.nb_cond1 = 1;
    end
end
% 01: perception task
% 02: saccade task

% Rand 1: external motion screen position
if const.mkVideo
    expDes.oneR = input(sprintf(...
        '\n\tRand 1: motion position (1: left; 2: right): '));
    expDes.nb_rand1 = 1;
else
    expDes.oneR = const.stim_position';
    expDes.nb_rand1 = length(expDes.oneR);
end
% 01: left
% 02: right

% Rand 2: external motion vertical direction
if const.mkVideo
    expDes.twoR = input(sprintf(...
        '\n\tRAND 2: motion direction (1: downward; 2: upward): '));
    expDes.nb_rand2 = 1;
else
    expDes.twoR = const.ext_motion_ver_dir';
    expDes.nb_rand2 = length(expDes.twoR);
end
% 01: downward
% 02: upward

% Rand 3: staircase number (perception task only)
if const.mkVideo
    expDes.threeR = input(sprintf(...
        '\n\tRAND 3: Staircase number (1: 1st; 2: 2nd): '));
    expDes.nb_rand3 = 1;
else
    expDes.threeR = const.staircases';
    expDes.nb_rand3 = length(expDes.threeR);
end
% 01: 1st staircase
% 02: 2nd staircase

% Rand 4: fixation offset time percentage (saccade task only)
if const.mkVideo
    expDes.fourR = input(sprintf(...
        '\n\tRAND 4: fixation offset time percentage (1: 20%%; 2: 30%%; 3: 40%%; 4: 50%%; 5: 60%%): '));
    expDes.nb_rand4 = 1;
else
    expDes.fourR = const.fix_off_time_prct_num';
    expDes.nb_rand4 = length(expDes.fourR);
end
% 01 - 20% of motion path
% 02 - 30% of motion path
% 03 - 40% of motion path
% 04 - 50% of motion path
% 05 - 50% of motion path

% Rand 5: control vs. internal motion trial (saccade task only)
if const.mkVideo
    expDes.fiveR = input(sprintf(...
        '\n\tRAND 5: trial type (1: control; 2: internal motion trial): '));
    expDes.nb_rand5 = 1;
else
    expDes.fiveR = const.trial_type';
    expDes.nb_rand5 = length(expDes.fiveR);
end
% 01: control trials
% 02: internal motion trials

% Experimental loop
expDes.nb_var = 0;
expDes.nb_cond = 1;
expDes.nb_rand = 5;

% Pursuit experimental loop
trialMat = zeros(const.nb_trials, expDes.nb_cond + expDes.nb_var + expDes.nb_rand)*nan;

for t_trial = 1:const.nb_trials
    
    randVal1 = randperm(numel(expDes.oneR));
    randVal2 = randperm(numel(expDes.twoR));
    randVal3 = randperm(numel(expDes.threeR));
    randVal4 = randperm(numel(expDes.fourR));
    randVal5 = randperm(numel(expDes.fiveR));
    rand_rand1 = expDes.oneR(randVal1(1));
    rand_rand2 = expDes.twoR(randVal2(1));
    rand_rand3 = expDes.threeR(randVal3(1));
    rand_rand4 = expDes.fourR(randVal4(1));
    rand_rand5 = expDes.fiveR(randVal5(1));
    trialMat(t_trial, 1) = expDes.oneC;
    trialMat(t_trial, 2) = rand_rand1;
    trialMat(t_trial, 3) = rand_rand2;
    trialMat(t_trial, 4) = rand_rand3;
    trialMat(t_trial, 5) = rand_rand4;
    trialMat(t_trial, 6) = rand_rand5;
end

expDes.expMat = [zeros(const.nb_trials,2)*nan, ...
                 zeros(const.nb_trials,1)*0+const.runNum,...
                [1:const.nb_trials]',...
                trialMat,...
                zeros(const.nb_trials,3)*nan];

% 01: onset
% 02: duration
% 03: run number
% 04: trial number
% 05: task
% 06: rand1 external motion screen position
% 07: rand2 external motion vertical direction
% 08: rand3 staircase number
% 09: rand4 fixation offset time percent 
% 10: rand5 trial type
% 11: external motion orientation
% 12: direction report
% 13: response duration

 end