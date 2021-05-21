function drawfixationcross(wd,pos,dotsize,cross)
% drawfixationcross(wd,pos,dotsize,cross)
% 
% wd is the window for Screen 
% pos is 1 for left, 2 for centre, 3 for right
% dotsize is size of the dot
% cross is 1 to display fixation cross, 0 to display fixation dot 

global drmf drmd

if ~cross
	% draw dot 
	Screen('gluDisk',wd,0,drmd(pos,1),drmd(pos,2),dotsize);
	Screen('gluDisk',wd,255,drmd(pos,1),drmd(pos,2),dotsize/2);
else
	% draw cross 
	Screen('DrawLines',wd,drmf(:,:,pos),1,0); 
end
