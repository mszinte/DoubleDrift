function drawGabor(scr, const, gabor_id, gabor_ctrs, gabor_phases, ...
    gabor_angle, nbf)
% ----------------------------------------------------------------------
% drawGabor(scr, const, gabor_id, gabor_ctrs, gabor_phases, ...
%   gabor_angle, nbf)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw drift motion gabor
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% gabor_id : gabor id from CreateProceduralGabor
% gabor_ctrs: list of gabor center position
% gab_angle: gabor angle
% gab_phases: list of gabor phase value
% nbf : frame of motion
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

gabor_rect = [gabor_ctrs(1,nbf) - const.gaborSize/2,...
              gabor_ctrs(2,nbf) - const.gaborSize/2,...
              gabor_ctrs(1,nbf) + const.gaborSize/2,...
              gabor_ctrs(2,nbf) + const.gaborSize/2];
gabor_phase = gabor_phases(nbf);
gabor_contrast = const.gabor_contrasts(nbf);

Screen('DrawTexture', scr.main, gabor_id, [], gabor_rect, gabor_angle, ...
    [], [], [], [], kPsychDontDoRotation, [gabor_phase, const.gaborPeriod, ...
    const.gaborSigma, gabor_contrast, 1, 0, 0, 0]);

end