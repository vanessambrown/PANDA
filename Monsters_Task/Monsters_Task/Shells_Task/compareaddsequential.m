% count the number of queries 
citadd = citadd + 1;

% draw Pavlovian stimulus 1 
Screen('DrawTexture',wd,shape(cppresadd(1,citadd)),[],drm(1,:));
Screen('Flip',wd);
if doaudio;PsychPortAudio('Start', soundhandle(cppresadd(1,citadd)),1,0,1);end

WaitSecs(1.0);

% draw Pavlovian stimulus 2 
Screen('DrawTexture',wd,shape(cppresadd(2,citadd)),[],drm(3,:));
Screen('Flip',wd);
if doaudio;PsychPortAudio('Start', soundhandle(cppresadd(2,citadd)),1,0,1);end

WaitSecs(1.0);

DrawFormattedText(wd,' ','center','center',bgcol(1)*ones(1,3),60,[],[],1.3);
Screen('Flip',wd);
WaitSecs(0.4);

%.............. GET INPUT
Screen('DrawTexture',wd,shape(cppresadd(1,citadd)),[],drm(1,:));
Screen('DrawTexture',wd,shape(cppresadd(2,citadd)),[],drm(3,:));
%DrawFormattedText(wd,'Linke Taste:\n Erstes Bild',drmd(1,1),'center',txtcolor,60,[],[],1.3);
%DrawFormattedText(wd,'Rechte Taste:\n Zweites Bild',drmd(3,1),'center',txtcolor,60,[],[],1.3);
T.compadd_onset(citadd) = Screen('Flip',wd);

redraw = 0;
if usekbqueue	           % KbQueue is more accurate for USB devices
	KbQueueFlush; KbQueueStart; 
end
while 1 %(GetSecs - T.compadd_onset(citadd))<Z.choicetime_query

	if usekbqueue	           % KbQueue is more accurate for USB devices
		[foo,keyCode] = KbQueueCheck; 
		t = keyCode(keyCode~=0); % get actual time
	else	                    % KbCheck is standard 
		[foo,t,keyCode] = KbCheck; 
	end
	key = KbName(keyCode);

	% deal with number keys also returning special symbols
	if iscell(key); key=key{1};end
	if ~isempty(key) & (key(1) >= '0' && key(1) <= '9'); key = key(1); end

	if     strcmpi(key,leftkey) ; chqa(citadd) = 1; redraw = 1; 
	elseif strcmpi(key,rightkey); chqa(citadd) = 2; redraw = 1; 
	elseif strcmpi(key,abortkey); aborted=1; error('Aborted...');
	end

    if (GetSecs - T.compadd_onset(citadd))>Z.choicetime_query
        DrawFormattedText(wd,'Bitte schneller antworten!','center',ypost,red,60,[],[],1.3);
        Screen('DrawTexture',wd,shape(cppresadd(1,citadd)),[],drm(1,:));
        Screen('DrawTexture',wd,shape(cppresadd(2,citadd)),[],drm(3,:));
        Screen('Flip',wd);
    end
    
	if redraw; 
		T.compadd_resp(citadd)=t; 
		presstimesqa(citadd) = t-T.compadd_onset(citadd);

		% draw choice options 
		if chqa(citadd)==1
            Screen('DrawTexture',wd,shape(cppresadd(1,citadd)),[],drm(1,:));
            Screen('FrameRect', wd, green , drm(1,:) , 3);
        else
            Screen('DrawTexture',wd,shape(cppresadd(2,citadd)),[],drm(3,:));
				Screen('FrameRect', wd, green , drm(3,:) , 3);
		end
		Screen('Flip',wd);

		WaitSecs(0.7);
		checkabort;

		break; 
	end
end

Screen('Flip',wd);

WaitSecs(.5);

% Correct? 
if ~isnan(chqa(citadd));
	if     cppresadd(chqa(citadd),citadd)<=cppresadd(3-chqa(citadd),citadd); crma(citadd) = 1;
	elseif cppresadd(chqa(citadd),citadd)> cppresadd(3-chqa(citadd),citadd); crma(citadd) = 0;
	end
else 
	crma(citadd)=NaN;
end

checkabort; 		% Allow for abortion of experiment

if dosave; 
	eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat citadd chqa presstimesqa crma T -append']);
end

fprintf('Extra query trial %i\r',citadd);
