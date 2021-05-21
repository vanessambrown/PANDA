%............. DRAW STIMULI 

% draw the blue box in the given position given by lrtest 
% 'drm' defines coordinates for the box 
if approachtest	% then draw the box around the stimulus 
	tmp = [drm(lrtest(ntest),[1 3 3 1]); drm(lrtest(ntest),[2 2 4 4])];	 
	bgsquare = drm(lrtest(ntest),:);
else %draws the withdrawal setup
	tmp = [drm(4-lrtest(ntest),[1 3 3 1]); drm(4-lrtest(ntest),[2 2 4 4])];	 
	bgsquare = drm(4-lrtest(ntest),:);
end
bluebox = [tmp(:,1:2) tmp(:,2:3) tmp(:,3:4) tmp(:,[4 1])];
Screen('DrawTexture',wd,graysquare,[],bgsquare);

% draw the mushroom in the given position given by lrtest 
% 'drm' defines coordinates for mushroom 
% 'lrtest' defines whether stimulus on let or right of screen, i.e. in position 1 or 3 
Screen('DrawTexture',wd,mshtest(mprestest(ntest)),[],drm(lrtest(ntest),:));
Screen('DrawLines',wd,bluebox,4,blue);

% draw a blue dot 
% drmd defines the coordinates for the dots 
if ~strcmpi(respkey,'joystick')
    dotpos = [drmd(2,1); drmd(2,2)];
    Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
    Screen('gluDisk',wd,blue,dotpos(1),dotpos(2),dotsize);
    Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);
end

[t0]= Screen('Flip',wd);	% t0 is stimulus onset time

%.............. GET MOUSE INPUT
chtest(ntest)=0;
if strcmpi(respkey,'mouse'); buttons		= [0 0 0 0];
elseif strcmpi(respkey,'joystick')
    clear joystick_pos
    clear joystick_thresh
    joystick_pos{ntest}=0; joystick_thresh{ntest}=0;time_elapsed{ntest}=0;no_rescale=0;
    coll_avoid(ntest)=0;   % tracks whether stimulus was collected (1), avoided (-1) or there was no response (0)
end
tend=t0+nogodelay_train;


while (GetSecs < tend); % wait nogodelay seconds
    getresponse;
         
    if strcmpi(respkey,'joystick')
        % continuously log joystick position and time
        joystick_pos{ntest}=[joystick_pos{ntest}; joy_pos(2)];
        joystick_thresh{ntest}=[joystick_thresh{ntest}; ...
            joy_thresh_ind(find(joy_levels==...
            round(joystick_pos{ntest}(end)*100)))];
      %  time_elapsed{ntest}=[time_elapsed{ntest}; t-T.pittraining_onset(ntest)];
        
        
        % rescale image if joystick reaches particular angle
        if length(joystick_thresh{ntest})>1 && ~no_rescale && ...
                (joystick_thresh{ntest}(end)~=joystick_thresh{ntest}(end-1) || ...
                joystick_thresh{ntest}(end)<=joy_fin_pos_push_instr ||...
                joystick_thresh{ntest}(end)>=joy_fin_pos_pull_instr)
            
            
            if joystick_thresh{ntest}(end)==0 % original stimulus size
                Screen('DrawTexture',wd,mshtest(mprestest(ntest)),[],drm(lrtest(ntest),:));
                Screen('DrawLines',wd,bluebox,4,blue);
                
            elseif joystick_pos{ntest}(end)<=joy_fin_pos_push_instr ||...
                joystick_pos{ntest}(end)>=joy_fin_pos_pull_instr
               % abs(joystick_pos{ntest}(end))>=joy_fin_pos |... % remove stimulus when joystick is in final position
                no_rescale=1;
                if joystick_pos{ntest}(end)<=joy_fin_pos_push_instr
                    coll_avoid(ntest)=-1;
                else
                    coll_avoid(ntest)=1;
                %coll_avoid(ntest)=round(joystick_pos{ntest}(end));
                end
                
            else % modified stimulus size
                size_adapt=round(stim_change_appr(abs(joystick_thresh{ntest}(end)))/2);
                
                new_size=[drm(lrtest(ntest),1:2)-...
                    sign(joystick_thresh{ntest}(end))*size_adapt ...
                    drm(lrtest(ntest),3:4)+sign(joystick_thresh{ntest}(end))*...
                    size_adapt];
                
                % adjust size of blue box around stimulus
                bluebox_new=bluebox;
                bluebox_new(1,bluebox_new(1,:)==min(bluebox_new(1,:)))=...
                    bluebox_new(1,bluebox_new(1,:)==min(bluebox_new(1,:)))-...
                    sign(joystick_thresh{ntest}(end))*size_adapt;
                bluebox_new(2,bluebox(2,:)==min(bluebox(2,:)))=...
                    bluebox(2,bluebox(2,:)==min(bluebox(2,:)))-...
                    sign(joystick_thresh{ntest}(end))*size_adapt;
                bluebox_new(1,bluebox(1,:)==max(bluebox(1,:)))=...
                    bluebox(1,bluebox(1,:)==max(bluebox(1,:)))+...
                    sign(joystick_thresh{ntest}(end))*size_adapt;
                bluebox_new(2,bluebox(2,:)==max(bluebox(2,:)))=...
                    bluebox(2,bluebox(2,:)==max(bluebox(2,:)))+...
                    sign(joystick_thresh{ntest}(end))*size_adapt;
                
                
                Screen('DrawTexture',wd,mshtest(mprestest(ntest)),[],new_size);
                Screen('DrawLines',wd,bluebox_new,4,blue);
            end
            Screen('Flip',wd);
        end
        
    else        
        if (any(buttons) & GetSecs < tend)
            % countest clicks & record click times
            chtest(ntest) = chtest(ntest)+1;

            
            % remove dot as soon as start clicking
            if chtest(ntest)==1;
                
                Screen('DrawTexture',wd,graysquare,[],bgsquare);
                Screen('DrawTexture',wd,mshtest(mprestest(ntest)),[],drm(lrtest(ntest),:));
                Screen('DrawLines',wd,bluebox,4,blue);
                Screen('Flip',wd);
            end
        end
        
    end
    
    
end







%.............. SHOW WHERE DOT ENDED UP 
% the dot will make it all the way to the other stimulus if press pressth times
if ~strcmpi(respkey,'joystick')
    distance = abs(drmd(2,1)-drmd(1,1));
    if approachtest; tmp1 = 1; if lrtest(ntest)==1; tmp2 = -1; else tmp2= +1; end
    else       ; tmp1 = 1; if lrtest(ntest)==1; tmp2 = +1; else tmp2= -1;end
    end
    travel = min(1,tmp1*chtest(ntest)/pressth);
    dotpos(1) = dotpos(1) + tmp2 * max(0,min(1.1,travel)*distance);
end

%............ CORRECT? 

Screen('Flip',wd);	 % empty screen 

if approachtest
    if ainstest(ntest)==1; 	% go instruction
        if strcmpi(respkey,'joystick')
            if coll_avoid(ntest)==1; crtest(ntest) = 1; % correct go
            else crtest(ntest) = 0; % incorrect
            end
        else
            if     chtest(ntest)> th;		crtest(ntest) = 1;% correct approachtest go
            elseif chtest(ntest)<=th;		crtest(ntest) = 0;% incorrect approachtest nogo
            end
        end
    elseif ainstest(ntest)==2;	% nogo instruction
        if strcmpi(respkey,'joystick')
            if coll_avoid(ntest)==-1; crtest(ntest) = 1; % correct nogo
            else crtest(ntest) = 0; % incorrect
            end
        else
            if     chtest(ntest)<=th;		crtest(ntest) = 1;% correct approachtest nogo
            elseif chtest(ntest)> th;		crtest(ntest) = 0;% incorrect approachtest go
            end
        end
    end
elseif ~approachtest;	 % withdrawal
	if ainstest(ntest)==1; 	% go instruction
		if     chtest(ntest)> th;		crtest(ntest) = 1; % correct withdrawal go 
		elseif chtest(ntest)<=th;		crtest(ntest) = 0; % incorrect nogo 
		end
	elseif ainstest(ntest)==2; 	% nogo instruction 
		if     chtest(ntest)<=th;     crtest(ntest) = 1; % correct nogo 
		elseif chtest(ntest)> th;     crtest(ntest) = 0; % incorrect withdrawal go 
		end
	end
end


%............ GIVE FEEDBACK 
if shrooms; obj='shell'; else obj = 'monster';end

if strcmpi(respkey,'joystick')
    if coll_avoid(ntest)==1
         text = {[obj ' collected.'],' '};act='collected';
    elseif coll_avoid(ntest)==-1
        text = {['You ran away.'],' '}; act='ran away';
    else text = {'Too slow!',' '};
    end
else
    if chtest(ntest)>th;
        if approachtest
            text = {[obj ' collected.'],' '};act='collected';
            Screen('DrawTexture',wd,mshtest(mprestest(ntest)),[],drm(lrtest(ntest),:));
            Screen('DrawLines',wd,bluebox,4,blue);
        else %%% this is the response for the avoidance condition
            text = {['You ran away.'],' '}; act='run away';
            Screen('DrawTexture',wd,graysquare,[],bgsquare);
            Screen('DrawLines',wd,bluebox,4,blue);
        end
    else
        if approachtest
            text = {[obj ' left behind.'],' '};
            act='left';
            Screen('DrawTexture',wd,graysquare,[],bgsquare);
        else %%% this is the response for the avoidance condition
            text = {['You hid.'],' '}; act='hide';
            Screen('DrawTexture',wd,mshtest(mprestest(ntest)),[],drm(lrtest(ntest),:));
        end
    end
end
    yposfeedbacktext=wdh*.25;

[wt]=Screen(wd,'TextBounds',text{1});
Screen('DrawText',wd,text{1},wdw/2-wt(3)/2,yposfeedbacktext,txtcolor);
[wt]=Screen(wd,'TextBounds',text{2});
Screen('Drawtext',wd,text{2},wdw/2-wt(3)/2,yposfeedbacktext+1.5*txtsize,txtcolor);
if ~strcmpi(respkey,'joystick')
    Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
    Screen('gluDisk',wd,dotcolend,dotpos(1),dotpos(2),dotsize);
    Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);
    Screen('Flip',wd);
end

WaitSecs(1.1);

if strcmpi(respkey,'joystick') && ~coll_avoid(ntest)
    r(ntest) = -1;
    Screen('DrawTexture',wd,outcomei(3),[],drmo(2,:));
else
    if crtest(ntest)==crtestfb(ntest);
        r(ntest) = 1;	 % store rewards in vector r
        %txt = {'+ 20 Cent'};
        Screen('DrawTexture',wd,outcomei(1),[],drmo(2,:));
    else
        r(ntest) = -1;	 % store rewards in vector r
        %txt = {'- 20 Cent'};
        Screen('DrawTexture',wd,outcomei(3),[],[0 0 wdwt wdht_low]); %%%%%% need to change the size of the image here
    end
end

if r(ntest)>0
	txt='Good choice.';
		[wt]=Screen(wd,'TextBounds',txt);
		xpostest=drmd(2,1)-wt(3)/2;
		ypostest=drmo(2,2)-1.5*wt(4);
		Screen('Drawtext',wd,txt,xpostest,ypostest,black);
	txt=['You are safe from the monster.'];
		[wt]=Screen(wd,'TextBounds',txt);
		xpostest=drmd(2,1)-wt(3)/2;
		ypostest=drmo(2,4)+1.5*wt(4);
		Screen('Drawtext',wd,txt,xpostest,ypostest,black);
elseif r(ntest)<0
	txt='Oh no! You were caught by the monster!';
		[wt]=Screen(wd,'TextBounds',txt);
		xpostest=drmd(2,1)-wt(3)/2;
		ypostest=drmo(2,4)+8.5*wt(4); %move text down to the bottom banner based on percentage of screen size
		Screen('Drawtext',wd,txt,xpostest,ypostest,red);
end

Screen('Flip',wd);
if doaudio_instr == 1 && r(ntest)<0;PsychPortAudio('Start', soundinstr(1),1,0,1); end

WaitSecs(1.5);		% Delay before feedback switched off and we move on to little square to initiate next trial
checkabort;

if crtest(ntest)==1; %the response was correct
    text='Great, that was the right decision. ';
    rew='were not caught by the monster.';
    
    if shrooms
        fut=' When you see that shell in the future, you should continue to ';
    else fut=' When you see that monster in the future, you should continue to ';
    end
    if strcmpi(respkey,'joystick')
        if     coll_avoid(ntest)==1 ; fut=[fut 'collect it. '];
        elseif  coll_avoid(ntest)==-1 ; fut=[fut 'throw it away. '];
        end

    else
        if     chtest(ntest)>th  &  approachtest; fut=[fut 'collect it. '];
        elseif chtest(ntest)>th  & ~approachtest; fut=[fut 'run away. '];
        elseif chtest(ntest)<=th &  approachtest; fut=[fut 'leave it behind. '];
        elseif chtest(ntest)<=th & ~approachtest; fut=[fut 'hide. '];
        end
        
    end
else %if the response was incorrect
	text='Oh no! That was the wrong decision. ';
	rew='were caught by the monster.';
    if shrooms
        fut=' When you see that shell again, you should choose to ';
    else fut=' When you see that monster again, you should choose to ';
    end
    if strcmpi(respkey,'joystick')
        if      coll_avoid(ntest)==1; fut=[fut 'throw it away. '];
        elseif coll_avoid(ntest)==-1; fut=[fut 'collect it. '];
        end
    else
        if     chtest(ntest)>th  &  approachtest; fut=[fut 'leave it behind. '];
        elseif chtest(ntest)>th  & ~approachtest; fut=[fut 'hide. '];
        elseif chtest(ntest)<=th &  approachtest; fut=[fut 'collect it. '];
        elseif chtest(ntest)<=th & ~approachtest; fut=[fut 'run away. '];
        end
    end
end

if strcmpi(respkey,'joystick')
    if coll_avoid(ntest)==0 ; %no response was made
        text=[' Unfortunately, you moved the joystick too slowly and therefore 20 cents ' rew '. ' 'Please move the joystick faster next time.'];
    else
        if shrooms
            text=[text ' You ' act ' this shell and ' rew ' 10 cents. ' fut ];
        else text=[text ' You ' act ' this leaf and ' rew ' 10 cents. ' fut ];
        end
    end
else
    if shrooms
        text=[text ' You ' act ' this shell and ' rew ' 20 cents. ' fut ];
    else text=[text ' You chose to ' act ', and ' rew fut ];
    end
end

DrawFormattedText(wd,text,'center',yposm,txtcolor,60,[],[],2);

if strcmpi(respkey,'mouse')
    text='Click the mouse to continue.';
		DrawFormattedText(wd,text,'center',yposb,txtcolor,60,[],[],2);
		Screen('Flip',wd);
		buttons=[0 0 0 0];
		while ~any(buttons);[x,y,buttons]=GetMouse;end
		while  any(buttons);[x,y,buttons]=GetMouse;end
else
    text='Click a button to continue.';
		DrawFormattedText(wd,text,'center',yposb,txtcolor,60,[],[],2);
		Screen('Flip',wd);
		while 1 
			if usekbqueue
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
			else
				[foo,keyCode]=KbStrokeWait;
				key = KbName(keyCode);
			end

			% keyboard layout issues (like %5 etc being sent)
			if iscell(key); key=key{1};end
			if ~isempty(key) & (key(1) >= '0' && key(1) <= '9'); key = key(1); end

			if     strcmpi(key,rightkey)|strcmpi(key,leftkey )|strcmpi(key,respkey );break; 
			elseif strcmpi(key,'ESCAPE'); 
				aborted=1; 
				Screen('Fillrect',wd,ones(1,3)*80);
				text='Aborting experiment';
				col=[200 30 0];
				Screen('TextSize',wd,60);
				DrawFormattedText(wd,text,'center','center',col,60);
				error('Pressed ESC --- aborting experiment')
			end
		end
end

checkabort; 		% Allow for abortion of experimentest


