

% draw box for joystick
if strcmpi(respkey,'joystick')
    tmp = [tdrm(1,[1 3 3 1]); tdrm(1,[2 2 4 4])];
    bluebox = [tmp(:,1:2) tmp(:,2:3) tmp(:,3:4) tmp(:,[4 1])];
end

% draw the mushroom in the given position given by lrt
Screen('DrawTexture',wd,msh(Nmsh+1),[],tdrm(1,:));

% draw box
% draw box
tmp = [tdrm(1,[1 3 3 1]); tdrm(1,[2 2 4 4])];
bluebox = [tmp(:,1:2) tmp(:,2:3) tmp(:,3:4) tmp(:,[4 1])];
Screen('DrawLines',wd,bluebox,3,blue);
Screen('DrawLines',wd,bluebox,3,blue);


% draw a blue / black dot
if ~strcmpi(respkey,'joystick')
    
    % draw the mushroom in the given position given by lrt
    Screen('DrawTexture',wd,msh(Nmsh+1),[],tdrm(1,:));
    
    
    
    
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
        while any(buttons) 	% if already pressing button, wait for release
            [x,y,buttons]=GetMouse;
        end
        while ~any(buttons)		% wait for start of click
            [x,y,buttons]=GetMouse;
        end
    elseif strcmpi(respkey,'joystick') %register joystick position
        
        [joy_pos, buttons] = mat_joy(joyid_ins);
        
        joystick_pos=[joystick_pos; joy_pos(2)];
        joystick_thresh=[joystick_thresh; joy_thresh_ind(find(joy_levels==...
            round(joystick_pos(end)*100)))];
        clicks=joystick_thresh(end);
        
        % rescale image
        %if joystick_thresh(end-1)~=joystick_thresh(end)
        
        if joystick_thresh(end)==0 % original stimulus size
            Screen('DrawTexture',wd,msh(Nmsh+1),[],tdrm(1,:));
            Screen('DrawLines',wd,bluebox,3,blue);
        elseif joystick_thresh(end)~=0 ...
                %&& joystick_pos(end)>=joy_fin_pos_pull % change size of stimulus
            size_adapt=round(stim_change_appr(abs(joystick_thresh(end)))/2);
            
            new_size=[tdrm(1,1:2)-sign(joystick_thresh(end))*size_adapt ...
                tdrm(1,3:4)+sign(joystick_thresh(end))*size_adapt];
            
            
            % adjust size of blue box around stimulus
            bluebox_new=bluebox;
            bluebox_new(1,bluebox_new(1,:)==min(bluebox_new(1,:)))=...
                bluebox_new(1,bluebox_new(1,:)==min(bluebox_new(1,:)))-...
                sign(joystick_thresh(end))*size_adapt;
            bluebox_new(2,bluebox(2,:)==min(bluebox(2,:)))=...
                bluebox(2,bluebox(2,:)==min(bluebox(2,:)))-...
                sign(joystick_thresh(end))*size_adapt;
            bluebox_new(1,bluebox(1,:)==max(bluebox(1,:)))=...
                bluebox(1,bluebox(1,:)==max(bluebox(1,:)))+...
                sign(joystick_thresh(end))*size_adapt;
            bluebox_new(2,bluebox(2,:)==max(bluebox(2,:)))=...
                bluebox(2,bluebox(2,:)==max(bluebox(2,:)))+...
                sign(joystick_thresh(end))*size_adapt;
            
            Screen('DrawTexture',wd,msh(Nmsh+1),[],new_size);
            Screen('DrawLines',wd,bluebox_new,3,blue);
        end
        
        DrawFormattedText(wd,tx{page},'center',ypos{page},txtcolor,60,[],[],1.3);
        
        Screen('Flip',wd);
        
        
        %end
        
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
    
    if ~strcmpi(respkey,'joystick') && any(buttons) % count clicks
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
    
    checkabort;
end

if strcmpi(respkey,'joystick')
    if shrooms;
        DrawFormattedText(wd, ...
            ['Diese Muschel hätten Sie jetzt eingesammelt. Klicken Sie eine Taste, um weiterzumachen.'],...
            'center','center',txtcolor,60,[],[],1.3);
    else
        DrawFormattedText(wd, ...
            ['Dieses Blatt hätten Sie jetzt eingesammelt. Klicken Sie eine Taste, um weiterzumachen.'],...
            'center','center',txtcolor,60,[],[],1.3);
    end
    
end

getleftrightarrow;








