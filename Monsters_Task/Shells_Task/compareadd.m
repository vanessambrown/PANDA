





% count the number of queries 
citadd = citadd + 1;

% draw Pavlovian stimuli
Screen('DrawTexture',wd,shape(cppresadd(1,citadd)),[],drm(1,:));
Screen('DrawTexture',wd,shape(cppresadd(2,citadd)),[],drm(3,:));

t0 = Screen('Flip',wd);

%.............. GET INPUT
redraw = 0;
while (GetSecs - t0)<Z.choicetime_query
	[t,keyCode]=KbStrokeWait;
	key = KbName(keyCode);
	% deal with number keys also returning special symbols
	if iscell(key); key=key{1};end
	if ~isempty(key) & (key(1) >= '0' && key(1) <= '9'); key = key(1); end

	if     strcmpi(key,leftkey) ; chqa(citadd) = 1; redraw = 1; 
	elseif strcmpi(key,rightkey); chqa(citadd) = 2; redraw = 1; 
	elseif strcmpi(key,abortkey); aborted=1; error('Aborted...');
	end


	if redraw; 
		presstimesqa(citadd) = t-t0;

		% draw stimuli again 
		Screen('DrawTexture',wd,shape(cppresadd(1,citadd)),[],drm(1,:));
		Screen('DrawTexture',wd,shape(cppresadd(2,citadd)),[],drm(3,:));

		% draw box around chosen stimulus 
		if chqa(citadd)==1; tmp = [drm(1,[1 3 3 1]); drm(1,[2 2 4 4])];	 
		else              ; tmp = [drm(3,[1 3 3 1]); drm(3,[2 2 4 4])];	 
		end
		redbox = [tmp(:,1:2) tmp(:,2:3) tmp(:,3:4) tmp(:,[4 1])];
		Screen('DrawLines',wd,redbox,3,red);
		Screen('Flip',wd);

		WaitSecs(1);
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
	eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat citadd chqa presstimesqa crma T stim_trig -append']);
end

fprintf('Extra query trial %i\r',citadd);
