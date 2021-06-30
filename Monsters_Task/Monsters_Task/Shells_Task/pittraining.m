
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
parport = io64();
parportstatus = io64(parport); 
%send parallel port code after flip to signal stimulus onset
sendparport(sparport.parportcodes.p1stimonset);


%.............. GET MOUSE INPUT
cht(nt)=0;
buttons		= [0 0 0 0];
tend=T.pittraining_onset(nt)+nogodelay_train;

while (GetSecs < tend); % wait nogodelay seconds
    getresponse;  % returns variables: buttons, t and key
    
    if GetSecs < tend
            
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
    distance = abs(drmd(2,1)-drmd(1,1));
    if approach; tmp1 = 1; if lrt(nt)==1; tmp2 = -1; else tmp2= +1; end
    else       ; tmp1 = 1; if lrt(nt)==1; tmp2 = +1; else tmp2= -1;end
    end
    travel = min(1,tmp1*cht(nt)/pressth);
    dotpos(1) = dotpos(1) + tmp2 * max(0,min(1.1,travel)*distance);


%............ CORRECT?

if approach
    if ainst(nt)==1; 	% go instruction
            if     cht(nt)> th;		crt(nt) = 1;% correct approach go
            elseif cht(nt)<=th;		crt(nt) = 0;% incorrect approach nogo
            end
    elseif ainst(nt)==2;	% nogo instruction
            if     cht(nt)<=th;		crt(nt) = 1;% correct approach nogo
            elseif cht(nt)> th;		crt(nt) = 0;% incorrect approach go
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

yposfeedbacktext=wdh*.25;

[wt]=Screen(wd,'TextBounds',text{1});
Screen('DrawText',wd,text{1},wdw/2-wt(3)/2,yposfeedbacktext,orange);
[wt]=Screen(wd,'TextBounds',text{2});
Screen('Drawtext',wd,text{2},wdw/2-wt(3)/2,yposfeedbacktext+1.5*txtsize,orange);

Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
Screen('gluDisk',wd,dotcolend,dotpos(1),dotpos(2),dotsize);
Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);


T.pittraining_actionchosen(nt) = Screen('Flip',wd);
%send parport code to flag action chosen
sendparport(sparport.parportcodes.p1actionchosen);

    if crt(nt)==crtfb(nt);
        r(nt) = 1;	 % store rewards in vector r
        Screen('DrawTexture',wd,outcomei(1),[],drmo(2,:));
    else
        r(nt) = -1;	 % store rewards in vector r
        Screen('DrawTexture',wd,outcomei(2),[],[0 0 wdwt wdht_low]); %enlarge image, leave room for feedback banner
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
    ypos=drmo(2,4)+13.5*wt(4); % if text is missing, try 8.5
    Screen('Drawtext',wd,txt,xpos,ypos,red);
    
end

WaitSecs(1.1-(GetSecs-T.pittraining_actionchosen(nt)));

T.pittraining_feedback(nt) = Screen('Flip',wd);

% send parport code to mark feedback 
sendparport(sparport.parportcodes.p1feedback);

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

if dosave;
    eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat nt cht crt r presstimest T stim_trig treact -append']);
end

WaitSecs(1.5 - (GetSecs-T.pittraining_feedback(nt)));		% Delay before feedback switched off and we move on to little square to initiate next trial

fprintf('Instrumental training trial %i\r',nt);
