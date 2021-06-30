% logged timing for each compare trial cit:
% T_comp_onset(cit)         stimulus onset
% T_comp_resp(cit)          button press
% T_comp_choice(cit)        show choice selection
% T_comp_offset(cit)        stimulus offset

% count the number of queries 
cit = cit + 1;

% draw Pavlovian stimuli
Screen('DrawTexture',wd,shape(cppres(1,cit)),[],drm(1,:));
Screen('DrawTexture',wd,shape(cppres(2,cit)),[],drm(3,:));

T.comp_onset(cit) = Screen('Flip',wd);

%.............. GET INPUT
redraw = 0;
while (GetSecs - T.comp_onset(cit))<Z.choicetime_query
	[t,keyCode]=KbStrokeWait;
	key = KbName(keyCode);
	% deal with number keys also returning special symbols
	if iscell(key); key=key{1};end
	if ~isempty(key) & (key(1) >= '0' && key(1) <= '9'); key = key(1); end
	
	if     strcmpi(key,leftkey);  chq(cit) = 1; redraw = 1;
	elseif strcmpi(key,rightkey); chq(cit) = 2; redraw = 1;
	elseif strcmpi(key,abortkey); aborted=1; error('Aborted...');
	end
     
	if redraw; 
		T.comp_resp(cit)=t; 
		presstimesq(cit) = t-T.comp_onset(cit);

		% draw stimuli again 
		Screen('DrawTexture',wd,shape(cppres(1,cit)),[],drm(1,:));
		Screen('DrawTexture',wd,shape(cppres(2,cit)),[],drm(3,:));

		% draw box around chosen stimulus 
		if chq(cit)==1; tmp = [drm(1,[1 3 3 1]); drm(1,[2 2 4 4])];	 
		else          ; tmp = [drm(3,[1 3 3 1]); drm(3,[2 2 4 4])];	 
		end
		redbox = [tmp(:,1:2) tmp(:,2:3) tmp(:,3:4) tmp(:,[4 1])];
		Screen('DrawLines',wd,redbox,3,red);
		T.comp_choice(cit) = Screen('Flip',wd);

		WaitSecs(1);
		checkabort;

		break; 
	end
end

T.comp_offset(cit) = Screen('Flip',wd);

WaitSecs(.5);

% Correct? 
if ~isnan(chq(cit));
	if     cppres(chq(cit),cit)<=cppres(3-chq(cit),cit); crm(cit) = 1;
	elseif cppres(chq(cit),cit)> cppres(3-chq(cit),cit); crm(cit) = 0;
	end
else 
	crm(cit)=NaN;
end

checkabort;			% Allow for abortion of experiment

if dosave; 
	eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat cit chq presstimesq crm stim_trig T  -append']);
end

fprintf('Query trial %i\r',cit);
