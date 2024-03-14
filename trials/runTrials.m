function expDes = runTrials(scr, aud, const, expDes, my_key)
% ----------------------------------------------------------------------
% expDes = runTrials(scr, aud, const, expDes, my_key)
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
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containing all the variable design configurations.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Open video
if const.mkVideo
    open(const.vid_obj);
end
    
% Compute and simplify var and rand
var1 = expDes.expMat(expDes.t, 5);
var2 = expDes.expMat(expDes.t, 6);
rand1 = expDes.expMat(expDes.t, 7);

% Check trial
if const.checkTrial && const.expStart == 0
    fprintf(1,'\n\n\t=================== TRIAL %3.0f ====================\n',...
        expDes.t);
    fprintf(1,'\n\tTask =             \t%s', const.task_txt{task});
    if ~isnan(var1); fprintf(1,'\n\tExt. motion position =\t%s', ...
            const.stim_position_txt{var1}); end
    if ~isnan(var2); fprintf(1,'\n\tExt. motion orientation =\t%s', ...
            const.ext_motion_ori_txt{var2}); end
    if ~isnan(rand1); fprintf(1,'\n\tExt. motion vertical direction =\t%s', ...
            const.ext_motion_ver_dir_txt{rand1}); end
end
 
% Time
ext_motion_onset = 1;
ext_motion_offset = ext_motion_onset + const.ext_motion_dur_frm - 1;
resp_onset = ext_motion_offset + 1;
resp_offset = resp_onset + const.resp_dur_frm + 1;
trial_onset = ext_motion_onset;
trial_offset = resp_offset;

% Write in edf file

    
% Main diplay loop
nbf = 0;
while nbf < trial_offset
    % Flip count
    nbf = nbf + 1;
    
    Screen('FillRect', scr.main, const.background_color)
    
    % Motion
    if nbf >= ext_motion_onset && nbf <= ext_motion_offset
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 1);
        % drawDoubleDriftGabor(scr, const, nbf)
    end

    % Response
    if nbf >= resp_onset && nbf <= resp_offset
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
        elseif keyCode(my_key.left)
            expDes.expMat(t, 8) = 1;
            button_on = GetSecs;
            my_sound(4, aud);
            log_txt = sprintf('trial %i event %s', expDes.t, ...
                my_key.leftVal);
            if const.tracker; Eyelink('message','%s',log_txt); end
        elseif keyCode(my_key.right)
            expDes.expMat(t, 8) = 2;
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
    if nbf == trial_onset
        log_txt = sprintf('trial %i started\n', expDes.t);
        if const.tracker; Eyelink('message','%s',log_txt); end
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
expDes.expMat(t, 1) = trial_on;
expDes.expMat(t, 2) = trial_off - trial_on;
expDes.expMat(t, 9) = button_on - resp_on;

end