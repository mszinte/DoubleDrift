function my_key = keyConfig
% ----------------------------------------------------------------------
% my_key = keyConfig
% ----------------------------------------------------------------------
% Goal of the function :
% Unify key names and define structure containing each key names
% ----------------------------------------------------------------------
% Input(s) :
% none
% ----------------------------------------------------------------------
% Output(s):
% my_key : structure containing keyboard configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

KbName('UnifyKeyNames');

my_key.leftVal = 'LeftArrow';   % left arrow
my_key.rightVal = 'RightArrow'; % right arrow
my_key.escapeVal = 'escape';    % escape button
my_key.spaceVal = 'space';      % space button

my_key.left = KbName(my_key.leftVal);
my_key.right = KbName(my_key.rightVal);
my_key.escape = KbName(my_key.escapeVal);
my_key.space = KbName(my_key.spaceVal);

my_key.keyboard_idx = GetKeyboardIndices;
for keyb = 1:size(my_key.keyboard_idx,2)
    KbQueueCreate(my_key.keyboard_idx(keyb));
    KbQueueFlush(my_key.keyboard_idx(keyb));
    KbQueueStart(my_key.keyboard_idx(keyb));
end
[~, keyCodeMat] = KbQueueCheck(my_key.keyboard_idx(1));
my_key.keyCodeNum = numel(keyCodeMat);

end