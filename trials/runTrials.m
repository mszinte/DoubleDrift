function expDes = runTrials(scr, aud, const, expDes, my_key, eyetrack)
% ----------------------------------------------------------------------
% expDes = runTrials(scr, aud, const, expDes, my_key, eyetrack)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw stimuli of each indivual trial and waiting for inputs
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% aud : audio configurations
% const : struct containing constant configurations
% expDes : struct containg experimental design
% my_key : structure containing keyboard configurations
% eyetrack: eyetracking settings
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containing all the variable design configurations.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------
    
% Compute and simplify var and rand
var1 = expDes.expMat(expDes.t, 5);
var2 = expDes.expMat(expDes.t, 6);
rand1 = expDes.expMat(expDes.t, 7);
rand2 = expDes.expMat(expDes.t, 8);
gabor_ctrs = const.ext_motion_ctr{var2, var1, rand1};
gabor_angle = const.ext_motion_ori(var2);

if rand1 == 1
    % downward
    if const.ext_motion_ori(var2) > 0 
        gabor_phases = const.phase_left;
    elseif const.ext_motion_ori(var2) < 0
        gabor_phases = const.phase_right;
    end
elseif rand1 == 2
    % upward
    if const.ext_motion_ori(var2) > 0
        gabor_phases = const.phase_right;
    elseif const.ext_motion_ori(var2) < 0
        gabor_phases = const.phase_left;
    end
end

% Check trial
if const.checkTrial && const.expStart == 0
    fprintf(1,'\n\n\t=================== TRIAL %3.0f ====================\n',...
        expDes.t);
    if ~isnan(var1); fprintf(1,'\n\tExt. motion position =\t\t\t%s', ...
            const.stim_position_txt{var1}); end
    if ~isnan(var2); fprintf(1,'\n\tExt. motion orientation =\t\t%s', ...
            const.ext_motion_ori_txt{var2}); end
    if ~isnan(rand1); fprintf(1,'\n\tExt. motion vertical direction =\t%s', ...
            const.ext_motion_ver_dir_txt{rand1}); end
    if ~isnan(rand2); fprintf(1,'\n\tFixation offset motion percentage =\t%s', ...
            const.fix_off_time_prct_txt{rand2}); end
end

% Time
ext_motion_onset = 1;
ext_motion_offset = ext_motion_onset + const.ext_motion_dur_frm - 1;
resp_onset = ext_motion_offset + 1;
resp_offset = resp_onset + const.resp_dur_frm + 1;
trial_onset = ext_motion_onset;
trial_offset = resp_offset;
fix_onset = trial_onset;
fix_offset = const.fix_off_frm(rand2);
saccade_onset = fix_offset + const.sac_lat_dur_frm;

% Main diplay loop
nbf = 0;
nbf_motion = 0;
button_on = 0;
first_fix_break = 0;
while nbf < trial_offset
    
    % Check for eye position
    if ~first_fix_break
        if const.tracker
            [x_eye, y_eye] = getCoord(eyetrack);
            if sqrt((x_eye - scr.x_mid)^2 + (y_eye - scr.y_mid)^2) < eyetrack.fix_rad
                fix = 1;
            else
                fix = 0;
                first_fix_break = GetSecs;
                log_txt = sprintf('trial %i fixation break at %s', expDes.t, first_fix_break);
                if const.tracker; Eyelink('message','%s',log_txt); end
            end
        else
            if nbf < saccade_onset
                fix = 1;
            else
                fix = 0;
                first_fix_break = GetSecs;
                log_txt = sprintf('trial %i fixation break demo at %s', expDes.t, first_fix_break);
                if const.tracker; Eyelink('message','%s',log_txt); end
            end
        end
    end
    
    % Flip count
    nbf = nbf + 1;
    Screen('FillRect', scr.main, const.background_color)
    
    % Motion
    if nbf >= ext_motion_onset && nbf <= ext_motion_offset && fix
        nbf_motion = nbf_motion +1;
        drawGabor(scr, const, expDes.gabor_id, gabor_ctrs, ....
            gabor_phases, gabor_angle, nbf)
    end
    
    % Fixation bull's eye
    if nbf >= fix_onset && nbf <= fix_offset
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 1);
    end
    
    % Check keyboard
    keyPressed = 0;
    keyCode = zeros(1,my_key.keyCodeNum);
    for keyb = 1:size(my_key.keyboard_idx,2)
        [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
        keyPressed = keyPressed + keyP;
        keyCode = keyCode + keyC;
    end
    
    % Deal with responses
    if keyPressed
        % Deal with response
        if keyCode(my_key.escape)
            if const.expStart == 0; overDone(const, my_key);end
        elseif keyCode(my_key.left) && ~button_on
            expDes.expMat(expDes.t, end-1) = 1;
            button_on = GetSecs;
            my_sound(4, aud);
            log_txt = sprintf('trial %i event %s', expDes.t, ...
                my_key.leftVal);
            if const.tracker; Eyelink('message','%s',log_txt); end
        elseif keyCode(my_key.right) && ~button_on
            expDes.expMat(expDes.t, end-1) = 2;
            button_on = GetSecs;
            my_sound(4, aud);
            log_txt = sprintf('trial %i event %s', expDes.t, ...
                my_key.rightVal);
            if const.tracker; Eyelink('message','%s',log_txt); end
        end
    end
    
    % flip screen
    vbl = Screen('Flip', scr.main);
    
    % Create movie
    if const.mkVideo
        expDes.vid_num = expDes.vid_num + 1;
        image_vid = Screen('GetImage', scr.main);
        imwrite(image_vid,sprintf('%s_frame_%i.png', ...
            const.movie_image_file, expDes.vid_num))
        writeVideo(const.vid_obj,image_vid);
    end
    if nbf == trial_offset
        log_txt = sprintf('trial %i ended\n', expDes.t);
        if const.tracker; Eyelink('message','%s',log_txt); end
    end
    if nbf == ext_motion_onset
        trial_on = vbl;
        log_txt = sprintf('motion_onset %i at %f', expDes.t, vbl); 
        if const.tracker; Eyelink('message','%s',log_txt); end
    end
    if nbf == ext_motion_onset
        log_txt = sprintf('motion_offset %i at %f', expDes.t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    end
    if nbf == fix_onset
        log_txt = sprintf('fixation_onset %i at %f', expDes.t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    end
    if nbf == fix_offset
        log_txt = sprintf('fixation_offset %i at %f', expDes.t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    end
    if nbf == resp_onset
        resp_on = vbl;
        log_txt = sprintf('response_onset %i at %f', expDes.t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    end
    if nbf == resp_offset
        trial_off = vbl;
        log_txt = sprintf('response_offset %i at %f', expDes.t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    end
end
expDes.expMat(expDes.t, 1) = expDes.tstart;
expDes.expMat(expDes.t, 2) = trial_off - expDes.tstart;
if button_on == 0
    expDes.expMat(expDes.t, end) = nan;
else
    expDes.expMat(expDes.t, end) = button_on - resp_on;
end

end