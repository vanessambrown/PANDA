







%............. DRAW STIMULI











% draw the blue box in the given position given by lrt
% 'drm' defines coordinates for the box
if approach	% then draw the box around the stimulus
    tmp = [drm(lrt(nt),[1 3 3 1]); drm(lrt(nt),[2 2 4 4])];
    bgsquare = drm(lrt(nt),:);
else
    tmp = [drm(4-lrt(nt),[1 3 3 1]); drm(4-lrt(nt),[2 2 4 4])];
    bgsquare = drm(4-lrt(nt),:);
end
bluebox = [tmp(:,1:2) tmp(:,2:3) tmp(:,3:4) tmp(:,[4 1])];
Screen('DrawTexture',wd,graysquare,[],bgsquare);

% draw the mushroom in the given position given by lrt
% 'drm' defines coordinates for mushroom
% 'lrt' defines whether stimulus on left or right of screen, i.e. in position 1 or 3
Screen('DrawTexture',wd,msh(mprest(nt)),[],drm(lrt(nt),:));
Screen('DrawLines',wd,bluebox,4,blue);

% draw a blue dot
% drmd defines the coordinates for the dots
if ~strcmpi(respkey,'joystick')
    dotpos = [drmd(2,1); drmd(2,2)];
    Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
    Screen('gluDisk',wd,blue,dotpos(1),dotpos(2),dotsize);
    Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);
end

T.pittraining_onset(nt)= Screen('Flip',wd);	% stimulus onset time


%.............. GET MOUSE INPUT
cht(nt)=0;
if strcmpi(respkey,'mouse')
    buttons		= [0 0 0 0];
elseif strcmpi(respkey,'joystick')
    joystick_pos{nt}=0; joystick_thresh{nt}=0;time_elapsed{nt}=0;no_rescale=0;
    coll_avoid(nt)=0;   % tracks whether stimulus was collected (1), avoided (-1) or there was no response (0)
end
tend=T.pittraining_onset(nt)+nogodelay_train;

while (GetSecs < tend); % wait nogodelay seconds
    getresponse;  % returns variables: buttons, t and key
    
    if GetSecs < tend
        
        if ~strcmpi(respkey,'joystick')
            
            if (any(buttons))
                % count clicks
                cht(nt) = cht(nt)+1;
                % record click times
                T.pittraining_response(nt,cht(nt)) = t;
                % reaction times
                presstimest(nt,cht(nt)) = T.pittraining_response(nt,cht(nt)) -T.pittraining_onset(nt);
                
                % remove dot as soon as start clicking
                if cht(nt)==1;
                    
                    Screen('DrawTexture',wd,graysquare,[],bgsquare);
                    Screen('DrawTexture',wd,msh(mprest(nt)),[],drm(lrt(nt),:));
                    Screen('DrawLines',wd,bluebox,4,blue);
                    T.pittraining_removedot(nt) = Screen('Flip',wd);
                end
            end
            
        elseif strcmpi(respkey,'joystick')
            % continuously log joystick position and time
            joystick_pos{nt}=[joystick_pos{nt}; joy_pos(2)];
            joystick_thresh{nt}=[joystick_thresh{nt}; ...
                joy_thresh_ind(find(joy_levels==...
                round(joystick_pos{nt}(end)*100)))];
            time_elapsed{nt}=[time_elapsed{nt}; t-T.pittraining_onset(nt)];
            
            
            % rescale image if joystick reaches particular angle
            if length(joystick_thresh{nt})>1 && ~no_rescale && ...
                    (joystick_thresh{nt}(end)~=joystick_thresh{nt}(end-1) || ...
                    joystick_thresh{nt}(end)<=joy_fin_pos_push_instr ||...
                    joystick_thresh{nt}(end)>=joy_fin_pos_pull_instr)
                
                
                if joystick_thresh{nt}(end)==0 % original stimulus size
                    Screen('DrawTexture',wd,msh(mprest(nt)),[],drm(lrt(nt),:));
                    Screen('DrawLines',wd,bluebox,4,blue);
                elseif joystick_pos{nt}(end)<=joy_fin_pos_push_instr ||...
                        joystick_pos{nt}(end)>=joy_fin_pos_pull_instr   % remove stimulus when joystick is in final position
                    no_rescale=1;
                    
                    if joystick_pos{nt}(end)<=joy_fin_pos_push_instr
                        coll_avoid(nt)=-1;
                        %coll_avoid(nt)=round(joystick_pos{nt}(end));
                        
                    else
                        coll_avoid(nt)=1;
                        %coll_avoid(nt)=round(joystick_pos{nt}(end));
                    end
                else % modified stimulus size
                    size_adapt=round(stim_change_appr(abs(joystick_thresh{nt}(end)))/2);
                    
                    new_size=[drm(lrt(nt),1:2)-...
                        sign(joystick_thresh{nt}(end))*size_adapt ...
                        drm(lrt(nt),3:4)+sign(joystick_thresh{nt}(end))*...
                        size_adapt];
                    
                    % adjust size of blue box around stimulus
                    bluebox_new=bluebox;
                    bluebox_new(1,bluebox_new(1,:)==min(bluebox_new(1,:)))=...
                        bluebox_new(1,bluebox_new(1,:)==min(bluebox_new(1,:)))-...
                        sign(joystick_thresh{nt}(end))*size_adapt;
                    bluebox_new(2,bluebox(2,:)==min(bluebox(2,:)))=...
                        bluebox(2,bluebox(2,:)==min(bluebox(2,:)))-...
                        sign(joystick_thresh{nt}(end))*size_adapt;
                    bluebox_new(1,bluebox(1,:)==max(bluebox(1,:)))=...
                        bluebox(1,bluebox(1,:)==max(bluebox(1,:)))+...
                        sign(joystick_thresh{nt}(end))*size_adapt;
                    bluebox_new(2,bluebox(2,:)==max(bluebox(2,:)))=...
                        bluebox(2,bluebox(2,:)==max(bluebox(2,:)))+...
                        sign(joystick_thresh{nt}(end))*size_adapt;
                    
                    
                    Screen('DrawTexture',wd,msh(mprest(nt)),[],new_size);
                    Screen('DrawLines',wd,bluebox_new,4,blue);
                end
                Screen('Flip',wd);
            end
            
        end
    end
end
if presstimest(nt,1)~=0;
    treact(nt)=presstimest(nt,1);
else;
    treact(nt)=NaN;
    T.pittraining_response(nt,1)=0;	% ensure entry even if no presses
end

T.pittraining_emptyscreen(nt) = Screen('Flip',wd);	 % empty screen

%.............. SHOW WHERE DOT ENDED UP
% the dot will make it all the way to the other stimulus if press pressth times
if ~strcmpi(respkey,'joystick')
    distance = abs(drmd(2,1)-drmd(1,1));
    if approach; tmp1 = 1; if lrt(nt)==1; tmp2 = -1; else tmp2= +1; end
    else       ; tmp1 = 1; if lrt(nt)==1; tmp2 = +1; else tmp2= -1;end
    end
    travel = min(1,tmp1*cht(nt)/pressth);
    dotpos(1) = dotpos(1) + tmp2 * max(0,min(1.1,travel)*distance);
end


%............ CORRECT?

if approach
    if ainst(nt)==1; 	% go instruction
        if strcmpi(respkey,'joystick')
            if coll_avoid(nt)==1; crt(nt) = 1; % correct go
            else crt(nt) = 0; % incorrect
            end
        else
            if     cht(nt)> th;		crt(nt) = 1;% correct approach go
            elseif cht(nt)<=th;		crt(nt) = 0;% incorrect approach nogo
            end
        end
    elseif ainst(nt)==2;	% nogo instruction
        if strcmpi(respkey,'joystick')
            if coll_avoid(nt)==-1; crt(nt) = 1; % correct nogo
            else crt(nt) = 0; % incorrect
            end
        else
            if     cht(nt)<=th;		crt(nt) = 1;% correct approach nogo
            elseif cht(nt)> th;		crt(nt) = 0;% incorrect approach go
            end
        end
    end
elseif ~approach;	 % withdrawal
    if ainst(nt)==1; 	% go instruction
        if     cht(nt)> th;		crt(nt) = 1; % correct withdrawal go
        elseif cht(nt)<=th;		crt(nt) = 0; % incorrect nogo
        end
    elseif ainst(nt)==2; 	% nogo instruction
        if     cht(nt)<=th;     crt(nt) = 1; % correct nogo
        elseif cht(nt)> th;     crt(nt) = 0; % incorrect withdrawal go
        end
    end
end


%............ GIVE FEEDBACK
if shrooms; obj='shell'; else obj = 'monster';end


if strcmpi(respkey,'joystick')
    if coll_avoid(nt)==1
        text = {[obj ' collected.'],' '};
    elseif coll_avoid(nt)==-1
        text = {[obj ' thrown away.'],' '};
    else text = {'Too slow!',' '};
    end
else
    if cht(nt)>th;
        if approach
            text = {[ obj ' collected.'],' '};
            Screen('DrawTexture',wd,msh(mprest(nt)),[],drm(lrt(nt),:));
            Screen('DrawLines',wd,bluebox,4,blue);
        else
            text = {[' You ran away from the ' obj '.'],' '};
            Screen('DrawTexture',wd,graysquare,[],bgsquare);
            Screen('DrawLines',wd,bluebox,4,blue);
        end
    else
        if approach
            text = {[obj ' left behind.'],' '};
            Screen('DrawTexture',wd,graysquare,[],bgsquare);
        else
            text = {['You hid from the ' obj '.'],' '};
            Screen('DrawTexture',wd,msh(mprest(nt)),[],drm(lrt(nt),:));
        end
    end
end

yposfeedbacktext=wdh*.25;

[wt]=Screen(wd,'TextBounds',text{1});
Screen('DrawText',wd,text{1},wdw/2-wt(3)/2,yposfeedbacktext,orange);
[wt]=Screen(wd,'TextBounds',text{2});
Screen('Drawtext',wd,text{2},wdw/2-wt(3)/2,yposfeedbacktext+1.5*txtsize,orange);

if ~strcmpi(respkey,'joystick')
    Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
    Screen('gluDisk',wd,dotcolend,dotpos(1),dotpos(2),dotsize);
    Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);
end

T.pittraining_actionchosen(nt) = Screen('Flip',wd);

if strcmpi(respkey,'joystick') && ~coll_avoid(nt)
    r(nt) = -1;
    Screen('DrawTexture',wd,outcomei(2),[],drmo(2,:));
else
    if crt(nt)==crtfb(nt);
        r(nt) = 1;	 % store rewards in vector r
        Screen('DrawTexture',wd,outcomei(1),[],drmo(2,:));
    else
        r(nt) = -1;	 % store rewards in vector r
        Screen('DrawTexture',wd,outcomei(2),[],[0 0 wdwt wdht_low]); %enlarge image, leave room for feedback banner
    end
end
if r(nt)>0
    txt='You are safe.';
    [wt]=Screen(wd,'TextBounds',txt);
    xpos=drmd(2,1)-wt(3)/2;
    ypos=drmo(2,2)-1.5*wt(4);
    Screen('Drawtext',wd,txt,xpos,ypos,black);
    txt='SAFE';
    [wt]=Screen(wd,'TextBounds',txt);
    xpos=drmd(2,1)-wt(3)/2;
    ypos=drmo(2,4)+1.5*wt(4);
    Screen('Drawtext',wd,txt,xpos,ypos,black);
elseif r(nt)<0
    txt='Oh no! You got caught.';
    [wt]=Screen(wd,'TextBounds',txt);
    xpos=drmd(2,1)-wt(3)/2;
    ypos=drmo(2,4)+8.5*wt(4);
    Screen('Drawtext',wd,txt,xpos,ypos,red);
    
end

WaitSecs(1.1-(GetSecs-T.pittraining_actionchosen(nt)));

T.pittraining_feedback(nt) = Screen('Flip',wd);
if doaudio_instr == 1 && r(nt)<0; PsychPortAudio('Start', soundinstr(2),1,0,1); end

% check learning criterion after crit(3) trials
if nt>Z.crit(3)
    if sum(crt(end-Z.crit(2)+1:end))/Z.crit(2)>Z.crit(1);
        fprintf('Instrumental criterion of %g correct over past %i trials reached\n',Z.crit(1),Z.crit(2))
        cht        ((nt+1):Z.Ntrain)=NaN;
        crt        ((nt+1):Z.Ntrain)=NaN;
        r          ((nt+1):Z.Ntrain)=NaN;
        treact     ((nt+1):Z.Ntrain)=NaN;
        presstimest((nt+1):Z.Ntrain,:)=NaN;
        dobreak=1;
    end
end

checkabort; 		% Allow for abortion of experiment

if strcmpi(devicetype,'joystick')
    T.joystick_pos_ins=joystick_pos;
    T.joystick_thresh_ins = joystick_thresh;
    T.time_elapsed_ins = time_elapsed;
end

if dosave;
    eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat nt cht crt r presstimest T stim_trig treact -append']);
end

WaitSecs(1.5 - (GetSecs-T.pittraining_feedback(nt)));		% Delay before feedback switched off and we move on to little square to initiate next trial

fprintf('Instrumental training trial %i\r',nt);
