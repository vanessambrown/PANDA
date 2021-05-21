
Screen('DrawTexture',wd,arrow,[],arrowsquare);
if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end % draw frame
Screen('Flip',wd);

if usekbqueue	           % KbQueue is more accurate for USB devices
    KbQueueFlush; KbQueueStart;
end

while 1
    if usekbqueue	           % KbQueue is more accurate for USB devices
        [foo,keyCode] = KbQueueCheck;
        t = keyCode(keyCode~=0); % get actual time
    else	                    % KbCheck is standard
        %[foo,t,keyCode] = KbCheck;
        [foo,keyCode] = KbStrokeWait;
    end
    key = KbName(keyCode);
    
    % keyboard layout issues (like %5 etc being sent)
    if iscell(key); key=key{1};end
    if ~isempty(key) & (key(1) >= '0' && key(1) <= '9'); key = key(1); end
    
    if     strcmpi(key,rightkey);         page=page+1; break;
    elseif strcmpi(key,leftkey ) & page>1;page=page-1; break;
    elseif strcmpi(key,abortkey);
        aborted=1;
        Screen('Fillrect',wd,ones(1,3)*80);
        text='Aborting experiment';
        col=[200 30 0];
        Screen('TextSize',wd,60);
        DrawFormattedText(wd,text,'center','center',col,60);
        error('Pressed abort key --- aborting experiment')
    end
end
