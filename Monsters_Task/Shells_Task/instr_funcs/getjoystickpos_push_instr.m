Screen('DrawTexture',wd,arrow,[],arrowsquare);
Screen('Flip',wd);

joy_push = 0;
 while     joy_push > -0.35

    while 1
        [foo,keyCode]=KbStrokeWait;
        key = KbName(keyCode);
        
        if     strcmpi(key,'s'); break; end
        
    end
    
    [joy_pos, buttons] = mat_joy(joyid_ins);
    
    
    while 1
        [foo,keyCode]=KbStrokeWait;
        key = KbName(keyCode);
        
        if     strcmpi(key,'s'); break; end
        
    end
    joy_push = joy_pos(2);
    
    joy_thresh_push_instr=[joy_push*.22 joy_push*.47 joy_push*.69]; % literature based for range Rinck et al. 20...
    joy_levels=[-100:100]';
    joy_levels=[-100:100]';
    joy_thresh_ind=zeros(size(joy_levels));
    joy_fin_pos_push_instr = joy_push-joy_push*0.08;
    
    
    for jt=1:length(joy_thresh_push_instr)
        joy_thresh_ind(abs(joy_levels)>abs(joy_thresh_push_instr(jt)*100))=jt;
    end
    
    joy_thresh_ind=joy_thresh_ind.*sign(joy_levels);
    

    
    if joy_push < -0.35; break; end
 end


clear  key joy_pos
getleftrightarrow;