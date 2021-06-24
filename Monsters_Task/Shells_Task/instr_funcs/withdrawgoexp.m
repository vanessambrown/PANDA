% draw the mushroom in the given position given by lrt 
Screen('Drawtexture',wd,msh(Nmsh+1),[],tdrm(1,:));

% draw box 
Screen('Drawtexture',wd,graysquare,[],bgsquare);
Screen('DrawLines',wd,bluebox,3,blue);

% draw a blue / black dot 
dotpos = [tdrmd(2,1); tdrmd(2,2)];	
Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
Screen('gluDisk',wd,blue,dotpos(1),dotpos(2),dotsize);
Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);
Screen('Flip',wd);

numpressneeded=7;
buttons = [0 0 0 0];clicks = 0;
while (clicks < numpressneeded); % wait nogodelay seconds
	while any(buttons) 	 % if already pressing button, wait for release
		[x,y,buttons]=GetMouse;
	end

	while ~any(buttons)	% wait for start of click 
		[x,y,buttons]=GetMouse;
	end

	if any(buttons) % count clicks 
		clicks = clicks + 1;

		DrawFormattedText(wd,tx{page},'center',ypos{page},txtcolor,60,[],[],2);

		% draw the mushroom in the given position given by lrt 
		Screen('Drawtexture',wd,msh(Nmsh+1),[],tdrm(1,:));

		% draw box 
		Screen('Drawtexture',wd,graysquare,[],bgsquare);
		Screen('DrawLines',wd,bluebox,3,blue);

		if clicks==numpressneeded
			% draw a dot with colour dotcolend
			distance = tdrmd(2,1)-tdrmd(1,1);
			dotpos(1) = dotpos(1) + distance;
			Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
			Screen('gluDisk',wd,dotcolend,dotpos(1),dotpos(2),dotsize);
			Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);
			Screen('Flip',wd,[],1);
		else 
			Screen('Flip',wd);
		end

	end
end
getleftrightarrow;
