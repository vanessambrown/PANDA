%% definition of general eyetracking parameters for BERLIN ONLY

global CRS;

if isempty(CRS); crsLoadConstants; end;

fixation_period=200;        % minimum period to be considered as fixation in ms
fixation_range=1;           % range (in degr vis ang) to be considered as fixation
vetSetEIB_LEDsEnabled=0;

stim_trig_results=[cd '\data\stim_triggers_' namestring2 '_' num2str(block) '.mat'];
eyetrack_results_mat=[cd '\data\eyetracking_' namestring2 '_' num2str(block) '.mat'];
%eyetrack_results_csv=[cd '\data\eyetracking_' namestring2 '_' num2str(block) '.csv'];


%% parameters for eyetracker calibration

xPoints=4;                  % number of horizontal dots
yPoints=3;                  % number of vertical dots
targetShape=CRS.tsCircle;   % shape of calibration targets
targetSize=0.25;             % diameter of the target in ?
targetColour=[1 1 1];       % colour of the target
backgrColour=[0.5 0.5 0.5]; % colour of background
scaleFactor=70;             % percentage of calibration area compared to whole screen
fixationDuration=500;       % length of required fixation
accuracyLevel=CRS.acMedium; % accuracy level (i.e. tolerated movement)
imageFilename=[''];
calib_file=[cd '\data\calibration_' namestring2 '_' num2str(block) '.scf'];

%% parameters for mimic screen (display of eye movements for experimenter)

vetSetMimicBackgroundColor([0.5 0.5 0.5]);
vetSetMimicFixationColor([1 0 0]);
vetSetMimicTraceColor([0 0 1]);
vetSetMimicPersistence(5);       %duration of trace on mimic screen in s
vetSetMimicPersistenceStyle(CRS.psFade);
screen_res=get(0,'ScreenSize');
vetSetCameraScreenDimensions(0,0,screen_res(3)/4,screen_res(4)/4);
  							 % size and position of camera stream window
vetSetMimicScreenDimensions(screen_res(3)/4,0,screen_res(3)/4,...
    screen_res(4)/3);   % size and position of mimic window

% vetSetMimicPersistenceType(CRS.ptMotionAndFixation);

%% parameters for fixation control

size_ROI_Px=38;             % size of ROI in Pixel
ROI_centre_x=wdw/2;         % centre of ROI (see script 'fixatecentre')
ROI_centre_y=.5*wdh;

% transform Px to mm:
size_ROI_mm=size_ROI_Px*monitor_size_xmm/wdw;
ROI_centre_x_mm=(ROI_centre_x*monitor_size_xmm/wdw) - (monitor_size_xmm/2);
ROI_centre_y_mm=(monitor_size_ymm/2) - (ROI_centre_y*monitor_size_ymm/wdh);

[regionHandle]=vetAddRegion(ROI_centre_x_mm-(size_ROI_mm/2), ...
    ROI_centre_y_mm+(size_ROI_mm/2),ROI_centre_x_mm+(size_ROI_mm/2),...
    ROI_centre_y_mm-(size_ROI_mm/2));

min_fix_time=20;       % required fixation duration in ms
