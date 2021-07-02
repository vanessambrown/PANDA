ShowCursor('Hand');

% define position of stimuli
stimh=200; stimw=stimh*(4/3);

% y coordinates of stimulus edges
stim_bounds_h=linspace(ypost,wdh,4);
stimhdist=stim_bounds_h(2)-stim_bounds_h(1);

stim_y=[cellfun(@(x) x+(stimhdist/2) - (stimh/2), num2cell(stim_bounds_h));...
    cellfun(@(x) x+(stimhdist/2) + (stimh/2), num2cell(stim_bounds_h))];
stim_y(:,end)=[];
stim_y=repmat(stim_y,1,3);
stim_y=stim_y(:,[1 4 7 2 5 8 3 6 9]);

% x coordinates of stimulus edges
stim_bounds_w=linspace(wdw*0.15,wdw-wdw*0.15,4);
stimwdist=stim_bounds_w(2)-stim_bounds_w(1);

stim_x=[cellfun(@(x) x+(stimwdist/2) - (stimw/2), num2cell(stim_bounds_w));...
    cellfun(@(x) x+(stimwdist/2) + (stimw/2), num2cell(stim_bounds_w))];
stim_x(:,end)=[];
stim_x=repmat(stim_x,1,3);

% combine stimulus coordinates
stimselect_coords=[stim_x(1,:); stim_y(1,:); stim_x(2,:); stim_y(2,:)];

% randomise presentation order of stimuli
if strcmp(selectiontask{page},'alc')
    rand_ind=randperm(length(alcstim));
elseif strcmp(selectiontask{page},'nic')
    rand_ind=randperm(length(nicstim));
end
    

% draw stimuli
if strcmp(selectiontask{page},'alc')
    Screen('DrawTextures',wd,alcstim(rand_ind),[],stimselect_coords);
elseif strcmp(selectiontask{page},'nic')
    Screen('DrawTextures',wd,nicstim(rand_ind),[],stimselect_coords);
end
Screen('Flip',wd);

valid_selection=0;

while ~valid_selection

    % wait for mouse button response
    [~,mouse_x,mouse_y,~] = GetClicks;
    
    % check if response is valid
    valid_mouse=cellfun(@(x) mouse_x>x(1) & mouse_x<x(3) & mouse_y>x(2) & mouse_y<x(4),...
        num2cell(stimselect_coords,1));
    
    if any(valid_mouse)
        valid_selection=1;
    end
end

% load selected stimulus for the main experiment
if strcmp(selectiontask{page},'alc')
    selected_stim_num(1)=rand_ind(valid_mouse==1);
elseif strcmp(selectiontask{page},'nic')
    selected_stim_num(2)=rand_ind(valid_mouse==1);
%     outcomep(5)=Screen('MakeTexture',wd,nicstim(rand_ind(valid_mouse==1)));
end

% draw frame around selected stimulus
if strcmp(selectiontask{page},'alc')
    Screen('DrawTextures',wd,alcstim(rand_ind),[],stimselect_coords);
elseif strcmp(selectiontask{page},'nic')
    Screen('DrawTextures',wd,nicstim(rand_ind),[],stimselect_coords);
end
Screen('FrameRect',wd,red,stimselect_coords(:,valid_mouse==1),5);

getleftrightarrow;

