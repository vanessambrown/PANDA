
% draw the mushroom in the given position given by lrt
Screen('DrawTexture',wd,msh(Nmsh+1),[],tdrm(1,:));

% draw box
Screen('DrawLines',wd,bluebox,3,blue);


% draw a blue / black dot
if ~strcmpi(respkey,'joystick')
    dotpos = [tdrmd(2,1); tdrmd(2,2)];
    Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
    Screen('gluDisk',wd,blue,dotpos(1),dotpos(2),dotsize);
    Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);
    Screen('Flip',wd,[],1);
    
    WaitSecs(1);
    checkabort;
    WaitSecs(3);
    
end

if strcmpi(respkey,'joystick')
    numpressneeded=length(joy_thresh_pull_instr);joystick_pos=0;joystick_thresh=0;
    
    buttons = [0 0 0 0];clicks = 0;
    while (clicks > -3) % wait nogodelay seconds
        if strcmpi(respkey,'mouse')
            while any(buttons) 	% if already pressing button, wait for release
                [x,y,buttons]=GetMouse;
            end
            while ~any(buttons)		% wait for start of click
                [x,y,buttons]=GetMouse;
            end
        elseif strcmpi(respkey,'joystick') %register joystick position
            
            [joy_pos, buttons] = mat_joy(joyid_ins);
            
            joystick_pos=[joystick_pos; joy_pos(2)];
            joystick_thresh=[joystick_thresh; joy_thresh_ind(find(joy_levels==...
                round(joystick_pos(end)*100)))];
            clicks=joystick_thresh(end);
            
            % rescale image
            %     if joystick_thresh(end-1)~=joystick_thresh(end)
            
            if joystick_thresh(end)==0 % original stimulus size
                Screen('DrawTexture',wd,msh(Nmsh+1),[],tdrm(1,:));
                Screen('DrawLines',wd,bluebox,3,blue);
            elseif joystick_thresh(end)~=0 ...
                    %&& joystick_pos(end)<=joy_fin_pos_push % change size of stimulus
                size_adapt=round(stim_change_appr(abs(joystick_thresh(end)))/2);
                
                new_size=[tdrm(1,1:2)-sign(joystick_thresh(end))*size_adapt ...
                    tdrm(1,3:4)+sign(joystick_thresh(end))*size_adapt];
                
                
                % adjust size of blue box around stimulus
                bluebox_new=bluebox;
                bluebox_new(1,bluebox_new(1,:)==min(bluebox_new(1,:)))=...
                    bluebox_new(1,bluebox_new(1,:)==min(bluebox_new(1,:)))-...
                    sign(joystick_thresh(end))*size_adapt;
                bluebox_new(2,bluebox(2,:)==min(bluebox(2,:)))=...
                    bluebox(2,bluebox(2,:)==min(bluebox(2,:)))-...
                    sign(joystick_thresh(end))*size_adapt;
                bluebox_new(1,bluebox(1,:)==max(bluebox(1,:)))=...
                    bluebox(1,bluebox(1,:)==max(bluebox(1,:)))+...
                    sign(joystick_thresh(end))*size_adapt;
                bluebox_new(2,bluebox(2,:)==max(bluebox(2,:)))=...
                    bluebox(2,bluebox(2,:)==max(bluebox(2,:)))+...
                    sign(joystick_thresh(end))*size_adapt;
                
                Screen('DrawTexture',wd,msh(Nmsh+1),[],new_size);
                Screen('DrawLines',wd,bluebox_new,3,blue);
            end
            DrawFormattedText(wd,tx{page},'center',ypos{page},txtcolor,60,[],[],1.3);

            Screen('Flip',wd);
            
            %      end
        end
        
        
        checkabort;
    end
end

if strcmpi(respkey,'joystick')
    if shrooms;
        DrawFormattedText(wd, ...
            ['You should have thrown away that shell by now. Click a button to continue.'],...
            'center','center',txtcolor,60,[],[],1.3);
        
        %['Diese Muschel hätten Sie jetzt weggeworfen. Klicken Sie eine Taste, um weiterzumachen.'],...
    else
        DrawFormattedText(wd, ...
            ['You should have thrown away that leaf by now. Click a button to continue.'],...
            'center','center',txtcolor,60,[],[],1.3);
        
        % ['Dieses Blatt hätten Sie jetzt weggeworfen. Klicken Sie eine Taste, um weiterzumachen.'],...
    end
    
end

getleftrightarrow;

