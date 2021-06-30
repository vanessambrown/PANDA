
% draw the mushroom in the given position given by lrt 
Screen('Drawtexture',wd,msh(Nmsh+1),[],tdrm(1,:));

% draw box 
Screen('Drawtexture',wd,graysquare,[],bgsquare);
Screen('DrawLines',wd,bluebox,2,blue);

% draw a blue / black dot 
dotpos = [tdrmd(2,1); tdrmd(2,2)];	
Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
Screen('gluDisk',wd,blue,dotpos(1),dotpos(2),dotsize);
Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);

Screen('Flip',wd,[],1);
WaitSecs(1);
checkabort;
WaitSecs(3);
getleftrightarrow;
