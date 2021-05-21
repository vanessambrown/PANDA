
Screen('DrawTexture',wd,arrow,[],arrowsquare);
if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end % draw frame
Screen('Flip',wd);

while 1
	[foo,keyCode]=KbStrokeWait;
	key = KbName(keyCode);

	if     strcmpi(key,'y');                 page=page+1; break; 
	elseif strcmpi(key,'LeftArrow') & page>1;page=page-1; break;
	elseif strcmpi(key,'RightArrow');                 page=page; break; %changed r to RightArrow and page=page; to page = page+1; 

	elseif setsoundlevel & strcmpi(key,'u'); % increase level 
		page=page; 
		levelfrac = levelfrac*1.5; 
		if     tmp==5; PsychPortAudio('FillBuffer', soundhandle(tmp), levelfrac*rawsound(tmp,:));
		elseif tmp==6; PsychPortAudio('FillBuffer', soundhandle(tmp), levelfrac*sounda);
		elseif tmp==8; PsychPortAudio('FillBuffer', soundhandle(tmp), levelfrac*soundb);
		end

		break;
	elseif setsoundlevel & strcmpi(key,'d'); % increase level 
		page=page; 
		levelfrac = levelfrac/1.5; 
		if     tmp==5; PsychPortAudio('FillBuffer', soundhandle(tmp), levelfrac*rawsound(tmp,:));
		elseif tmp==6; PsychPortAudio('FillBuffer', soundhandle(tmp), levelfrac*sounda);
		elseif tmp==8; PsychPortAudio('FillBuffer', soundhandle(tmp), levelfrac*soundb);
		end
		break;

	elseif strcmpi(key,'ESCAPE'); 
		aborted=1; 
		Screen('Fillrect',wd,ones(1,3)*80);
		text='Aborting experiment';
		col=[200 30 0];
		Screen('TextSize',wd,60);
		DrawFormattedText(wd,text,'center','center',col,60);
		Screen('CloseAll');
		ListenChar(0);
		error('Pressed ESC --- aborting experiment')
	end
end

