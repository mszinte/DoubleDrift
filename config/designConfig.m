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
% Var 1: external motion screen position
if const.mkVideo
    expDes.oneV = input(sprintf('\n\tVAR 1: '));
    expDes.nb_var1 = 1;
else
    expDes.oneV = const.stim_position';
    expDes.nb_var1 = length(expDes.oneV);
end
% 1: left
% 2: right

% Var 2: external motion orientation
if const.mkVideo
    expDes.oneV = input(sprintf('\n\tVAR 2: '));
    expDes.nb_var2 = 1;
else
    expDes.twoV = const.ext_motion_ori';
    expDes.nb_var2 = length(expDes.twoV);
end
% see constConfig.m

% Rand 1: Ext. motion vertical direction
if const.mkVideo
    expDes.oneR = input(sprintf('\n\tRAND 1: '));
    expDes.nb_rand1 = 1;
else
    expDes.oneR = const.ext_motion_ver_dir';
    expDes.nb_rand1 = length(expDes.oneR);
end
% 1: downward
% 2: upward

% Rand 2: fixation offset time percent
if const.mkVideo
    expDes.twoR = input(sprintf('\n\tRAND 2: '));
    expDes.nb_rand2 = 1;
else
    expDes.twoR = const.fix_off_time_prct_num';
    expDes.nb_rand2 = length(expDes.twoR);
end
% see constConfig.m

% Experimental loop
expDes.nb_var = 2;
expDes.nb_rand = 2;

% Pursuit experimental loop
ii = 0;
trialMat = zeros(const.nb_trials, expDes.nb_var + expDes.nb_rand)*nan;
for rep = 1:const.nb_repeat
    for var1 = 1:expDes.nb_var1
        for var2 = 1:expDes.nb_var2
            ii = ii + 1;
            trialMat(ii, 1) = var1;
            trialMat(ii, 2) = var2;
            
        end
    end
end
trialMat = trialMat(randperm(const.nb_trials),:);

for t_trial = 1:const.nb_trials
    randVal1 = randperm(numel(expDes.oneR));     
    randVal2 = randperm(numel(expDes.twoR));     
    rand_rand1 = expDes.oneR(randVal1(1));
    rand_rand2 = expDes.twoR(randVal2(1));
    trialMat(t_trial, 3) = rand_rand1;
    trialMat(t_trial, 4) = rand_rand2;
end

expDes.expMat = [zeros(const.nb_trials,2)*nan, ...
                 zeros(const.nb_trials,1)*0+const.runNum,...
                [1:const.nb_trials]',...
                trialMat,...
                zeros(const.nb_trials,2)*nan];

% 01: onset
% 02: duration
% 03: run number
% 04: trial number
% 05: external motion screen position
% 06: external motion orientation
% 07: external motion vertical direction
% 08: fixation offset time percent
% 09: direction report
% 10: response duration

 end