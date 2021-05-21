%        EXPERIMENTAL PARAMETERS
%        *****These should not be altered*****
%----------------------------------------------------------------------------

Z.Ntrain = 120;          % Maximum Number of instrumental training trials
Z.Ninst = 3;             % Number of Instrumental stimuli per value
% (max 5; total # of instrumental stimuli = Z.Ninst*4)
Z.crit = [.8 16 60];	    % crit(1) percent correct past crit(2) trials, minimum crit(3)
                        %participant must be 80% accurate over 16 trials,
                        %with a minimimum of 60 trials
Z.Pavout=[-100 -25 0 25 100];  % Pavlovian outcomes
Z.Nps=length(Z.Pavout);  % Number of Pavlovian stimulus values
Z.Npav=80;            	 % Number of Pavlovian trials
Z.choicetime_query = 2;  % Maximal choice time during query trials [in seconds]

%Z.Ndrink=4; 				 % number of drink stimuli (first two are alcoholic, rest, max 2, non-alcoholic)
% note that this changes number of extra query trials
Z.Npit=180;              % Number of PIT trials overall
% try to keep: Npit a multiple of Ninst*2*Nps*2
Z.Pi=.8;                 % Probability of correct instrumental training feedback
pavCSfixdelay = 2.5;		 % Fixed CS delay (duration of CS only presentation)
pavUSfixdelay = 2.5;		 % Fixed US delay (duration of US only presentation)
pavCSUSfixdelay = .5;     % Fixed CS + US delay (time window during which CS is presented together with US)
pavISfixdelay = 3;		 % Fixed interstimulus delay between CS and US
pavITIfixdelay = 2;      % Fixed inter trial interval for Pavlovian conditioning

nogodelay_train = 2;     % Response time window during training
if strcmp(devicetype_part3,'joystick')  | strcmp(devicetype_part3,'cur_joystick')             % Response time window during PIT
    nogodelay_pit = 2;
else
    nogodelay_pit = 3;
end
pitdelay=.6;				 % time delay between background and instrumental onset during PIT
pressth = 6;             % number of times need to press to get all the way to other stimulus
th = 4;                  % threshold between go and nogo

maxpayout = 15;          % maximal possible payout
minpayout = 5;           % minimum possible payout
breaklength = 60;        % length of break [in seconds]
english=1;               % 1=english, 0=deutsch

doaudio	= 1;             % play audio (pav/pit -CSs) or not?
doaudio_instr = 1;        % play audio (instrumental) or not?
sounddur = 1;           % max duration of sound [in seconds]
sounddur_instr = 1.5;   % max duration of sound instrumental trials [in seconds]

ITI_max=6; 	 				 % minimal ITI
ITI_min=2;  	 			 % maximal ITI

if strcmpi(exploc,'b') && scanning==1 && exppart==3
    small_screen_berlin_scanning = 0;
else
    small_screen_berlin_scanning = 0;
end


%----------------------------------------------------------------------------
%        MRI triggers
%----------------------------------------------------------------------------

if      strcmpi(exploc,'b'); MRITriggerCode	= '5%';
elseif  strcmpi(exploc,'p'); MRITriggerCode	= '5%';
end
NumInitialfMRITriggers	= 4;
NumFinalfMRITriggers	= 15;
NumPostEyetrackerCalibraionfMRITriggers = 2;

%----------------------------------------------------------------------------
%        Text size - this should now automatically adjust with screen size
%----------------------------------------------------------------------------
txtfractsize = 0.025;		  % text size **** as fraction of *** window height

% stimulus triggers
% these are labels of the events recorded in stim_trig

pav_FC_on       = -1;  % onset of fixation cross
pav_FC_off      =  0;  % offset of fixation cross
pav_CS_on		=  1;	% onset of pavlovian stimulus
pav_CS_off		=  2;  % offset of pavlovian stimulus
pav_US_on		=  3;  % onset of outcome
pav_US_off		=  4;	% offset of outcome & onset ITI fixation cross

% no eyetracking during PIT - so don't need these
%pit_bg		 	= 10;  % onset PIT background Pavl stimulus
%pit_on		 	= 11;  % onset of PIT instrumental stimulus
%pit_dot			= 12;  % show final dot position
%pit_fix			= 13;  % ITI fixation cross onset

