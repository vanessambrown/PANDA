% Get response for various input devices. Used in files pit.m, pittraining.m and
% pittraining_test.m. Returns mainly three variables: 
% - buttons is 1 if something was pressed, 0 if not
% - key is the identity of the key pressed
% - t is the time of the keypress

if strcmpi(respkey,'mouse');	% ........... MOUSE input. .............................

	while (any(buttons) && (GetSecs < tend))		% if already pressing button, wait for release
		[x,y,buttons]=GetMouse;
	end
	while (~any(buttons) && (GetSecs < tend))		% wait for start of click
		[x,y,buttons]=GetMouse;
	end
	t = GetSecs;
    
else                         % .......... Input through devices or keyboard .........

	if usekbqueue	           % KbQueue is more accurate for USB devices

		KbQueueFlush; 
		KbQueueStart; 
		[buttons,keyCode] = KbQueueCheck; 
		while any(buttons) & (GetSecs < tend)		% if already pressing button, wait for release
			[buttons,keyCode] = KbQueueCheck; 
		end
		while ~any(buttons) & (GetSecs < tend)		% wait for start of click
			[buttons,keyCode] = KbQueueCheck; 
			t = keyCode(keyCode~=0);	            % extract response time into variable t
		end
		key = KbName(keyCode);

	else	                    % KbCheck is standard 

		[buttons,foo,keyCode] = KbCheck; 
		while any(buttons) & (GetSecs < tend)		% if already pressing button, wait for release
			[buttons,foo,keyCode] = KbCheck; 
		end
		while ~any(buttons) & (GetSecs < tend)		% wait for start of click
			[buttons,t,keyCode] = KbCheck; 
		end
		key = KbName(keyCode);

	end

	% keyboard layout issues (like %5 etc being sent)
	if iscell(key); key=key{1};end
	if ~isempty(key) & (key(1) >= '0' && key(1) <= '9'); key = key(1); end

 	% set response flat (buttons) and check for abort key press 
	if     strcmpi(key,respkey); buttons=1; 
	elseif strcmpi(key,abortkey); 
		aborted=1; 
		Screen('Fillrect',wd,ones(1,3)*80);
		text='Aborting experiment';
		col=[200 30 0];
		Screen('TextSize',wd,60);
		DrawFormattedText(wd,text,'center','center',col,60);
		Screen('Flip', wd);
		WaitSecs(1);
		error('Pressed abort key --- aborting experiment')
	else buttons = 0; 
	end

end
