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
elseif strcmpi(devicetype,'MRRC')
    % all pts will use right hand response glove, with right thumb 0, right
    % index = 1, right middle = 2, etc. 
    % = is the fMRI trigger
    respkey  = '2';	% index finger of right hand
    rightkey = '3';	% middle finger of right hand
    leftkey  = '2';	% index finger of right hand
    usekbqueue = 0;
else
    error('Unknown device type')
end

% start queue for KbQueueCheck
if usekbqueue;
    KbQueueCreate;
    KbQueueStart;
end

