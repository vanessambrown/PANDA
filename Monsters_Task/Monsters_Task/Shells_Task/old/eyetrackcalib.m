%% calibration of eyetracker prior to start of main experiment

if strcmpi(exploc,'b') & exppart==2 & scanning == 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Eyetracking calibration SMI for scanner
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % load the library, connect to Eye Tracker
    
    addpath('C:\SMI_EyeTracker\SMI\iView X SDK\bin')
    addpath('C:\SMI_EyeTracker\SMI\iView X SDK\include')
    addpath('C:\SMI_EyeTracker\SMI\iView X SDK\lib')
    
    warning('off', 'all');

    connected = 0;

    global pSampleData
     
    % load the iViewX API library
    loadlibrary('iViewXAPI.dll', 'iViewXAPI.h');

    [pSystemInfoData, pSampleData, pEventData, pAccuracyData, CalibrationData] = InitiViewXAPI();

    CalibrationData.method = int32(13);
    CalibrationData.visualization = int32(1);
    CalibrationData.displayDevice = int32(1);
    CalibrationData.speed = int32(0);
    CalibrationData.autoAccept = int32(1);
    CalibrationData.foregroundBrightness = int32(250);
    CalibrationData.backgroundBrightness = int32(130);
    CalibrationData.targetShape = int32(2);
    CalibrationData.targetSize = int32(20);
    CalibrationData.targetFilename = int8('');
    pCalibrationData = libpointer('CalibrationStruct', CalibrationData);

    disp('Define Logger')
    calllib('iViewXAPI', 'iV_SetLogger', int32(1), formatString(256, int8('iViewXSDK_Matlab_Slideshow_Demo.txt')))

    disp('Connect to iViewX')
    %ret = calllib('iViewXAPI', 'iV_Connect', formatString(16, int8('192.168.1.1')), int32(4444), formatString(16, int8('192.168.1.2')), int32(5555));
    
    % MRT 1:
    ret = calllib('iViewXAPI', 'iV_Connect', formatString(16, int8('169.254.28.27')), int32(4444), formatString(16, int8('169.254.28.28')), int32(5555));

    % MRT 2
%     ret = calllib('iViewXAPI', 'iV_Connect', formatString(16, int8('192.168.1.2')), int32(4444), formatString(16, int8('192.168.1.1')), int32(5555));
    switch ret
        case 1
            connected = 1;
        case 104
            msgbox('Could not establish connection. Check if Eye Tracker is running', 'Connection Error', 'modal');
        case 105
            msgbox('Could not establish connection. Check the communication Ports', 'Connection Error', 'modal');
        case 123
            msgbox('Could not establish connection. Another Process is blocking the communication Ports', 'Connection Error', 'modal');
        case 200
            msgbox('Could not establish connection. Check if Eye Tracker is installed and running', 'Connection Error', 'modal');
        otherwise
            msgbox('Could not establish connection', 'Connection Error', 'modal');
    end

    %%%%%%%%%%%%%%% Do the calibration
    if connected
        %Screen(wd+1, 'OpenWindow');
        disp('Get System Info Data')
        calllib('iViewXAPI', 'iV_GetSystemInfo', pSystemInfoData)
        get(pSystemInfoData, 'Value')
        
        disp('Calibrate iViewX')
        calllib('iViewXAPI', 'iV_SetupCalibration', pCalibrationData)
        
        % show fixation-cross
        %drawfixationcross(wd,2,fixationdotsize,0);
        %Screen('Flip',wd);
        
        %if doaudio;PsychPortAudio('Start', soundhandle(pavpres(np)),1,0,1);end

        %%% this is doing the calibration + validation
        key = 'c';
        while 1
            % ask should we do next?
            [foo, foo, keyCode ] = KbCheck;
            key = KbName(keyCode);
            while ~( any(strcmpi(key,'v')) || any(strcmpi(key,'c')) || any(strcmpi(key,'f')) )
                [foo, foo, keyCode ] = KbCheck;
                key = KbName(keyCode);
            end
            RET_SUCCESS=0;
            VAL_SUCCESS=0;
            if strcmpi(key,'c')
                %ShowHidePTBopenGLMex(0)
                RET_SUCCESS=calllib('iViewXAPI', 'iV_Calibrate');
                %ShowHidePTBopenGLMex(1)
                % show fixation-cross
                drawfixationcross(wd,2,fixationdotsize,0);
                Screen('Flip',wd);
            elseif strcmpi(key,'v')
                %ShowHidePTBopenGLMex(0)
                VAL_SUCCESS=calllib('iViewXAPI', 'iV_Validate');
                %ShowHidePTBopenGLMex(1)
                % show fixation-cross
                drawfixationcross(wd,2,fixationdotsize,0);
                Screen('Flip',wd);
            elseif strcmpi(key,'f')
                break;
            end
        end
        %Screen(wd+1, 'Close');
    end

    % clear recording buffer
    calllib('iViewXAPI', 'iV_ClearRecordingBuffer');
    
    % start recording
    calllib('iViewXAPI', 'iV_StartRecording');

    %% parameters for fixation control
    size_ROI_Px=100;            % size of ROI in Pixel
    size_ROI_Px = FixcheckBoxHalf_pix;
    ROI_centre_x=round(wdw/2);         % centre of ROI (see script 'fixatecentre')
    ROI_centre_y=.5*wdh;
    
    % check whether left or right eye is recorded
    leftRightEye = FlagEyeTracking; % manual setting
    try
        cnt_cs = 0;
        while 1
            calllib('iViewXAPI', 'iV_GetSample', pSampleData); % get eyetracker sample
            samp=get(pSampleData,'Value');
            if (samp.rightEye.gazeX~= -1) && (samp.rightEye.gazeY~= -1) && ...
                    (samp.leftEye.gazeX== -1 ) && (samp.leftEye.gazeY== -1 )
                leftRightEye = 'right'; % set which eye to use for fixation check
                setLeftRightEye = ['automatic_' num2str(cnt_cs)]; % just for domcumentation
                break;
            end
            if (samp.leftEye.gazeX~= -1 ) && (samp.leftEye.gazeY~= -1 ) && ...
                    (samp.rightEye.gazeX== -1) && (samp.rightEye.gazeY== -1)
                leftRightEye = 'left'; % set which eye to use for fixation check
                setLeftRightEye = ['automatic_' num2str(cnt_cs)]; % just for domcumentation
                break;
            end
            cnt_cs = cnt_cs + 1;
            if cnt_cs > 30; % break if the eye cannot be detected
                setLeftRightEye = 'manually'; % just for domcumentation
                break;
            end
            WaitSecs(0.05); % wait to ensure that next sample is obtained (not sure whether this is necessary)
        end
    catch me
        setLeftRightEye = 'automtic_broken'; % just for domcumentation
    end
         
elseif strcmpi(exploc,'b')
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Eyetracking calibration outside scanner in Berlin
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% load eyetracker parameters
	eyetrackparams;
    
    global pSampleData % pSampleData has to be available in the function UpDateStimulusTrigger
    
    %% calibration of eyetracker prior to start of main experiment

    % load eyetracker parameters
    eyetrackparams;

    % inform subject about upcoming calibration
    Screen('Flip',wd);
    WaitSecs(.5);
    text={'Bevor es weiter geht,','werden wir kurz den Eyetracker kalibrieren.'};
        displaytext(text,wd,wdw,wdh,orange,1,0);


    vetSetStimulusDevice(CRS.deVGA);

    errorCode = vetSelectVideoSource(CRS.vsUserSelect);
    if(errorCode<0); error('Video Source not selected.'); end;

    vetCreateCameraScreen;

    isCalibrated=0;
    while isCalibrated==0

        calibration_successful = ...
            vetCalibrateAdvanced(xPoints,yPoints,targetShape,targetSize,...
            targetColour,backgrColour,scaleFactor,fixationDuration,...
            accuracyLevel,imageFilename);


        [isCalibrated] = vetGetCalibrated;

    end

    vetSetStimulusDevice(CRS.deUser);

    % Create and display the stimulus.
    % -----------------------------------------------------------------------------

    % Check to ensure we have a dual-VGA monitor setup; then calculate the
    % location of the primary and secondary monitors in the format that is 
    % expected by the 'Position' property of MATLAB figures.

    MonitorPos         = get(0, 'MonitorPosition');
    if(numel(MonitorPos)<8); error('Less than two monitors detected.'); end;
    PrimaryPos         = MonitorPos(1,:);
    SecondaryPos       = MonitorPos(2,:);
    PrimarySize        = [  PrimaryPos(3)-  PrimaryPos(1),  PrimaryPos(4)-  PrimaryPos(2)] + 1;
    SecondarySize      = [SecondaryPos(3)-SecondaryPos(1),SecondaryPos(4)-SecondaryPos(2)] + 1;
    PrimaryLowerLeft   = [PrimaryPos(1)  , ((SecondarySize(2) - PrimaryPos(2))   - PrimarySize(2)) + 2];
    SecondaryLowerLeft = [SecondaryPos(1), ((PrimarySize(2)   - SecondaryPos(2)) - PrimarySize(2)) + 2];


    % Display a dialog to  allow the user to select the stimulus display 
    % that they wish to use. 
    MonitorToUse = uigetpref('Monitors','One', ...
                           'Stimulus Monitor Selection Dialog', ...
                           'Select which monitor to use.', {'1','2'}, ...
                           'CheckboxString','Always use this monitor.');
    switch MonitorToUse;
        case '1'
            SelectedPos = [PrimaryLowerLeft,  PrimarySize  ];
        case '2'
            SelectedPos = [SecondaryLowerLeft,SecondarySize];
    end

    vetSaveCalibrationFile(calib_file); % saves calibration to file


    %% start recording of eye movements

    vetStartTracking;
    vetCreateMimicScreen;

end % if location && scanning
