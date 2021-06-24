%---------------------------------------------------------------------------
%
% This file preprocesses all the raw variable into one structure Data containing
% all the data necessary for beahvioural analysis. It is only called on exiting
% after exppart 4. It is saved in the folder data_processed. 
%
%---------------------------------------------------------------------------

if exppart==4
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% INSTRUMENTAL PART 

	Data.Instr.Reward  = r;	 							% reward 
	Data.Instr.Responses  = cht;						% responses 
	Data.Instr.InstrStim  = mprest';					% instrumental (shell) stimulus
	Data.Instr.Correct  = crt;							% correct or incorrect 
	Data.Instr.RTfirst = treact; 						% get rid of minus sign for release
	Data.Instr.RTall = presstimest; 					% all response timings 
	Data.Instr.InstrResp = ainst;						% instructed response (go or nogo shell stimulus)
	Data.Instr.nogodelay_train = nogodelay_train;	% nogo delay 
	Data.Instr.th = th;									% threshold to define 'go'


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% PIT 

	Data.PIT.Responses  = ch;				        	% responses 
	Data.PIT.InstrStim  = mpres;						% instrumental (shell) stimulus 
	Data.PIT.Correct  = cr;								% correct or incorrect 
	Data.PIT.PavlovianStimulus  = mpresp';			% Pavlovian (fractal) stimulus
	Data.PIT.PavStimVal = Z.Pavout;					% Values of Pavlovian stimuli 
	Data.PIT.RTfirst = pitreact; 						% reaction time to first response 
	Data.PIT.RTall = presstimes; 						% all response timings 
	Data.PIT.InstrResp = ains';						% instructed response (go or nogo shell stimulus)
	Data.PIT.nogodelay_pit = nogodelay_pit; 		% delay before nogo 
	Data.PIT.th = th;										% threshold to define 'go'

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% PAVLOVIAN TRAINING 

	Data.Pavl.Stimulus  = pavpres;					% Pavlovian stimulus presented 
	Data.Pavl.StimulusValues= pavout;				% Value of each Pavlovian stimulus
	Data.Pavl.Outcomes = Z.Pavout(pavpres);		% Sequence of outcomes presented 

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% PAVLOVIAN QUERY 
		
	Data.QueryPav.Stimuli  = cppres;					% Pavl conditioned stimuli presented 
	Data.QueryPav.Response  = chq;					% stimulus chosen 
    Data.QueryPav.Correct  = crm;						% correct (better chosen) 


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Timings for fMRI analysis  & eyetracking analysis 

	Data.fmriT = T;					% all events as recorded in T
	%Data.eyeEvents = stim_trig; 	% simply the event matrix stim_trig for eyetracking analysis

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Other variables 

	Data.Z = Z; 

	Data.setup.drm  = drm(:,[1 3]);
	Data.setup.wdw	 = wdw;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Subject variables 

	Data.subj.exppart = exppart;
	Data.subj.subjn   = subjn; 
	Data.subj.session = session; 
	Data.subj.exploc  = exploc; 
	Data.subj.dominanthand = dominanthand; 
	Data.subj.expversion = expversion; 
	Data.subj.namestring = namestring; 

	eval(['save data/' namestring '_ProcessedData Data']);

end
