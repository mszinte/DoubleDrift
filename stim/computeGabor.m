function gabor_mat = computeGabor(const, gab_angle, gab_phases, nbf)
% ----------------------------------------------------------------------
% gabor_mat = computeGabor(const, gab_angle, gab_phases, nbf)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute drift motion gabor
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% gab_angle: gabor angle
% gab_phases: list of gabor phase value
% nbf : frame of motion
% ----------------------------------------------------------------------
% Output(s):
% gabor_mat = mesh of the gabor
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

gab_phase = gab_phases(nbf);
gabor_contrast = const.gabor_contrasts(nbf);
gabor_mat = generateGabor(const.gaborSize, const.gaborPixPerPeriod, ...
            gab_angle, const.gaborSigma, gab_phase, const.black, ...
            const.white, gabor_contrast, 1);

end