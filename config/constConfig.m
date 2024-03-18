function const = constConfig(scr, const)
% ----------------------------------------------------------------------
% const = constConfig(scr, const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define all constant configurations
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Randomization
[const.seed, const.whichGen] = ClockRandSeed;

% Colors
const.white = [255, 255, 255];                                              % white color
const.black = [0, 0, 0];                                                    % black color
const.gray = [128 128 128];                                                 % gray color
const.fixation_color = const.black;                                         % fixation point color
const.background_color = const.gray;                                        % background color

% Stim parameters
[const.ppd] = vaDeg2pix(1, scr);                                            % one pixel per dva
const.dpp = 1/const.ppd;                                                    % degrees per pixel
const.eccVal = 10;                                                          % eccentricity of the trajectory midpoint in dva
[const.ecc] = vaDeg2pix(const.eccVal, scr);                                 % eccentricity of the trajectory midpoint in pixels
const.gabor_pathVal = 4;                                                    % gabor path size in dva
const.gabor_path = vaDeg2pix(const.gabor_pathVal, scr);                     % gabor path size in pixels
const.ext_motion_speedVal = 2;                                              % external motion speed in dva/sec
const.ext_motion_speed = vaDeg2pix(const.ext_motion_speedVal, scr);         % external motion speed in pix/sec
const.ext_motion_steps = round((const.gabor_pathVal / ...
    const.ext_motion_speedVal) / scr.frame_duration);
const.int_motion_freq = 3;                                                  % internal motion temporal frequency in Hz
const.gaborSizeVal = 3.0;                                                   % full gabor diameter in dva
[const.gaborSize, ~] = vaDeg2pix(const.gaborSizeVal, scr);                  % full gabor diameter in pixels
const.gaborFrequency = 2;                                                   % gabor spatial frequecny
const.gaborPeriod = const.gaborFrequency/const.ppd;                         % period per pixel
const.freq = const.ppd/const.gaborFrequency;                   
const.gaborSigmaVal = 0.15;                                                  % gaussian envelope in dva
[const.gaborSigma, ~] = vaDeg2pix(const.gaborSigmaVal, scr);                % gaussian envelope in pixels

const.ext_motion_ori = [-75, -60, -45, -30, -15,...
                        +15, +30, +45, +60, +75];                           % external motion path orientation relative to vertical in degrees of rotation

const.ext_motion_ori = [-45, -45, -45, -40, -45,...
                        +45, +45, +45, +40, +45];                           % external motion path orientation relative to vertical in degrees of rotation
const.ext_motion_ori_txt = {'-75 deg', '-60 deg', '-45 deg', '-30 deg', '-15 deg',...
                            '+15 deg', '+30 deg', '+45 deg', '+60 deg', '+75 deg'};

const.stim_position = [1, 2];                                               % position of the stimulus on the screen (1: left; 2: right)
const.stim_position_txt = {'left', 'right'};                                

const.ext_motion_ver_dir = [1, 2];                                          % external motion vertical direction (1: downward; 2: upward)
const.ext_motion_ver_dir_txt = {'downward', 'upward'};

const.fix_off_step = 5;                                                     % fixation offset steps
const.fix_off_time_prct = linspace(.2, .6, const.fix_off_step);             % fixation offset in terms of percentage of motion path
const.fix_off_time_prct_num = linspace(1, const.fix_off_step, ...           % number for design matrix
    const.fix_off_step);
const.fix_off_time_prct_txt = {'20%', '30%', '40%', '50%', '60%'};

% compute external motion center point
ext_motion_ori_num = 0;
for ext_motion_ori = const.ext_motion_ori
    ext_motion_ori_num = ext_motion_ori_num +1;
    for stim_position = const.stim_position
        if stim_position == 1 
            % left side
            ctr_ext_motion = [scr.x_mid - const.ecc, scr.y_mid];
        elseif stim_position == 2
            % right side
            ctr_ext_motion = [scr.x_mid + const.ecc, scr.y_mid];
        end
        for ext_motion_ver_dir = const.ext_motion_ver_dir
            if ext_motion_ver_dir == 1
                % downward motion
                amp_from_ctr = linspace(const.gabor_path/2, ...
                    -const.gabor_path/2, const.ext_motion_steps);
            elseif ext_motion_ver_dir == 2
                % upward motion
                amp_from_ctr = linspace(-const.gabor_path/2, ...
                    const.gabor_path/2, const.ext_motion_steps);
            end
            
            const.ext_motion_ctr{ext_motion_ori_num, stim_position,...
                ext_motion_ver_dir} = ...
                [ctr_ext_motion(1) + amp_from_ctr * cosd(ext_motion_ori+90);...
                 ctr_ext_motion(2) + amp_from_ctr * -sind(ext_motion_ori+90)];
            
        end
    end
end

% Time parameters
const.ext_motion_dur_sec = const.gabor_pathVal / const.ext_motion_speedVal; % external motion duration in seconds
const.ext_motion_dur_frm = round(const.ext_motion_dur_sec / ...             % external motion duration in in frames
    scr.frame_duration);
const.fix_timeout_sec = 1.000;                                              % fixation check maximum duration in seconds
const.fix_min_correct_sec = 0.500;                                          % correct fixation check minimum duration in seconds
const.resp_dur_sec = 1.000;                                                 % response time duration in seconds
const.resp_dur_frm = round(const.resp_dur_sec / scr.frame_duration);        % response time duration in frames
const.ext_motion_fading_dur_sec = 0.150;                                    % external motion fading duration in seconds
const.ext_motion_fading_dur_frm = round(const.ext_motion_fading_dur_sec /...% external motion fading duration in frames
    scr.frame_duration);
const.gabor_contrasts = ones(1,const.ext_motion_dur_frm);
const.gabor_contrast_ramp = linspace(0,1,const.ext_motion_fading_dur_frm+2);
const.gabor_contrasts(1:const.ext_motion_fading_dur_frm) = const.gabor_contrast_ramp(2:end-1);

const.phase_left = linspace(0, const.int_motion_freq * ... 
    const.ext_motion_dur_sec, const.ext_motion_steps)*180;
const.phase_right = flip(const.phase_left);

const.fix_off_frm = const.fix_off_time_prct * const.ext_motion_dur_frm;     % fixation offset frame
const.sac_lat_dur_sec = 0.180;                                              % theoretical saccade latency duration in seconds
const.sac_lat_dur_frm = round(const.sac_lat_dur_sec / ...                   % theoretical saccade latency duration in frames
    scr.frame_duration);

% Trial settings
 if const.mkVideo
    const.nb_repeat = 1;                                                    % Trial repetition in video mode
    const.nb_trials = 1;                                                    % Number of trials in video mode
 else
    if const.training
        const.nb_repeat = 1;
    else
        const.nb_repeat = 4;
    end
    const.nb_trials = length(const.ext_motion_ori) * ...                    % number of trials
        length(const.stim_position) * const.nb_repeat;
end

% Bullseye configs
const.fix_out_rim_radVal = 0.25;                                            % radius of outer circle of fixation bull's eye in dva
const.fix_rim_radVal = 0.75*const.fix_out_rim_radVal;                       % radius of intermediate circle of fixation bull's eye in dva
const.fix_radVal = 0.25*const.fix_out_rim_radVal;                           % radius of inner circle of fixation bull's eye in dva
const.fix_out_rim_rad = vaDeg2pix(const.fix_out_rim_radVal, scr);           % radius of outer circle of fixation bull's eye in pixels
const.fix_rim_rad = vaDeg2pix(const.fix_rim_radVal, scr);                   % radius of intermediate circle of fixation bull's eye in pixels
const.fix_rad = vaDeg2pix(const.fix_radVal, scr);                           % radius of inner circle of fixation bull's eye in pixels

% Personalised eyelink calibrations
angle = 0:pi/3:5/3*pi;

% compute calibration target locations
const.calib_amp_ratio = 0.5;
[cx1, cy1] = pol2cart(angle, const.calib_amp_ratio);
[cx2, cy2] = pol2cart(angle + (pi / 6), const.calib_amp_ratio * 0.5);
cx = round(scr.x_mid + scr.x_mid * [0 cx1 cx2]);
cy = round(scr.y_mid + scr.x_mid * [0 cy1 cy2]);
 
% order for eyelink
const.calibCoord = round([cx(1), cy(1),...                                  % 1. center center
    cx(9), cy(9),...                                                        % 2. center up
    cx(13),cy(13),...                                                       % 3. center down
    cx(5), cy(5),...                                                        % 4. left center
    cx(2), cy(2),...                                                        % 5. right center
    cx(4), cy(4),...                                                        % 6. left up
    cx(3), cy(3),...                                                        % 7. right up
    cx(6), cy(6),...                                                        % 8. left down
    cx(7), cy(7),...                                                        % 9. right down
    cx(10), cy(10),...                                                      % 10. left up
    cx(8), cy(8),...                                                        % 11. right up
    cx(11), cy(11),...                                                      % 12. left down
    cx(12), cy(12)]);                                                       % 13. right down

% compute validation target locations (calibration targets smaller radius)
const.valid_amp_ratio = const.calib_amp_ratio * 0.8;
[vx1, vy1] = pol2cart(angle, const.valid_amp_ratio);
[vx2, vy2] = pol2cart(angle + pi /6, const.valid_amp_ratio * 0.5);
vx = round(scr.x_mid + scr.x_mid*[0 vx1 vx2]);
vy = round(scr.y_mid + scr.x_mid*[0 vy1 vy2]);

% order for eyelink
const.validCoord =round([vx(1), vy(1),...                                   % 1. center center
    vx(9), vy(9),...                                                        % 2. center up
    vx(13), vy(13),...                                                      % 3. center down
    vx(5), vy(5),...                                                        % 4. left center
    vx(2), vy(2),...                                                        % 5. right center
    vx(4), vy(4),...                                                        % 6. left up
    vx(3), vy(3),...                                                        % 7. right up
    vx(6), vy(6),...                                                        % 8. left down
    vx(7), vy(7),...                                                        % 9. right down
    vx(10), vy(10),...                                                      % 10. left up
    vx(8), vy(8),...                                                        % 11. right up
    vx(11), vy(11),...                                                      % 12. left down
    vx(12), vy(12)]);                                                       % 13. right down
 end