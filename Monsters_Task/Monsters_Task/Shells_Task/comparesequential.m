% count the number of queries 
cit = cit + 1;

% draw Pavlovian stimulus 1 
Screen('DrawTexture',wd,shape(cppres(1,cit)),[],drm(1,:));
Screen('Flip',wd);
sendparport(sparport.parportcodes.p4stimAonset); % send parport code marking onset of Stim A
if doaudio;PsychPortAudio('Start', soundhandle(cppres(1,cit)),1,0,1);end

WaitSecs(1.0);

% draw Pavlovian stimulus 2 
Screen('DrawTexture',wd,shape(cppres(2,cit)),[],drm(3,:));
Screen('Flip',wd);
sendparport(sparport.parportcodes.p4stimBonset); % send parport code marking onset of Stim B
if doaudio;PsychPortAudio('Start', soundhandle(cppres(2,cit)),1,0,1);end

WaitSecs(1.0);

DrawFormattedText(wd,' ','center','center',bgcol(1)*ones(1,3),60,[],[],1.3);
Screen('Flip',wd);
WaitSecs(0.4);

%.............. GET INPUT
Screen('DrawTexture',wd,shape(cppres(1,cit)),[],drm(1,:));
Screen('DrawTexture',wd,shape(cppres(2,cit)),[],drm(3,:));
T.comp_onset(cit) = Screen('Flip',wd);
sendparport(sparport.parportcodes.p4dualonset); % send parport code marking onset of both stim together

redraw = 0;
if usekbqueue	           % KbQueue is more accurate for USB devices
	KbQueueFlush; KbQueueStart; 
end
while 1 %(GetSecs - T.comp_onset(cit))<Z.choicetime_query

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
	
	if     strcmpi(key,leftkey);  chq(cit) = 1; redraw = 1;
	elseif strcmpi(key,rightkey); chq(cit) = 2; redraw = 1;
	elseif strcmpi(key,abortkey); aborted=1; error('Aborted...');
   end
    
    if (GetSecs - T.comp_onset(cit))>Z.choicetime_query
        DrawFormattedText(wd,'Please make your selection!','center',ypost,red,60,[],[],1.3);
        Screen('DrawTexture',wd,shape(cppres(1,cit)),[],drm(1,:));
        Screen('DrawTexture',wd,shape(cppres(2,cit)),[],drm(3,:));
        Screen('Flip',wd);
    end
    
	if redraw; 
		T.comp_resp(cit)=t; 
		presstimesq(cit) = t-T.comp_onset(cit);

		% draw choice options 
		if chq(cit)==1
            Screen('DrawTexture',wd,shape(cppres(1,cit)),[],drm(1,:));
            Screen('FrameRect', wd, green , drm(1,:) , 3);
        else
            Screen('DrawTexture',wd,shape(cppres(2,cit)),[],drm(3,:));
            Screen('FrameRect', wd, green , drm(3,:) , 3);
		end
		Screen('Flip',wd);

		WaitSecs(0.7);
		checkabort;

		break; 
	end
end

Screen('Flip',wd);
sendparport(sparport.parportcodes.p4choice); %parport code marking choice of favored CS

WaitSecs(.5);

% cit: trial number
% chq: did you choose the left or right button (1/2)
% cppres: which of the 2 stimuli was presented 
% crm: did they choose the correct stimulus?

%%%%%%%%%%%%%%%%%%%%%%new
if ~isnan(chq(cit));
	if     cppres(chq(cit),cit)<=cppres(3-chq(cit),cit); crm(cit) = 1;
	elseif cppres(chq(cit),cit)> cppres(3-chq(cit),cit); crm(cit) = 0;
	end
else
	crm(cit)=NaN;
end


%%%%%%%%%%%%%%%%%%%%%%%original
% Correct?
% if ~isnan(chq(cit)) & cppres(1,cit) <=3 & cppres(2,cit) <=3;
% 	if     cppres(chq(cit),cit)<=cppres(3-chq(cit),cit); crm(cit) = 1;
% 	elseif cppres(chq(cit),cit)> cppres(3-chq(cit),cit); crm(cit) = 0;
% 	end
% else
%crm(cit)=NaN;
% end

checkabort;			% Allow for abortion of experiment

if dosave;
	eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat cit chq presstimesq crm T -append']);
end

fprintf('Query trial %i\r',cit);
