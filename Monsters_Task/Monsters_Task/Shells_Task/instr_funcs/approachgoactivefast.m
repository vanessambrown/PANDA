% draw the mushroom in the given position given by lrt 
Screen('DrawTexture',wd,msh(Nmsh+1),[],tdrm(1,:));

% draw box 
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
	if strcmpi(respkey,'mouse');
		while any(buttons) 	% if already pressing button, wait for release
			[x,y,buttons]=GetMouse;
		end
		while ~any(buttons)		% wait for start of click
			[x,y,buttons]=GetMouse;
		end
	else 
		if usekbqueue	           % KbQueue is more accurate for USB devices
			KbQueueFlush; 
			KbQueueStart; 
			[buttons,keyCode] = KbQueueCheck; 
			while any(buttons) 		% if already pressing button, wait for release
				[buttons,keyCode] = KbQueueCheck; 
			end
			while ~any(buttons) 		% wait for start of click
				[buttons,keyCode] = KbQueueCheck; 
				t = keyCode(keyCode~=0);	            % extract response time into variable t
			end
			key = KbName(keyCode);

		else	                    % KbCheck is standard 
			while any(buttons) 	% if already pressing button, wait for release
				[buttons,foo,keyCode] = KbCheck; 
			end
			while ~any(buttons)		% wait for start of click
				[buttons,foo,keyCode] = KbCheck; 
			end
			key = KbName(keyCode);
		end

		% keyboard layout issues (like %5 etc being sent)
		if iscell(key); key=key{1};end
		if ~isempty(key) & (key(1) >= '0' && key(1) <= '9'); key = key(1); end

		if     strcmpi(key,respkey); buttons=1; 
		elseif strcmpi(key,'ESCAPE'); 
			aborted=1; 
			Screen('Fillrect',wd,ones(1,3)*80);
			text='Aborting experiment';
			col=[200 30 0];
			Screen('TextSize',wd,60);
			DrawFormattedText(wd,text,'center','center',col,60);
			error('Pressed ESC --- aborting experiment')
		else buttons = 0; 
		end
	end

	if any(buttons); % count clicks 
		clicks = clicks + 1;

		DrawFormattedText(wd,tx{page},'center',ypos{page},txtcolor,60,[],[],1.3);

		% draw the mushroom in the given position given by lrt 
		Screen('DrawTexture',wd,msh(Nmsh+1),[],tdrm(1,:));

		% draw box 
		Screen('DrawLines',wd,bluebox,3,blue);


		% draw a blue / black dot 
		distance = tdrmd(2,1)-tdrmd(1,1);
		dotpos(1) = dotpos(1) - distance/numpressneeded;
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
end
getleftrightarrow;
