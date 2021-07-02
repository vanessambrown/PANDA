% draw box for joystick
if strcmpi(respkey,'joystick')
    tmp = [tdrm(1,[1 3 3 1]); tdrm(1,[2 2 4 4])];
    bluebox = [tmp(:,1:2) tmp(:,2:3) tmp(:,3:4) tmp(:,[4 1])];
end

% draw the mushroom in the given position given by lrt 
Screen('Drawtexture',wd,msh(Nmsh+1),[],tdrm(1,:));

% draw box 

Screen('DrawLines',wd,bluebox,3,blue);

% draw a blue / black dot 
if ~strcmpi(respkey,'joystick')
    Screen('Drawtexture',wd,graysquare,[],bgsquare);

    dotpos = [tdrmd(2,1); tdrmd(2,2)];	
    Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
    Screen('gluDisk',wd,blue,dotpos(1),dotpos(2),dotsize);
    Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);
    Screen('Flip',wd);
end

if strcmpi(respkey,'joystick')
    numpressneeded=length(joy_thresh_push_instr);joystick_pos=0;joystick_thresh=0;
else numpressneeded=3;
end

buttons = [0 0 0 0];clicks = 0;
while (clicks < numpressneeded); % wait nogodelay seconds
    if strcmpi(respkey,'mouse');
    	while any(buttons) 	 % if already pressing button, wait for release
        	[x,y,buttons]=GetMouse;
        end
        while ~any(buttons)	% wait for start of click 
            [x,y,buttons]=GetMouse;
        end
  elseif strcmpi(respkey,'joystick') %register joystick position
	if any(buttons) % count clicks 
		clicks = clicks + 1;

		DrawFormattedText(wd,tx{page},'center',ypos{page},txtcolor,60,[],[],1.3);

		% draw the mushroom in the given position given by lrt 
		Screen('Drawtexture',wd,msh(Nmsh+1),[],tdrm(1,:));
			
		% draw box 
		Screen('Drawtexture',wd,graysquare,[],bgsquare);
		Screen('DrawLines',wd,bluebox,3,blue);

		% draw a blue / black dot 
		distance = tdrmd(2,1)-tdrmd(1,1);
		dotpos(1) = dotpos(1) + distance/numpressneeded;
		Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
		if clicks < numpressneeded; 
			Screen('gluDisk',wd,blue,dotpos(1),dotpos(2),dotsize);
		else
			Screen('gluDisk',wd,dotcolend,dotpos(1),dotpos(2),dotsize);
		end
		Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);
		if clicks==numpressneeded
			Screen('Flip',wd,[],1);
		else
			Screen('Flip',wd);
		end

	end

	checkabort;
end
getleftrightarrow;
