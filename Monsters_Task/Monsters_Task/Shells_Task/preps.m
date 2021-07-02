%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Z.approachstart=1; 
rand('twister',sum(1000*clock)); % make sure we use different random numbers
fixationfailure = 0; % variable that counts written fixation reminders 
fixationcontrol = 1; % this is set to zero when fixation control is turned off 
fixationcontrol_off = 0;

% make a unique string to save data 
namestring  = ['PIT_' subjn '_' session '_' datestr(now,'yymmdd_HHMM')];
namestring2 = ['PIT_' subjn '_' session ];
fprintf('\nData file name: %s\n',namestring)

% make sure we have a folder called data in which to store stuff
if exist('data')~=7; eval(['!mkdir data']); end

% print out in command window if we're saving stuff
if dosave 
	fprintf('............ Data will be saved as                              \n');
	fprintf('............ %s                                       \n',namestring);
	fprintf('............ in the folder ''data''\n');
end

%....................... randomization of stimuli 
Nmsh = 2*Z.Ninst;			% How many different instrumental stimuli
								% 2 = only one shell set; 4 = two shell sets for
								% approach & withdrawal 
[foo,pavind] = sort(rand(1, Z.Nps));	% randomize Pavlovian stimuli
[foo,mshind] = sort(rand(1, Nmsh));		% randomize instrumental stimuli 

%....................... Generate ITIs
if scanning;
	clear ITIPit
    ITI_matrix = csvread('iti_matrix.csv'); %read in the ITIs from optseq
    ITI_index = randi(size(ITI_matrix,2));
    ITIPit = ITI_matrix(:,ITI_index);
    Z.ITIPit = ITIPit;

    clear ITIPav
	ITIPav = -log(rand(1,Z.Npav)); %sticking with randrom draws from exponential dist on Pav
	i = ITIPav > (ITI_max-ITI_min);
	while sum(i)>0
		ITIPav(i) = -log(rand(1,sum(i)));
		i = ITIPav > (ITI_max-ITI_min);
	end
	Z.ITIPav = ITIPav+ITI_min;
	save PITITIs.mat Z ITIPit ITIPav;
else
	clear ITIPit
	ITIPit = -log(rand(1,Z.Npit));
	i = ITIPit > (ITI_max-ITI_min);
	while sum(i)>0
		ITIPit(i) = -log(rand(1,sum(i)));
		i = ITIPit > (ITI_max-ITI_min);
	end
	Z.ITIPit = ITIPit+ITI_min;

	clear ITIPav
	ITIPav = -log(rand(1,Z.Npav)); %sticking with randrom draws from exponential dist on Pav
	i = ITIPav > (ITI_max-ITI_min);
	while sum(i)>0
		ITIPav(i) = -log(rand(1,sum(i)));
		i = ITIPav > (ITI_max-ITI_min);
	end
	Z.ITIPav = ITIPav+ITI_min;
%	ITIPit = Z.ITIPit; 
%	ITIPav = Z.ITIPav; 
	save PITITIs.mat Z ITIPit ITIPav;
end



%................. Pavlovian block

[foo,i1] = sort(rand(1,Z.Npav/2-10));               % randomization
tmp1 = (1:Z.Nps)'*ones(1,Z.Npav/2/Z.Nps-2);         % Pavlovian stimuli 
pavpres1=[tmp1(:,1)' tmp1(end:-1:1,2)' tmp1(i1)];   % present full set twice at beginning
[foo,i2] = sort(rand(1,Z.Npav/2));                  % randomization 
tmp2 = (1:Z.Nps)'*ones(1,Z.Npav/2/Z.Nps);           % Pavlovian stimuli 
pavpres2=[tmp2(i2)];                                % present full set twice at beginning
pavpres = [pavpres1, pavpres2];

tmp = ones(5,1)*repmat([1 3],[1 Z.Npav/Z.Nps/2-1]);	% left or right?
	posp = tmp([i1 i2]);
	tmp = reshape([1 3 1 3 3 1 1 3 1 3],[5,2]);	% first ten 
	posp = [tmp(:)' posp];

pavout = Z.Pavout(pavpres); 							% Stimulus value sequence 

%................ Pavlovian query trials
% get all nchoosek(5,2)=10 combinations of the five Pavlovian stimuli three
% times 

Z.Nquerypav=30;

Ncp=Z.Nquerypav/10;  % Number of times each combination queried 

tmp=[];
for k=1:5; 
	tmp = [tmp [k*ones(1,5-k); (k+1):5]];
end
tmp(:,[3 4 7])=[4 5 5; 1 1 2];	 % stimuli equally frequently on each side 
tmp = repmat(tmp,[1 Ncp*10]);
cppres = tmp;

[foo,i] = sort(rand(1,Ncp*10));	% randomize order 
cppres = cppres(:,i);																			


%................ Instrumental training block 
if Z.Ntrain~=120; error('Can''t just alter length of experiment');end
if Z.Pi~=0.8; error('Need to alter crtfb to alter feedback error probability');end

crtfb0=ones(Z.Ntrain/2/Z.Ninst,2*Z.Ninst);
tmp=[];
for j=1:4; % in each of 4 blocks of 30 trials, each of the 6 stimuli gives wrong feedback once
	tmp = [tmp (j-1)*5+ceil(rand(2*Z.Ninst,1)*5) + (0:5)'*20];
end
crtfb0(tmp)=0;
crtfb0=crtfb0';
	
mprest=[];lrt=[];crtfb=[];
for j=1:10	 % 5 mini-blocks of 12 trials 
	[foo,i] = sort(rand(1,12));
	tmp = (1:Z.Ninst*2)'*ones(1,2);
		mprest = [mprest tmp(i)];
	tmp = ones(6,1)*(1:2);
		lrt = [lrt tmp(i)];
	tmp = crtfb0(:,(1:2)+(j-1)*2);
		crtfb = [crtfb tmp(i)];
end
lrt(lrt==2)=3;										
ainst = 1+(mprest>Z.Ninst);							% go (1) or nogo (2)
presstimest = zeros(Z.Ntrain,nogodelay_train*20);	


%................. PIT block 
if Z.Npit~=180; error('Sorry, can''t just alter length of PIT block...');end
ains=[]; mpres=[]; lr=[]; mpresp=[];
% for j=1:3;	% 3 mini-blocks of 54 trials
% 	[foo,i] = sort(rand(1,54));
% 	tmp = (1:6)'*ones(1,9);
% 		mpres = [mpres tmp(i)];
% 	tmp = ones(6,1)*mod((1:9)+j,2)+1; 
% 		lr = [lr tmp(i)]; % NB: can't fully counterbalance for 3 blocks
% 	tmp = ones(6,1)*(1:9);
% 		mpresp = [mpresp tmp(i)];
% end
for j=1:6;	% 6 mini-blocks of 30 trials
	[foo,i] = sort(rand(1,30));
	tmp = (1:6)'*ones(1,5);
		mpres = [mpres tmp(i)];
	tmp = ones(6,1)*mod((1:5)+j,2)+1; 
		lr = [lr tmp(i)]; % NB: can't fully counterbalance for 3 blocks
	tmp = ones(6,1)*(1:5);
		mpresp = [mpresp tmp(i)];
end

lr(lr==2)=3;
ains = 1+(mpres>Z.Ninst);
presstimes = zeros(Z.Npit,nogodelay_pit*20);

clear tmp foo i j; 

%----------------------------------------------------------------------------
%        Demo run? 
%----------------------------------------------------------------------------
if debug;
   Z.Ntrain=6;       % Number of instrumental training trials
   Z.Npit=7;         % Number of PIT trials 
   Z.Npav=3;         % Number of Pavlovian presentations, block 1 
	Z.Nquerypav=3; 	% Pavlovian comparison trials
  % Z.Nqueryalc=3;		% Alcoholic comparison trials
   dosave=1;
   %doinstr=0;
	pavpres=[1:3]; 
	%posp=[ones(1,10);3*ones(1,10)];posp=posp(:)';
	%pavfb=[ones(1,5) zeros(1,5) 1 0 1 0 1 0 1 0 1 0];
end

stim_trig = []; 
