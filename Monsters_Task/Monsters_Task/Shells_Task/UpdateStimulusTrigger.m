function stim_trig = UpdateStimulusTrigger(ExperimentLocation, scanning, exppart, FlagEyeTracking, stim_trig, TrialLabel)

if FlagEyeTracking
	switch upper(ExperimentLocation)
	case 'B'
		if scanning==1 & exppart==2 % inside the scanner in Berlin: iView XTM MRI-LR, SMI software
			% pSampleData has to be available e.g. must be set to be global otherwise is has to be passed to this function
			[pSystemInfoData, pSampleData, pEventData, pAccuracyData, CalibrationData] = InitiViewXAPI();
            calllib('iViewXAPI', 'iV_GetSample', pSampleData) 
			eyetrackdata		= get(pSampleData,'Value');
			TimeStampEyeTracker = eyetrackdata.timestamp;
			TimeStampMain=GetSecs;
		else      % outside the scanner in Berlin
			TempTimeStamp		= vetGetLatestEyePosition;        % retrieve data point from eye tracker 
			TimeStampEyeTracker	= TempTimeStamp.timeStamps;
			TimeStampMain=GetSecs;
		end
	case 'D'
		TempTimeStamp		= Eyelink('NewestFloatSample');
		TimeStampEyeTracker	= TempTimeStamp.time;
		TimeStampMain=GetSecs;
	end
else
	TimeStampEyeTracker = NaN;
	TimeStampMain=NaN;
end

stim_trig = [stim_trig; TimeStampMain, TimeStampEyeTracker, TrialLabel];
