fprintf('............ Setting up the psychtoolbox screen   \n');

%................... colours (in RBG)
bgcol 	= [80 200];	% this is just in grayscale (each value separately)
white 	= [200 200 200]; 
black 	= [0 0 0]; 
orange 	= [20 20 20];
yellow 	= [230 230 80];
red 		= [255 20 20]; 
blue 		= [120 120 255]; 
green 	= [0 135 00]; 
dotcolend= [0 0 255];
txtcolor = black;
dotsize	= 20;

fixationdotsize = 9; 	% Size of fixation dot. Increase only if too small.
visAngFrac = 0.6715; %I think this is visual angle -- unsure whether to change or leave??
abortkey = 'q';

pstim = 'stimuli';
pshel = {'shells';'monsters'};    % instrumental stimuli for the two sessions

%pittsburgh fixed screen size
wdwb = round(1024*visAngFrac);
wdhb = round(768*visAngFrac);

%................... tiling backgrounds 
nbx = 4; 	% 4; number of background stimuli along x direction
nby = 3; 	% 3; number of background stimuli along y direction

HideCursor;
%ListenChar(2);

%................... open a screen
Screen('Preference','Verbosity',0);
imagingmode=kPsychNeedFastBackingStore;


% Due to the scanner display setting, we need to select the primary monitor as stimulus monitor.
%screenNumber = max(Screen('Screens'));	% select the last monitor.

smallscreen=debug;
if smallscreen
	Screen('Preference','SkipSyncTests',2); % ONLY do this for quick debugging;
	wd=Screen('OpenWindow', screenNumber,bgcol(2),[0 20 800 600],[],2,[],[],imagingmode); % make small PTB screen on my laptop screen
 elseif strcmpi(exploc,'p')
     wd=Screen('OpenWindow', screenNumber,bgcol(2),[],[],2,[],[],imagingmode); %automatically grab the resolution
%    wd=Screen('OpenWindow', screenNumber,bgcol(2),[0 0 1280 768],[],2,[],[],imagingmode);
%    wd=Screen('OpenWindow', screenNumber ,bgcol(2),[0 0 1024 768],[],2,[],[],imagingmode);
 elseif strcmpi(exploc,'p') && exppart==3
     Screen('Preference','SkipSyncTests',2); %adding due to problem with dual graphics card & psychtoolbox -- fix before running in lab/scanner
     wd=Screen('OpenWindow', screenNumber,bgcol(2),[],[],2,[],[],imagingmode);
end

KbName('UnifyKeyNames'); % need this for KbName to behave

%---------------------------------------------------------------------------
%                    SCREEN LAYOUT
%---------------------------------------------------------------------------
[wdwt, wdht]=Screen('WindowSize', wd);	% Get TRUE screen size 
wdht_low = wdht - (.1*wdht); % set height to be 10% smaller to allow for feedback banner
            %% UPDATE MIRROR SCREEN FOR fMRI 03-02-2020 -------------------
            %% this is site-specific to Berlin; unlikely to be needed for
            %% MRI in Pitt, can ignore---------
 
%         % Translate origin into the geometric center of text:
%         if scanning==1 & strcmpi(exploc,'b') &  exppart==3
%             Screen('glTranslate', wd, wdwt/2, wdht/2, 0);
%             
%             % Apply a scaling transform which flips the direction of 
%             x-Axis,
%             % thereby mirroring the drawn text horizontally:
%             mirrorANDupsidedown = 0;  % this is what Berlin needs for MRI setup (flip vertically and horizontally)
%             upsideDown = 0;
%             mirror = 1;
%             if upsideDown
%                 Screen('glScale', wd, 1, -1, 1);
%             elseif mirrorANDupsidedown
%                 Screen('glScale', wd, -1, -1, 1);
%             elseif mirror
%                 Screen('glScale', wd, -1, 1, 1);
%             else
%                  Screen('glScale', wd, 1, 1, 1);
%             end
%             
%             % We need to undo the translations...
%             Screen('glTranslate', wd, -wdwt/2, -wdht/2, 0);
%         end

        %% END UPDATE 02-03-2020 Mirror Sreen --------------------------

wdw=wdwt; wdh=wdht;  % set to size of screen


% work with 'wdw' as the size of the area we want to *use*
txtsize = ceil(wdh * txtfractsize);
Screen('TextSize',wd,txtsize);			% Set size of text

%................... Presentation coordinates 
% coordinates for fixation check box
FixcheckBox_frac     = 0.12; %
FixcheckBoxHalf_frac = FixcheckBox_frac / 2;
FixcheckBoxHalf_pix  = round( FixcheckBoxHalf_frac * wdw );

% coordinates for stimuli
xfrac=.7; 					% fraction of x width to use 
yfrac=.5; 					% fraction of y height to use 
xl0=xfrac*wdw; 			% width to use in points 
yl0=yfrac*wdh; 			% height to use in points 
blw = .5*yl0;

x0=(1-xfrac)/2*wdw; 		% zero point along width 
y0=(1-yfrac)/2*wdh;		% zero point along height

% now set to true size, so that the middle (wdw/2) really is in the middle of
% the screen 
wdw=wdwt;
wdh=wdht;

% 2 boxes to present the Pavlovian stimuli on their own / with outcomes and
% squares stimuli 
for j=1:2
	dr(j,:)=round([x0+(j-1+.1)*xl0/2 y0 x0+(j-.1)*xl0/2 y0+yl0-.1*yl0]);
end

global drmf drmd; %sets up 2 empty doubles
Nsqx=3;
xls=xl0/Nsqx; %divides screen in 3 by width
for j=1:Nsqx
	% 3 frames around those boxes 
	drm (j,[1 3])=round([x0+(j-1)*xls 			x0+j*xls]);		 
	drm (j,[2 4])=round([y0+.2 *yl0 				y0+.8 *yl0]);		 
	% 3 points to present dots centered in each of these boxes 
	drmd(j,:) = round([mean(drm(j,[1 3])) mean(drm(j,[2 4]))]);
	% 3 small square boxes for outcomes 
	drmo(j,:) = [drmd(j,1)-blw/2 drmd(j,2)-blw/2 drmd(j,1)+blw/2 drmd(j,2)+blw/2];
	% 3 fixation crosses 
	drmf(:,:,j) = [[drmd(j,1)-blw/40; drmd(j,2)] [drmd(j,1)+blw/40; drmd(j,2)]...
	               [drmd(j,1); drmd(j,2)-blw/40] [drmd(j,1); drmd(j,2)+blw/40]]; 
end

% change of stimulus size (in pixels) for joystick responses
stim_change_appr=[40 80 120];    % for collecting stimuli
stim_change_avoid=[-40 -80 -120];    % for leaving stimuli

% box for tiling background
bgr = [0 0 wdw wdh];

% coloured squares
graysquare  = Screen('Maketexture',wd,bgcol(1)*ones(10,10,3));
blacksquare = Screen('Maketexture',wd,repmat(reshape(black,[1 1 3]),[10 10 1]));

% assign some variables for use by WaitForMRITrigger.m
Display.wd	= wd;
Display.drmd	= drmd;
Display.fixationdotsize = fixationdotsize;



%---------------------------------------------------------------------------
%		Preload images so we have good presentation time control 
%---------------------------------------------------------------------------
% these two are set in preps.m: 
% [foo,mshind] = sort(rand(1,Nmsh));		% randomize instrumental stim 
% [foo,pavind] = sort(rand(Z.Nps,1));		% randomize Pavlovian stimuli

% Select either shells or monsters as images for the instrumental conditioning
if PIT_version==1
    shrooms=1;  % select shells
elseif PIT_version==2
    shrooms=0; % select monsters
end

if shrooms % Load shell images 
    for k=1:Nmsh
		eval(['tmp=imread(''' pshel{1} '/sbell_' num2str(k) '.png'');'])
		msh(1,mshind(k))=Screen('MakeTexture',wd,tmp);
    end
else        % load monster images
    for k=1:Nmsh
		eval(['tmp=imread(''' pshel{2} '/monsters_' num2str(k) '.png'');'])
		msh(1,mshind(k))=Screen('MakeTexture',wd,tmp);
    end
end


    
% for instructions
if shrooms  % shells
	eval(['tmp=imread(''' pshel{1} '/shell_instr.png'');'])
else        % monsters
	eval(['tmp=imread(''' pshel{2} '/monsters_instr.png'');'])
end
msh(1,Nmsh+1)=Screen('MakeTexture',wd,tmp);

% for test training during instructions
for k=1:4
	if shrooms      % shells
		eval(['tmp=imread(''' pshel{1} '/shell_instr' num2str(k) '.png'');'])
    else            % monsters
		eval(['tmp=imread(''' pshel{2} '/monsters_train' num2str(k) '.png'');'])
    end
	mshtest(1,k)=Screen('MakeTexture',wd,tmp);
end


% Load Pavlovian stimuli
% decide which version of Pavlovian stimuli to load
if PIT_version==1
    pav_stim='fractal';     % original Pavlovian stimuli
elseif PIT_version==2
    pav_stim='fractal_new'; % new set of Pavlovian stimuli
end



for k=1:Z.Nps
	eval(['tmp=imread(''' pstim '/' pav_stim num2str(k) '.jpg'');'])
	shape(1,pavind(k))=Screen('MakeTexture',wd,tmp);

	% tile the Pavlovian stimuli all over background for the PIT stage
	clear Tmp;
	for j=1:3
		Tmp(:,:,j) = repmat(tmp(:,:,j),nby,nbx);
	end
	bgshape(1,pavind(k))=Screen('MakeTexture',wd,Tmp);

	text = {'Experimental Setup',num2str(Z.Nps-k)};
	displaytext(text,wd,wdw,wdh,orange,0,0);

	checkabort;
end

% for instructions
eval(['tmp=imread(''' pstim '/fractal6.jpg'');']);
shapeinstr(1,1)=Screen('maketexture',wd,tmp);
eval(['tmp=imread(''' pstim '/fractal7.jpg'');']);
shapeinstr(1,2)=Screen('maketexture',wd,tmp);

% Load Outcome stimuli -- note no outcomep(3) because that's a neutral
% trial and no stimulus is shown
eval(['tmp=imread(''' pstim '/DollarX.jpg'');' ]); %-1 Dollar
outcomep(1)=Screen('MakeTexture',wd,tmp);
eval(['tmp=imread(''' pstim '/QuarterX.jpg'');' ]); %-25 Cents
outcomep(2)=Screen('MakeTexture',wd,tmp);
%change below when we revalue the Pavlovian stimuli
eval(['tmp=imread(''' pstim '/Quarter.jpg'');' ]); %+25 Cents
outcomep(4)=Screen('MakeTexture',wd,tmp);
eval(['tmp=imread(''' pstim '/Dollar.jpg'');' ]); %+1 Dollar
outcomep(5)=Screen('MakeTexture',wd,tmp);

eval(['tmp=imread(''' pstim '/safe.jpg'');' ]);
outcomei(1)=Screen('MakeTexture',wd,tmp);
eval(['tmp=imread(''' pstim '/3150.jpg'');']); 
outcomei(2)=Screen('MakeTexture',wd,tmp);
eval(['tmp=imread(''' pstim '/3010.jpg'');']); % picture for training 
outcomei(3)=Screen('MakeTexture',wd,tmp);

%.................... Arrows 
eval(['tmp=imread(''' pstim '/arrows.tif'');'])
	tmp(tmp==255)=bgcol(2);
    arrowsquare(1,:)=[wdw*.02 wdh*.92 wdw*.16 wdh*.98];
    arrow=Screen('MakeTexture',wd,tmp);

%.................... Instructions positions
addpath('instr_funcs');
yposm = 'center';
	yposb = .8*wdh; 
	ypost = .20*wdh; 
	ypostt=.13*wdh;


clear Tmp

%---------------------------------------------------------------------------
%                    SOUND : PAVLOVIAN
%---------------------------------------------------------------------------
setsoundlevel=0;
if (doaudio && exppart>1 )
% 	if ~exist('risingfreq');
% 		risingfreq = rand>0.5; % highest tone for highest value or other way round? 
% 		drinksound = rand>0.5;
% 	end
% 	freq = round(440*2*pi);
% 	%rat=[2.5 2 1.5 .67 .5 .4]; 
% 	rat=[1 1.19 1.41 1.68 2]; % log-linearly spaced tones between 440 and 880 Hz 
% 	if ~risingfreq; rat=rat(end:-1:1); end
% 	for k=1:Z.Nps
% 		rawsound(k,:)=sin((0:(sounddur*440*2*pi))*rat(k));
% 	end
% 
	% Perform basic initialization of the sound driver:
	InitializePsychSound;

	% Open the default audio device [], with default mode [] (==Only playback),
	% and a required latencyclass of zero 0 == no low-latency mode, as well as
	% a frequency of freq and nrchannels sound channels.
	% This returns a handle to the audio device:
	% Fill the audio playback buffer with the audio data 'wavedata':
% 	for k=1:Z.Nps
% 		soundhandle(k) = PsychPortAudio('Open', [], [], 0, freq, 1);
% 		PsychPortAudio('FillBuffer', soundhandle(k), rawsound(k,:));
% 	end


% load sounds for monetary outcomes
if strcmp(session,'1')
    piano_files=1:5;
elseif strcmp(session,'2')
    piano_files=2:6;
end

for pf=1:length(piano_files)
  	freqwav = 44100;
    tmp=audioread(['sounds/piano_' num2str(piano_files(pf)) '.wav']);
  	tmp = tmp(:,1)'; 
	tmp = tmp(40000+(1:freqwav*sounddur));
	tmp = tmp/max(abs(tmp))*1.5;

	soundhandle(pf) = PsychPortAudio('Open', [], [], 0, freqwav, 1);
	PsychPortAudio('FillBuffer', soundhandle(pf), tmp);
end

end

%---------------------------------------------------------------------------
%                    SOUND: INSTRUMENTAL
%---------------------------------------------------------------------------

setsoundlevel=0;
if (doaudio_instr && exppart==1)

% Perform basic initialization of the sound driver:
InitializePsychSound;

aversive_files=1:2;

for af=1:length(aversive_files)
% load sounds for instrumental outcomes
freqwav = 44100;
tmp=audioread(['sounds/aversive_' num2str(aversive_files(af)) '.wav']);
tmp = tmp(:,1)'; 
tmp = tmp(40000+(1:freqwav*sounddur_instr));
tmp = tmp/max(abs(tmp))*1.5;

soundinstr(af) = PsychPortAudio('Open', [], [], 0, freqwav, 1);
PsychPortAudio('FillBuffer', soundinstr(af), tmp);

end
end

%---------------------------------------------------------------------------
%                    SOUND: PIT
%---------------------------------------------------------------------------


setsoundlevel=0;
if (doaudio_instr && exppart==3)

% Perform basic initialization of the sound driver:
InitializePsychSound;

pitwav = 100; % set to some number outside the range of PAV/instrumental sounds
% load sounds for instrumental outcomes
freqwav = 44100;
tmpit=audioread(['sounds/aversive_2.wav']);
tmpit = tmpit(:,1)'; 
tmpit = tmpit(40000+(1:freqwav*sounddur_instr));
tmpit = tmpit/max(abs(tmpit))*1.5;

soundinstr(pitwav) = PsychPortAudio('Open', [], [], 0, freqwav, 1);
PsychPortAudio('FillBuffer', soundinstr(pitwav), tmpit);


end
