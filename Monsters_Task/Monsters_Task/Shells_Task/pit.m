% logged timing for each PIT trail npit:
% T.pit_fillscreen(npit)   fill screen with Pavlovian stimuli
% T.pit_onset(npit)        instrumental stimulus onset
% T.pit_response(npit,ch)  button press for click ch in trial npit
% T.pit_removedot(npit)    remove dot after first button press
% T.pit_drawdot(npit)      draw dot
% T.pit_ITIfixcross(npit)  draw central fixation cross, begin ITI

%............. DRAW STIMULI

% fill the screen background with the Pavlovian stimulus
Screen('DrawTexture',wd,bgshape(mpresp(npit)),[],bgr);
if doaudio; PsychPortAudio('Start', soundhandle(mpresp(npit)),1,0,1);end
T.pit_fillscreen(npit) = Screen('Flip',wd,[],1); % Pav background onset time
if ~scanning; sendparport(sparport.parportcodes.p3csonset); end %parport code marking cs tile onset
%stim_trig = UpdateStimulusTrigger(exploc, scanning, exppart, eyetrack, stim_trig, [pit_bg npit]);

WaitSecs(pitdelay-(GetSecs-(T.pit_fillscreen(npit))));

% draw the blue box in the given position given by lr
% 'drm' defines coordinates for the box
if approach	% then draw the box around the stimulus
    tmp = [drm(lr(npit),[1 3 3 1]); drm(lr(npit),[2 2 4 4])];
    bgsquare = drm(lr(npit),:);
else
    tmp = [drm(4-lr(npit),[1 3 3 1]); drm(4-lr(npit),[2 2 4 4])];
    bgsquare = drm(4-lr(npit),:);
end
bluebox = [tmp(:,1:2) tmp(:,2:3) tmp(:,3:4) tmp(:,[4 1])];
Screen('DrawTexture',wd,graysquare,[],bgsquare);

% draw the mushroom in the given position given by lr
% 'drm' defines coordinates for mushroom
% 'lr' defines whether stimulus on let or right of screen, i.e. in position 1 or 3
Screen('DrawTexture',wd,msh(mpres(npit)),[],drm(lr(npit),:));
Screen('DrawLines',wd,bluebox,4,blue);

% draw a blue dot
% drmd defines the coordinates for the dots
dotpos = [drmd(2,1); drmd(2,2)];
Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
Screen('gluDisk',wd,blue,dotpos(1),dotpos(2),dotsize);
Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);

T.pit_onset(npit) = Screen('Flip',wd);	% stimulus onset time
if ~scanning; sendparport(sparport.parportcodes.p3stimonset); end %parport code marking instrumental stimulus onset


%.............. GET RESPONSE
ch(npit)	= 0;
buttons		= [0 0 0 0];

tend = T.pit_onset(npit) + nogodelay_pit;

while (GetSecs < tend); % wait nogodelay seconds
    getresponse;  % returns variables: buttons, t and key
    
    if GetSecs < tend
            
            if (any(buttons))
                % count responses
                ch(npit) = ch(npit)+1;
                % record response times 
                T.pit_response(npit,ch(npit)) = t(1);
                % reaction times
                presstimes(npit,ch(npit)) = T.pit_response(npit,ch(npit)) -T.pit_onset(npit);
                
                % remove dot as soon as start clicking
                if ch(npit)==1;
                    Screen('DrawTexture',wd,bgshape(mpresp(npit)),[],bgr);
                    Screen('DrawTexture',wd,graysquare,[],bgsquare);
                    Screen('DrawTexture',wd,msh(mpres(npit)),[],drm(lr(npit),:));
                    Screen('DrawLines',wd,bluebox,4,blue);
                    T.pit_removedot(npit) = Screen('Flip',wd);
                end
            end
    end
end


if presstimes(npit,1)~=0;
    pitreact(npit) = presstimes(npit,1);
else;
    pitreact(npit) = NaN;
    T.pit_response(npit,1)=0;	% ensure entry even if no presses
end

%.............. SHOW WHERE DOT ENDED UP
% the dot will make it all the way to the other stimulus if press pressth times
if ~strcmpi(respkey,'joystick')
    distance = abs(drmd(2,1)-drmd(1,1));
    if approach;	tmp1 = 1; if lr(npit)==1; tmp2 = -1; else tmp2= +1; end
    else			   tmp1 = 1; if lr(npit)==1; tmp2 = +1; else tmp2= -1;end
    end
    travel = min(1,tmp1*ch(npit)/pressth);
    dotpos(1) = dotpos(1) + tmp2 * max(0,min(1.1,travel)*distance);
    
    Screen('DrawTexture',wd,bgshape(mpresp(npit)),[],bgr);
    Screen('DrawTexture',wd,graysquare,[],bgsquare);
    Screen('DrawTexture',wd,msh(mpres(npit)),[],drm(lr(npit),:));
    Screen('DrawLines',wd,bluebox,4,blue);
    Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
    Screen('gluDisk',wd,dotcolend,dotpos(1),dotpos(2),dotsize);
    Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);
end

T.pit_drawdot(npit) = Screen('Flip',wd);
if ~scanning; sendparport(sparport.parportcodes.p3choice); end; %parport code marking choice confirmation

% draw central fixation cross
drawfixationcross(wd,2,fixationdotsize,0);
WaitSecs(.4-(GetSecs-T.pit_drawdot(npit)));
T.pit_ITIfixcross(npit) = Screen('Flip',wd);
if ~scanning; sendparport(sparport.parportcodes.p3itionset); end; %parport code marking start of ITI

%............ CORRECT?

if ~isnan(ch(npit))
    if approach
        if ains(npit)==1; 	% go instruction
                if     ch(npit)> th;		cr(npit) = 1;% correct approach go
                elseif ch(npit)<=th;		cr(npit) = 0;% incorrect approach nogo
                end
        elseif ains(npit)==2;	% nogo instruction
                if     ch(npit)<=th;		cr(npit) = 1;% correct approach nogo
                elseif ch(npit)> th;		cr(npit) = 0;% incorrect approach go
                end
        end
    elseif ~approach;	 % withdrawal
        if ains(npit)==1; 	% go instruction
            if     ch(npit)> th;		cr(npit) = 1; % correct withdrawal go
            elseif ch(npit)<=th;		cr(npit) = 0; % incorrect nogo
            end
        elseif ains(npit)==2; 	% nogo instruction
            if     ch(npit)<=th;    cr(npit) = 1; % correct nogo
            elseif ch(npit)> th;    cr(npit) = 0; % incorrect withdrawal go
            end
        end
    end
else
    cr(npit)=NaN;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%............ GIVING PUNISHMENT ON SECOND & FOURTH TRIALS
crtfbpit(1:5) = 1; % set crtfbpit to 1 for first 5 trials, so they are scheduled to get accurate feedback on all 5 trials

if npit == 2 || npit == 4 %% response on the second or fourth trial
    
if shrooms; obj='shell'; else obj = 'monster';end

%first give accurate feedback on what the participant actually did
if ch(npit)>th
    if approach
        text = {[ obj ' collected.'],' '};
        Screen('DrawTexture',wd,msh(mpresp(npit)),[],drm(lr(npit),:));
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
            Screen('DrawTexture',wd,msh(mpres(npit)),[],drm(lr(npit),:));
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

T.pit_actionchosen(npit) = Screen('Flip',wd);
if ~scanning; sendparport(sparport.parportcodes.p3choice); end; %parport code marking choice confirmation


%% but administer the punishment whether they were right or wrong

Screen('DrawTexture',wd,outcomei(2),[],[0 0 wdwt wdht_low]); %administer the punishment

    txt='Oh no! You got caught.';
    [wt]=Screen(wd,'TextBounds',txt);
    xpos=drmd(2,1)-wt(3)/2;
    ypos=drmo(2,4)+13.5*wt(4); %if text is missing, try 8.5
    Screen('Drawtext',wd,txt,xpos,ypos,red);

T.pit_feedback(npit) = Screen('Flip',wd);
if ~scanning; sendparport(sparport.parportcodes.p3feedback); end; %parport code to mark punishment on trials 2 and 4
if doaudio_instr == 1; PsychPortAudio('Start', soundinstr(pitwav),1,0,1); end

WaitSecs(1.1)

% draw central fixation cross
drawfixationcross(wd,2,fixationdotsize,0);
WaitSecs(.4-(GetSecs-T.pit_drawdot(npit)));
T.pit_ITIfixcross(npit) = Screen('Flip',wd);
if~scanning; sendparport(sparport.parportcodes.p3itionset); end; %parport code marking start of ITI

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if dosave;
    eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat npit ch cr presstimes T stim_trig pitreact -append']);
end

fprintf('PIT trial %i\r',npit);

checkabort;			% Allow for abortion of experiment

WaitSecs(Z.ITIPit(npit)-(GetSecs-T.pit_ITIfixcross(npit)));
T.pit_endtrial(npit)=GetSecs;

