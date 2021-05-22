% definition of general eyetracking parameters for DRESDEN ONLY

if strcmpi(exploc,'d');
   disp('======================== Eyelink Initialisation');

	% Pay attention that this is HALF length
	if scanning == 1 & exppart==2
		EyeLinkBoxHalfLength	= 62;	% for a resolution of 1280 x 1024 inside scanner % 24
        EyeLinkBoxHalfLength	= FixcheckBoxHalf_pix;
	else 
		EyeLinkBoxHalfLength	= 78;	% for a resolution of 1600 x 1200 outside scanner % 30
        EyeLinkBoxHalfLength	= FixcheckBoxHalf_pix;
	end

	dummymode = 0;
	
	% Provide Eyelink with details about the graphics environment
	% and perform some initializations. The information is returned
	% in a structure that also contains useful defaults
	% and control codes (e.g. tracker state bit and Eyelink key values).
	el = EyelinkInitDefaults(wd);
	
	% Initialization of the connection with the Eyelink Gazetracker.
	% exit program if this fails.
	if ~EyelinkInit(dummymode, 1)
		fprintf('Eyelink Init aborted.\n');
		
		Eyelink('Shutdown');
		
		% Close window:
		sca;
		
		% Restore keyboard output to Matlab:
		ShowCursor;
		error('Eyelink Init aborted');
	end
	
   [el.v, el.vs]=Eyelink('GetTrackerVersion');
   fprintf('Running experiment on a ''%s'' tracker.\n', el.vs);
	
	% make sure that we get gaze data from the Eyelink
   Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
end
