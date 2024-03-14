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
% -85 deg relative to vertical
% -70 deg relative to vertical
% -55 deg relative to vertical
% -40 deg relative to vertical
% -25 deg relative to vertical
% +25 deg relative to vertical
% +40 deg relative to vertical
% +55 deg relative to vertical
% +70 deg relative to vertical
% +85 deg relative to vertical

% Rand 1: Ext. motion vertical direction
if const.mkVideo
    expDes.oneR = input(sprintf('\n\tRAND 1: '));
    expDes.nb_rand1 = 1;
else
    expDes.oneR = const.ext_motion_ver_dir';
    expDes.nb_rand1 = length(expDes.oneR);
end

% Experimental loop
expDes.nb_var = 2;
expDes.nb_rand = 1;

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

for t_trial = 1:expDes.nb_trials
    randVal1 = randperm(numel(expDes.oneR));     
    rand_rand1 = expDes.oneR(randVal1(1));
    trialMat(ii, 3) = rand_rand1;
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
% 08: direction report
% 09: response duration

end