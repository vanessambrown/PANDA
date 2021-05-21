fprintf('............ Displaying instructions ');
i=0; clear tx ypos func;
func{1}=[];

if ~exist('nt'); % if this is the first session
    
    
    if strcmp(devicetype,'cur_joystick')
        i=i+1;
        ypos{i}=yposm;
        tx{i} = ['Experimenter: Please keep the joystick pushed as far away from you as possible and then press "Start" and "Stop".'];
        func{i}='getjoystickpos_push_instr';
        
        
        i=i+1;
        ypos{i}=yposm;
        tx{i} = ['Experimenter: Please keep the joystick pulled towards you as much as possible and then press "Start" and "Stop".'];
        func{i}='getjoystickpos_pull_instr';
        
        i=i+1;
        ypos{i}=yposm;
        tx{i} = ['Experimenter: Please leave the joystick in the middle position and then press "Start" and "Stop".'];
        func{i}='getjoystickpos_zero_instr';
        
    end
    
    
    i=i+1;
    ypos{i}=yposm;
     tx{i}=['Welcome to the monsters task! Please use the right arrow to advance, and the left arrow to go back.'];
end

if shrooms; obj='shells'; else obj='monsters';end

i=i+1;
ypos{i}=yposm;
 if shrooms
     tx{i}=['Imagine that you are in the process of collecting these ' obj '.'];
    else
        tx{i}=['During this task, we want you to imagine that you are on a long journey when you come across some ' obj '.'];
 end

i=i+1;
ypos{i}=yposm;
 if shrooms
    tx{i}=['There are both good and bad ' obj '.'];
    else
        tx{i}=['Your goal is to avoid getting caught by these monsters.']; 
 end

i=i+1;
ypos{i}=yposm;
if strcmpi(respkey,'joystick')
    if shrooms; tx{i}='You can decide whether to collect a shell or throw it away.';
    else        tx{i}='You can decide whether to collect a leaf or throw it away.';
    end
else
    if shrooms; tx{i}='You can decide whether to collect a shell or leave it.';    
    else        tx{i}='You can choose whether to hide or run away from each monster you encounter.';        
    end
end

i=i+1;
ypos{i}=yposm;
if shrooms; tx{i}='Each decision results in either a 20 cent profit or a 20 cent loss.';
else        tx{i}='If the monster catches you, you will hear an irritating sound and see a disturbing picture. But, if you escape, nothing will happen, and you will move on to facing the next monster.';
end

i=i+1;
ypos{i}=yposm;
if shrooms; tx{i}=['Good ' obj ' usually result in a profit if they are collected.'];
else        tx{i}=['For some monsters, you will be more likely to escape if you choose to hide.'];
end

i=i+1;
ypos{i}=yposm;
if shrooms; tx{i}=['Bad ' obj ' usually lead to a loss of money if they are collected.'];
else        tx{i}=['But for other ' obj ', it is better to run away.'];
end
    
i=i+1;
ypos{i}=yposm;
if strcmpi(respkey,'joystick')
    if shrooms
        tx{i}='Every now and then, you might pick up a good shell or throw away a bad one and still lose money. Try not to be distracted by it when this happens.';
    else
        tx{i}='Every now and then, you might pick up a good leaf or throw away a bad one and still lose money. Try not to be distracted by it when this happens.';
    end
else
    if shrooms
        tx{i}='Every now and then, you might pick up a good shell or leave a bad one and still lose money. Try not to be distracted by it when this happens.';
    else
        tx{i}='Every now and then, you might make the right decision but still get caught. Try not to be distracted by it when this happens.';
    end
end

%add statement about tracking performance    
i=i+1;
ypos{i}=yposm;
if shrooms
    tx{i}='The computer will track your performance by monitoring how many times you get caught or escape.';
else
    tx{i}='The computer will track your performance by monitoring how many times you get caught or escape.';
end

i=i+1;
ypos{i}=yposm;
if shrooms; tx{i}='You can tell that a shell is good by noticing that you usually win money when you collect it.';
else;       tx{i}='Just try to pick the action that you think is most likely to help you escape. Keep choosing that option if you see the same monster in the future.';
end

i=i+1;
ypos{i}=yposm;
if strcmpi(respkey,'joystick')
    if shrooms
        tx{i}='To collect a shell, use the joystick and pull it towards you.';
    else tx{i}='To collect a leaf, use the joystick and pull it towards you.';
    end
else
    ypos{i}=ypost;
    if shrooms; tx{i}='To collect a shell, the blue point has to be moved onto the shell.';
    else;       tx{i}='To run away from a monster, the blue point has to be moved onto the gray safety zone.';
    end
end
func{i}='withdrawgo';


i=i+1;
ypos{i}=ypost;
if strcmpi(respkey,'joystick')
    if shrooms
        tx{i}='This will make the shell bigger until it eventually disappears.';
    else tx{i}='This will make the leaf bigger until it eventually disappears.';
    end
else
    if     strcmpi(devicetype,'keyboard');	taste = 'the mouse button'; 
    elseif strcmpi(dominanthand,'right');	taste = 'the button under your right index finger'; 
    elseif strcmpi(dominanthand,'left');	taste = 'the button under your left index finger'; 
    end
     if shrooms; tx{i}=['You can do this by repeatedly pressing ' taste '. It does not matter where you click. Each press of the button moves the point a little closer to the shell. Try it out.'];
     else        tx{i}=['You can do this by repeatedly pressing ' taste '. It does not matter where you click. Each press of the button moves the point a little closer to the gray safety zone. Try it out.'];
    end
end
func{i}='withdrawgoactive';

if ~strcmpi(respkey,'joystick')
    i=i+1;
    ypos{i}=yposm;
    if shrooms; tx{i}='You collected the shell.';
    else        tx{i}='You ran away.';
    end
end

%% This part is not applicable for joystick
i=i+1;
ypos{i}=yposm;
if ~strcmpi(respkey,'joystick')
    if shrooms; tx{i}='The more you press, the more likely you are to collect the shell.';    
    else        tx{i}='The more you press, the more likely you are to make it to the gray safety zone.';
    end
    
    i=i+1;
    ypos{i}=yposm;
    if shrooms; tx{i}='BUT: the number of presses you need to collect the shell is not always the same.';      
    else        tx{i}='BUT: the number of presses you need to make it to safety is not always the same.';
    end
    
    i=i+1;
    ypos{i}=ypost;
    tx{i}='Try again.';
    func{i}='withdrawgoactivefast';
    
    i=i+1;
    ypos{i}=yposm;
    if shrooms; tx{i}='To collect that shell, you needed to click more often than you did for the previous one.';
    else        tx{i}='To make it to safety, you needed to click more often than you did for the previous one.';
    end
    
    i=i+1;
    ypos{i}=yposm;
    tx{i}='During the task, we will only show you where the point starts and ends, but not where it is in between.';
    
    
    i=i+1;
    ypos{i}=ypost;
    tx{i}='Now try again. This time it will be just like in the real task.';
    func{i}='withdrawgoexp';
    
elseif strcmpi(respkey,'joystick')
    tx{i}='You have to pull the shell towards you with the joystick until it disappears in order to collect it.';
    
    i=i+1;
    ypos{i}=yposm;
    tx{i}='Caution! Let the joystick return to the center position after each attempt.';
end

%% leave condition is applicable for joystick; people need to be instructed about pushing to leave bad shells

i=i+1;
ypos{i}=yposm;
if strcmpi(respkey,'joystick')
    tx{i}=['Sometimes you will see bad ' obj '. The only way to earn money from bad ' obj ' is to throw them away.'];
    i=i+1;
    ypos{i}=yposm;
    if shrooms
        tx{i}='To throw away a shell, push the joystick away from you.';
    else tx{i}='To throw away a shell, push the joystick away from you.';
    end
    
    i=i+1;
    ypos{i}=ypost;
    if shrooms
        tx{i}='This makes the shell smaller and smaller until it eventually disappears. Give it a try.';
    else tx{i}='This makes the leaf smaller and smaller until it eventually disappears. Give it a try.';
    end
    func{i}='withdrawnogo';
    
    i=i+1;
    ypos{i}=yposm;
    if shrooms; tx{i}='You should have thrown that shell away by now. You have to push the shell away from you with the joystick until it disappears in order to throw it away.';
    else        tx{i}='You should have thrown that leaf away by now. You have to push the leaf away from you with the joystick until it disappears in order to throw it away.';
    end
    
else
    if shrooms;    tx{i}=['Sometimes you will see bad ' obj '. The only way to earn money from bad ' obj ' is to do nothing and leave them where they are.'];
    else           tx{i}=['For some ' obj ', you will be more likely to escape if you hide. To hide, simply do nothing at all.'];
    end
end

i=i+1;
ypos{i}=ypost;
if ~strcmpi(respkey,'joystick')
if shrooms;    tx{i}=['To leave ' obj 'behind, do nothing, just wait.'];
else           tx{i}=['To hide from ' obj ', do nothing, just wait.'];
end
    func{i}='withdrawnogo';
end

if strcmpi(respkey,'joystick')
    if shrooms; tx{i}=['In the experiment you have ' num2str(round(nogodelay_train*10)/10) ' seconds to collect or throw away a shell. Whenever you do not move the joystick or move it completely, you lose 20 cents.'];
    else        tx{i}=['In the experiment you have ' num2str(round(nogodelay_train*10)/10) ' seconds to collect or throw away a leaf. Whenever you do not move the joystick or move it completely, you lose 20 cents.'];
    end
else
    if shrooms; tx{i}=['During the experiment, you will have ' num2str(round(nogodelay_train*10)/10) ' seconds to collect or leave a shell. You can press as often as you want. If you do not press or do not press often enough, the computer will assume you do not want the shell.'];
    else
        tx{i}=['During the task, you will have ' num2str(round(nogodelay_train*10)/10) ' seconds to either hide or run away. You can press as often as you want. If you do not press or do not press often enough, the computer will assume you want to hide.'];
    end
end

%....................... Instrumental test run
i=i+1;
ypos{i}=ypost;
tx{i}='Ok, let''s practice a bit first.';
func{i}='withdrawtestrun';

i=i+1;
ypos{i}=yposm;
tx{i}= 'The real task starts now. Please briefly tell the research assistant what you need to do in this task.';
func{i}='checkunderstood';

instr_display;

for k=1:5
    text={['The next part of the experiment starts in ' num2str(6-k) ' seconds.']};
    displaytext(text,wd,wdw,wdh,txtcolor,0,0);
    WaitSecs(1);
end

checkabort;
fprintf('.........done\n');
