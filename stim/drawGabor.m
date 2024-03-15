function drawGabor(scr, const, gaborCtr, gabor_mat)
% ----------------------------------------------------------------------
% drawGabor(scr, const, gaborCtrs, gabor_mat)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw drift motion gabor
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% gaborCtr: gabor center position 
% gabor_mat: matrix of the gabor
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

gaborRect = [gaborCtr(1) - const.gaborSize/2,...
             gaborCtr(2) - const.gaborSize/2,...
             gaborCtr(1) + const.gaborSize/2,...
             gaborCtr(2) + const.gaborSize/2];

gabor = Screen('MakeTexture', scr.main, gabor_mat); 
Screen('DrawTexture', scr.main, gabor, [], gaborRect);
Screen('Close', gabor);

end