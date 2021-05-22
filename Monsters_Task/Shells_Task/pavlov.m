% timing logged for each Pavlovian trial np:
% T.pav_fixationonset(np)  start of fixation period
% T.pav_fixationend(np)  end of fixation period
% T.pav_CS_onset(np)		CS onset
% T.pav_CS_offset(np)	CS offset
% T.pav_US_onset(np)		US onset 
% T.pav_US_offset(np)	US offset / ITI onset 

fprintf('Pavlovian training trial %i\r',np);

%...........  audiovisual CS + fixation cross opposite
Screen('DrawTexture',wd,shape(pavpres(np)),[],drm (  posp(np),:));
drawfixationcross(wd,4-posp(np),fixationdotsize,1);
T.pav_CS_onset(np) = Screen('Flip',wd);
eyetrack = 0;
stim_trig = UpdateStimulusTrigger(exploc, scanning, exppart, eyetrack, stim_trig, [pav_CS_on np]);

if doaudio;PsychPortAudio('Start', soundhandle(pavpres(np)),1,0,1);end

WaitSecs(pavCSfixdelay-(GetSecs-T.pav_CS_onset(np)));	 % fixed delay - for eyetracking / signtracking 

% ........... present US together with CS
Screen('DrawTexture',wd,shape(pavpres(np)),[],drm (  posp(np),:)); % CS

% ........... deterministically show US outcome
if Z.Pavout(pavpres(np))~=0
    Screen('DrawTexture',wd,outcomep(pavpres(np)),[],drmo(4-posp(np),:)); 
    % write outcome explicitly, too 
      if Z.Pavout(pavpres(np)) == 25
        txt=['+25 Cents'];
        [wt]=Screen(wd,'TextBounds',txt);
        xpos=drmd(4-posp(np),1)-wt(3)/2;
        ypos=drmo(4-posp(np),4)+1.5*wt(4);
        Screen('Drawtext',wd,txt,xpos,ypos,green);
    elseif Z.Pavout(pavpres(np)) == 100
        txt=['+1 Dollar'];
        [wt]=Screen(wd,'TextBounds',txt);
        xpos=drmd(4-posp(np),1)-wt(3)/2;
        ypos=drmo(4-posp(np),4)+1.5*wt(4);
        Screen('Drawtext',wd,txt,xpos,ypos,green);
    elseif Z.Pavout(pavpres(np)) == -25
        txt=['-25 Cents'];
        [wt]=Screen(wd,'TextBounds',txt);
        xpos=drmd(4-posp(np),1)-wt(3)/2;
        ypos=drmo(4-posp(np),4)+.8*wt(4);
        Screen('Drawtext',wd,txt,xpos,ypos,red);
    elseif Z.Pavout(pavpres(np))== -100
        txt=['-1 Dollar'];
        [wt]=Screen(wd,'TextBounds',txt);
        xpos=drmd(4-posp(np),1)-wt(3)/2;
        ypos=drmo(4-posp(np),4)+.8*wt(4);
        Screen('Drawtext',wd,txt,xpos,ypos,red);
    elseif Z.Pavout(pavpres(np))==0 % show only CS + fixation cross in neutral trials 
        drawfixationcross(wd,4-posp(np),fixationdotsize,1);
      end
end

T.pav_CSUS_onset(np) = Screen('Flip',wd);

WaitSecs(pavCSUSfixdelay-(GetSecs-T.pav_CSUS_onset(np)));

% ........... remove CS, show only US
if Z.Pavout(pavpres(np))~=0
    Screen('DrawTexture',wd,outcomep(pavpres(np)),[],drmo(4-posp(np),:));
    % write outcome explicitly, too
    if Z.Pavout(pavpres(np)) == 25
        txt=['+25 Cents'];
        [wt]=Screen(wd,'TextBounds',txt);
        xpos=drmd(4-posp(np),1)-wt(3)/2;
        ypos=drmo(4-posp(np),4)+1.5*wt(4);
        Screen('Drawtext',wd,txt,xpos,ypos,green);
    elseif Z.Pavout(pavpres(np)) == 100
        txt=['+1 Dollar'];
        [wt]=Screen(wd,'TextBounds',txt);
        xpos=drmd(4-posp(np),1)-wt(3)/2;
        ypos=drmo(4-posp(np),4)+1.5*wt(4);
        Screen('Drawtext',wd,txt,xpos,ypos,green);
    elseif Z.Pavout(pavpres(np)) == -25
        txt=['-25 Cents'];
        [wt]=Screen(wd,'TextBounds',txt);
        xpos=drmd(4-posp(np),1)-wt(3)/2;
        ypos=drmo(4-posp(np),4)+.8*wt(4);
        Screen('Drawtext',wd,txt,xpos,ypos,red);
    elseif Z.Pavout(pavpres(np))== -100
        txt=['-1 Dollar'];
        [wt]=Screen(wd,'TextBounds',txt);
        xpos=drmd(4-posp(np),1)-wt(3)/2;
        ypos=drmo(4-posp(np),4)+.8*wt(4);
        Screen('Drawtext',wd,txt,xpos,ypos,red);
    end
    drawfixationcross(wd,posp(np),fixationdotsize,1);	% fixation cross opposite outcome

    
elseif Z.Pavout(pavpres(np))==0 % draw two fixation crosses (at CS and US position) in neutral trials after removal of CS
    drawfixationcross(wd,posp(np),fixationdotsize,1);	% fixation cross opposite outcome
    drawfixationcross(wd,4-posp(np),fixationdotsize,1);
end

T.pav_US_onset(np) = Screen('Flip',wd);
stim_trig = UpdateStimulusTrigger(exploc, scanning, exppart, eyetrack, stim_trig, [pav_US_on np]);

WaitSecs(pavUSfixdelay-(GetSecs-T.pav_US_onset(np)));	 % fixed delay


if doaudio;PsychPortAudio('Stop', soundhandle(pavpres(np)));end %soundhandle is 0, 1, 3

T.pav_offset(np) = Screen('Flip',wd);
stim_trig = UpdateStimulusTrigger(exploc, scanning, exppart, eyetrack, stim_trig, [pav_US_off np]);

WaitSecs(pavITIfixdelay-(GetSecs-T.pav_offset(np)));

checkabort; 	% Allow for abortion of experiment

if dosave; 
	eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat np T stim_trig -append']);
end


