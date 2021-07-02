%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eyetracking calibration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load the library, connect to Eye Tracker
addpath('C:\SMI_EyeTracker\SMI\iView X SDK\bin')
addpath('C:\SMI_EyeTracker\SMI\iView X SDK\include')
addpath('C:\SMI_EyeTracker\SMI\iView X SDK\lib')

warning('off', 'all');

connected = 0;

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
%ret = calllib('iViewXAPI', 'iV_Connect', formatString(16, int8('192.168.1.2')), int32(4444), formatString(16, int8('192.168.1.1')), int32(5555));
% MRT 1:
ret = calllib('iViewXAPI', 'iV_Connect', formatString(16, int8('169.254.28.27')), int32(4444), formatString(16, int8('169.254.28.28')), int32(5555));
% MRT 2
%ret = calllib('iViewXAPI', 'iV_Connect', formatString(16, int8('192.168.1.2')), int32(4444), formatString(16, int8('192.168.1.1')), int32(5555));
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
    
    disp('Get System Info Data')
    calllib('iViewXAPI', 'iV_GetSystemInfo', pSystemInfoData)
    get(pSystemInfoData, 'Value')
    
    
    disp('Calibrate iViewX')
    calllib('iViewXAPI', 'iV_SetupCalibration', pCalibrationData)
    
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
            %%% this is doing the calibration
            calllib('iViewXAPI', 'iV_Calibrate');
        elseif strcmpi(key,'v')
            %%% this is doing the validation
            calllib('iViewXAPI', 'iV_Validate');
        elseif strcmpi(key,'f')
            break;
        end
    end
    %%% this is doing the calibration
    %calllib('iViewXAPI', 'iV_Calibrate')
    %%% this is doing the validation
    %calllib('iViewXAPI', 'iV_Validate')
    
end
