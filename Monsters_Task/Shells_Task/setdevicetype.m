% Eyetracker parameters
% stim_trig				= [];	% DO NOT RESET in second part **
if strcmpi(exploc,'d'); EyeLinkEDFFileList		= {};end

%----------------------------------------------------------------------------
%        Keyboard / input device settings
%----------------------------------------------------------------------------

if     exppart==1; devicetype = devicetype_part1;
elseif exppart==2; devicetype = devicetype_part2;
elseif exppart==3; devicetype = devicetype_part3;
elseif exppart==4; devicetype = devicetype_part4;
end

if     strcmpi(devicetype,'keyboard'); % if using keyboard
    respkey  = 'mouse';
    rightkey = 'RightArrow';
    leftkey  = 'LeftArrow';
    usekbqueue = 0;
elseif strcmpi(devicetype,'lumitouch');	 % for lumitouch device
    respkey  = '7';	% index finger of DOMINANT RIGHT hand
    rightkey = '7';	% index finger of dominant RIGHT hand
    leftkey  = '4';	% third finger of left hand
    usekbqueue = 1;
elseif strcmpi(devicetype,'nnl'); %	 for NNL device
    respkey  = 'j';	% index finger of DOMINANT RIGHT hand
    rightkey = 'j';	% index finger of dominant right hand
    leftkey  = 'b';	% third finger of non-dominant left hand
    usekbqueue = 1;
elseif strcmpi(devicetype,'currentdesigns')
    % two response devices with four buttons each, button numbers for
    % the right hand devices from 1 at the top to four and for
    % the left hand device from 6 at the bottom to 9 at the top
    % number 5 is the fMRI trigger
    respkey  = '3';	% index finger of DOMINANT right hand
    rightkey = '3';	% index finger of dominant right hand
    leftkey  = '1';	% third finger of non-dominant left hand
    usekbqueue = 1;
elseif strcmpi(devicetype,'currentdesignsoffMRT')
    % two response devices with four buttons each, button numbers for
    % the right hand devices from 1 at the top to four and for
    % the left hand device from 6 at the bottom to 9 at the top
    % number 5 is the fMRI trigger
    respkey  = '3';	% index finger of DOMINANT right hand
    rightkey = '3';	% index finger of dominant right hand
    leftkey  = '2';	% third finger of non-dominant left hand
    usekbqueue = 1;
elseif strcmpi(devicetype,'joystick')
    respkey  = 'joystick';
    rightkey = 'RightArrow';
    leftkey  = 'LeftArrow';
    usekbqueue = 0;
    % define the thresholds (maximum = 1) for which the stimulus
    % presentation will be modified
    joy_thresh=[.22 .47 .69]; % literature based for range -1:+1 Rinck et al. 20...
    joy_levels=[-100:100]';
    joy_thresh_ind=zeros(size(joy_levels));
    % joy_fin_pos = 0.99;
    joy_fin_pos_push = -0.99; % dummy
    joy_fin_pos_pull = 0.99; % dummy
    
    
    for jt=1:length(joy_thresh)
        joy_thresh_ind(abs(joy_levels)>abs(joy_thresh(jt)*100))=jt;
    end
    
    joy_thresh_ind=joy_thresh_ind.*sign(joy_levels);
    
elseif strcmpi(devicetype,'cur_joystick')
    respkey  = 'joystick';
    rightkey = 'RightArrow';
    leftkey  = 'LeftArrow';
    usekbqueue = 0;
    % this will be done now in getjoystick_pull.m and getjoystick_push.m
    %     joy_thresh=[.22 .47 .69]; % literature based for range -1:+1 Rinck et al. 20...
    %     joy_levels=[-100:100]';
    %     joy_levels=[-100:100]';
    %     joy_thresh_ind=zeros(size(joy_levels));
    %     joy_fin_pos = 0.99;
    %
    %
    %     for jt=1:length(joy_thresh)
    %         joy_thresh_ind(abs(joy_levels)>abs(joy_thresh(jt)*100))=jt;
    %     end
    %
    %     joy_thresh_ind=joy_thresh_ind.*sign(joy_levels);
    % joy_fin_pos = 100; %dummy
else
    error('Unknown device type')
end

if strcmpi(dominanthand,'left');
    error('Only include right hand dominant subjects.');
end

% start queue for KbQueueCheck
if usekbqueue;
    KbQueueCreate;
    KbQueueStart;
end

