
for k=1:5
	% re-draw text 
	DrawFormattedText(wd,tx{page},'center',ypos{page},txtcolor,60,[],[],1.3);
	% draw stimuli again 
	Screen('Drawtexture',wd,shapeinstr(1),[],dr(1,:));
	Screen('Drawtexture',wd,shapeinstr(2),[],dr(2,:));
	Screen('Flip',wd);

	redraw = 0;
	while 1
		[foo,keyCode]=KbStrokeWait;
		key = KbName(keyCode);
		if     strcmpi(key,leftkey);  side = 1; redraw = 1; 
		elseif strcmpi(key,rightkey); side = 2; redraw = 1; 
		elseif strcmpi(key,'ESCAPE'); break;
		end

		if redraw; 
			% re-draw text 
			DrawFormattedText(wd,tx{page},'center',ypos{page},txtcolor,60,[],[],1.3);

			% draw stimuli again 
			Screen('Drawtexture',wd,shapeinstr(1),[],dr(1,:));
			Screen('Drawtexture',wd,shapeinstr(2),[],dr(2,:));

			% draw box around chosen stimulus 
			tmp = [dr(side,[1 3 3 1]); dr(side,[2 2 4 4])];	 
			redbox = [tmp(:,1:2) tmp(:,2:3) tmp(:,3:4) tmp(:,[4 1])];
			Screen('DrawLines',wd,redbox,3,red);

			Screen('Flip',wd);
			WaitSecs(1);
			checkabort;
			break;
		end
	end
end

getleftrightarrow;
