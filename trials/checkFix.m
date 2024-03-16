function [fix, expDes] = checkFix(scr, const, expDes, my_key, eyetrack)
% ----------------------------------------------------------------------
% [fix, expDes] = checkFix(scr, const, expDes, my_key, eyetrack)
% ----------------------------------------------------------------------
% Goal of the function :
% Check the correct fixation of the participant
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : experimental design configuration
% my_key : structure containing keyboard configurations
% eyetrack : structure containing eyetracking configurations
% ----------------------------------------------------------------------
% Output(s):
% fix : fixation check (1 = yes, 2 = no)
% expDes : experimental design configuration
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Open video
if const.mkVideo
    open(const.vid_obj);
end

tstart = GetSecs;
fix = 0;
corStart = 0;
tCor = 0;
t = tstart;
first_flip = 0;

while ((t - tstart) < const.fix_timeout_sec && ...
        tCor <= const.fix_min_correct_sec)

    % Check gaze posiiton
    if const.tracker
        [x, y] = getCoord(eyetrack);
        if sqrt((x - scr.x_mid)^2 + (y - scr.y_mid)^2) ...
                < eyetrack.fix_rad
            fix = 1;
        else
            fix = 0;
        end
    else
        fix = 1;
    end

    % Draw fixation target
    Screen('FillRect', scr.main, const.background_color);
    drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 1);
    t = Screen('Flip',scr.main);
    if ~first_flip
        % write in log/edf
        log_txt = sprintf('trial %i check fixation at %f\n', expDes.t, t);
        if const.tracker
            Eyelink('message', '%s', log_txt);
        end
        expDes.tstart = t;
        first_flip = 1;
    end

    % define output
    if fix == 1 && corStart == 0
        tCorStart = GetSecs;
        corStart = 1;
    elseif fix == 1 && corStart == 1
        tCor = GetSecs-tCorStart;
    else
        corStart = 0;
    end
   
    % Check keyboard
    keyPressed = 0;
    keyCode = zeros(1,my_key.keyCodeNum);

    for keyb = 1:size(my_key.keyboard_idx,2)
        [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
        keyPressed = keyPressed + keyP;
        keyCode = keyCode + keyC;
    end

    if keyPressed
        if keyCode(my_key.escape) && const.expStart == 0
            overDone(const, my_key)
        end
    end
end

end