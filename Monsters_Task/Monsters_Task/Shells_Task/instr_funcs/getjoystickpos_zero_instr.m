Screen('DrawTexture',wd,arrow,[],arrowsquare);
Screen('Flip',wd);

joy_zero = -1;
while     joy_zero < -0.1 || joy_zero > 0.1
while 1
    [foo,keyCode]=KbStrokeWait;
	key = KbName(keyCode);

	if     strcmpi(key,'s'); break; end
    
end

[joy_pos, buttons] = mat_joy(joyid_ins);


while 1
    [foo,keyCode]=KbStrokeWait;
	key = KbName(keyCode);

	if     strcmpi(key,'s');  break; end
    
end

joy_zero_instr = joy_pos(2);
    if joy_zero_instr > -0.1 && joy_zero_instr < 0.1; break; end
    
 end


clear  key joy_pos
getleftrightarrow;