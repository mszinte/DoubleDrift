function computePerception(const)
% ----------------------------------------------------------------------
% computePerception(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute perveived vertical motion angle
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------
close all
run1_fn = sprintf('data/%s/ses-01/%s/%s_ses-01_task-DoubleDriftPerception_run-01_matlab.mat',...
    const.sjct, const.modality, const.sjct);
load(run1_fn);
run1_mat = config.expDes.expMat;

run2_fn = sprintf('data/%s/ses-01/%s/%s_ses-01_task-DoubleDriftPerception_run-02_matlab.mat',...
    const.sjct, const.modality, const.sjct);
load(run2_fn);
run2_mat = config.expDes.expMat;

figure;
staircase1_run1_angle = run1_mat(run1_mat(:,8)==1, 9);
staircase1_run1_trial = run1_mat(run1_mat(:,8)==1, 4);
staircase1_run1_angle_avg = mean(staircase1_run1_angle(end-25:end), 'omitnan');
staircase2_run1_angle = run1_mat(run1_mat(:,8)==2, 9);
staircase2_run1_trial = run1_mat(run1_mat(:,8)==2, 4);
staircase2_run1_angle_avg = mean(staircase2_run1_angle(end-25:end), 'omitnan');

staircase1_run2_angle = run2_mat(run2_mat(:,8)==1, 9);
staircase1_run2_trial = run2_mat(run2_mat(:,8)==1, 4);
staircase1_run2_angle_avg = mean(staircase1_run2_angle(end-25:end), 'omitnan');
staircase2_run2_angle = run2_mat(run2_mat(:,8)==2, 9);
staircase2_run2_trial = run2_mat(run2_mat(:,8)==2, 4);
staircase2_run2_angle_avg = mean(staircase2_run2_angle(end-25:end), 'omitnan');

staircase_angle_avg = mean([staircase1_run1_angle_avg, ...
                            staircase2_run1_angle_avg, ...
                            staircase1_run2_angle_avg, ...
                            staircase2_run2_angle_avg]);

staircase_angle_std = std([staircase1_run1_angle_avg, ...
                            staircase2_run1_angle_avg, ...
                            staircase1_run2_angle_avg, ...
                            staircase2_run2_angle_avg]);
                        
% plot staircases
plot(staircase1_run1_trial, staircase1_run1_angle, 'o-b'); hold on
plot(staircase2_run1_trial, staircase2_run1_angle, 'o-r');
plot(staircase1_run2_trial, staircase1_run2_angle, 'x-k');
plot(staircase2_run2_trial, staircase2_run2_angle, 'x-g');

% plot average
xavg = 0:100;
plot(xavg, xavg*0 + staircase1_run1_angle_avg, '-b');
plot(xavg, xavg*0 + staircase2_run1_angle_avg, '-r');
plot(xavg, xavg*0 + staircase1_run2_angle_avg, '-k');
plot(xavg, xavg*0 + staircase2_run2_angle_avg, '-g');

xlabel('Trials')
ylabel('External motion angle (deg)')
title(sprintf('Stairscase results - AVG = %2.1f +/- %2.1f', ...
    staircase_angle_avg, staircase_angle_std));

% save results
staircase.staircase_angle_avg = staircase_angle_avg;
staircase.staircase_angle_std = staircase_angle_std;
save(const.staircase_file, 'staircase');

end