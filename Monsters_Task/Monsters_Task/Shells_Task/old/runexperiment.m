%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Main script for PIT experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;		% Tabula rasa
aborted = 0;	% if this parameter is set to one, things will abort.
modifymePIT;	% set the subject-specific experimental parameters
diary('data/debug.txt');


%.................. Set experimental session
while 1
    exppart = str2num(input('Part 1, 2, 3 or 4? (only part 3 to be run inside scanner)? ','s'));
    if isempty(exppart) || ~any(exppart==[1 2 3 4]);
        fprintf('\n *** ERROR *** Please enter 1, 2, 3 or 4:\n\t 1 (part 1 is instrumental trainig, always outside scanner)\n\t 2 (part 2 is Pavlovian training) and \n\t 3 (part 3 PIT, can be in scanner)\n\t (part 4 contains only the query trials outside the scanner)')
    else break;
    end
end

%.................. Ensure we know which version we're running
while 1
    correctversion = input(['File modifyme.m says we are running version ' expversion '. Is this correct? [yes/no] '],'s');
    if strcmp(correctversion,'yes');    break;
    elseif strcmp(correctversion,'no'); error('\n *** In that case, please check the version is correct in modifyme.m *** \n');
    else                                fprintf('Please enter either yes or no\n');
    end
end

%.................. Ensure we set the scannning variable correctly
while 1
    if scanning; foo = input(['File modifyme.m says we are scanning in part 3. Is this correct? [yes/no] '],'s');
    else;        foo = input(['File modifyme.m says NOT SCANNING. Is this correct? [yes/no] '],'s');
    end
    if strcmp(foo,'yes');    break;
    elseif strcmp(foo,'no'); error('\n *** Ok, please check. *** \n');
    else                     fprintf('Please enter either yes or no\n');
    end
end


try 	% this is important: if there's an error, psychtoolbox will crash graciously
    % and move on to the 'catch' block at the end, where all screens etc are
    % closed.
    
    % ............... Setup
    
    % setup for stimulus presentation sequences and other stuff. We only want to
    % do this the first, time, i.e. when exppart is 1. After that, we want to
    % load the previous settings and data. This is true regardless of whether
    % we're in the scanner for part 2 or not.
    
    expparams;	% set the general experimental parameters
    
    if exppart == 1
        preps;		      % generate new stimulus sequence etc.
    elseif any(exppart == [2 3 4]) % load everything from previous session
        loadandcheckpreviousdata;
    end
   
    setdevicetype;  % set device type; this may change between parts
    setup;			% setup display, stimulus coordinates, load images etc.
    approach = 1; 	% leftover from when we also had withdrawal
    
    if exppart==1	   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   APPROACH PIT TRAINING OUTSIDE THE SCANNER    %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf('............. Instrumental training\n')
        
        % start some counters for comparison trials and for eyetracking
        cit = 0; citadd= 0; block = 0;
        
        % save everything at the outset
        if dosave; eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat']);end
        T.tmp=GetSecs;	% to measure length of experiment part
        
        %.............. instruction for Instrumental training ......................
        tic;
        if doinstr; instrpitapproach; end
        T.instrpitapproach=toc;
        
        %.............. Instrumental training ......................................
        tic;
        dobreak = 0;
        for nt = 1:Z.Ntrain
            pittraining;
            if dobreak; break; end	% if criterion reached, end instrumental training
        end
        T.pittrainingapproach=toc;
        

        
        T.exppart1 = GetSecs-T.tmp;
        
    elseif exppart==2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %     Second part of the experiment                      %
        %		 THIS CAN BE IN SCANNER OR OUTSIDE OF SCANNER      %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf('............. Pavlovian conditioning \n');
        %.............. Instructions for the next parts ............................
        if doinstr; instrpav; end
        
        % save everything at the outset
        if dosave; eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat']);end
        T.tmp=GetSecs;	% to measure length of experiment part
        
        %.............. Pavlovian refresher instructions ...........................
        tic;
        if doinstr; instrpavscanner; end
        T.instrpav=toc;
        
        %................ wait for scanner trigger.................................
%         if scanning
%             DrawFormattedText(wd,'Gleich geht''s los ...','center', 'center', txtcolor);
%             if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end % draw frame
%             Screen('Flip',wd);
%             if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end
%             T.fMRI_triggerT0_pav = WaitForMRITrigger(MRITriggerCode, NumInitialfMRITriggers, Display);
%             drawfixationcross(wd,2,fixationdotsize,0); % Draw central fixation point
%             if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end % draw frame
%             Screen('Flip',wd);
%             WaitSecs(10);
%         end
        
        %................ Pavlovian training .......................................
        tic;
        for np = 1:Z.Npav;	% eyetracker on
            pavlov;				% eyetracker on
        end						% eyetracker on
        T.pavapproach=toc;
        
        WaitSecs( 10 );
        
        % acquire some final volumes until end of HRF
%         if scanning
%             fprintf('\nAcquiring final volumes\n');
%             drawfixationcross(wd,2,fixationdotsize,0);
%             if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end % draw frame
%             Screen('Flip',wd);
%             T.fMRI_triggerTend_pav = WaitForMRITrigger(MRITriggerCode, NumFinalfMRITriggers);
%         end
        
        %.............. end of Pavlovian training .................................
        T.exppart2 = GetSecs-T.tmp;
        
    elseif exppart==3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %     Third part of the experiment						      %
        %     THIS CAN BE IN SCANNER OR OUTSIDE OF SCANNER       %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        screenNumber = max(Screen('Screens'));		% select the last monitor.
        
        %% UPDATE MIRROR SCREEN FOR fMRI 03-02-2020 -------------------
        
        
%     [wdw, wdh]=Screen('WindowSize', wd);    % Get screen size
%     txtsize     = round(wdh/12);            % relative text size: adjust text size to screen size
%     if txtsize>max_txtsize; txtsize=max_txtsize; end; % enforce maximal text size here
%     Screen('TextSize',wd,txtsize);            % Set size of text

% 
%         % Make a backup copy of the current transformation matrix for later
%         % use/restoration of default state:
%         % Screen('glPushMatrix', wd); % not needed
% 
%         % Translate origin into the geometric center of text:
%         Screen('glTranslate', wd, wdw/2, wdh/2, 0);
%        
%         % Apply a scaling transform which flips the diretion of x-Axis,
%         % thereby mirroring the drawn text horizontally:
%         upsideDown = 0;
%         if upsideDown
%             Screen('glScale', wd, 1, -1, 1);
%         else
%             Screen('glScale', wd, -1, 1, 1);
%         end
%        
%         % We need to undo the translations...
%         Screen('glTranslate', wd, -wdw/2, -wdh/2, 0);

        %% END UPDATE 02-03-2020 Mirror Sreen --------------------------

        
        MRITriggerCode	= '5%';
        fprintf('............. Approach PIT session \n');
        % save everything at the outset
        if dosave; eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat']);end
        T.tmp=GetSecs;	% to measure length of experiment part
        
        tic
        if doinstr; instrpitstart; end
        T.instrpit=toc;
        
        %................ wait for scanner trigger.................................
        if scanning
            DrawFormattedText(wd,'Gleich geht''s los ...','center', 'center', txtcolor);
            Screen('Flip',wd);
 %           if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end
            T.fMRI_triggerT0_pit = WaitForMRITrigger(MRITriggerCode, NumInitialfMRITriggers, Display);
            drawfixationcross(wd,2,fixationdotsize,0); % Draw central fixation point
 %           if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end
            Screen('Flip',wd);
            WaitSecs(10);
        end
        
        %................ PIT ......................................................
        tic;
        for npit = 1:Z.Npit
            pit;
        end
        T.pitapproach=toc;
        
        % acquire some final volumes until end of HRF
        if scanning
            fprintf('\nAcquiring final volumes\n');
            drawfixationcross(wd,2,fixationdotsize,0);
            Screen('Flip',wd);
            T.fMRI_triggerTend_pit = WaitForMRITrigger(MRITriggerCode,NumFinalfMRITriggers);
        end
        
        %.............. end of PIT ................................................
        T.exppart3 = GetSecs-T.tmp;
        
    elseif exppart==4	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %     Fourth part of the experiment                      %
        %		AFTER THE SCANNER                                  %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if dosave; eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat']);end
        T.tmp=GetSecs;	% to measure length of experiment part
        
        fprintf('............. Pavlovian CS query trials \n')
        if doinstr; instrcompare; end
        tic;
        for npp = 1:Z.Nquerypav
            comparesequential;
        end
        T.querypav=toc;
        
        %.............. payment ....................................................
        if payment
            payoutinstr		= 0.2* ( (sum(crt==1) + sum(cr==1)) - (sum(crt==0) + sum(cr==0)));
%             payoutcomp		= Z.Pavout([cppres(1,chq==1) cppres(2,chq==2)]);
            payoutpav		= Z.Pavout(mpresp(mpresp<6));
            payoutpav(payoutpav>10)=0; % don't count alcohol and nicotine trials
            payoutpavtrials = rand(1,sum(mpresp<6))>.5;	% coin toss on each PIT trial
%             earned			= payoutinstr+sum(payoutcomp*0.10)+sum(payoutpav(payoutpavtrials));
%             earned			= payoutinstr+sum(payoutpav(payoutpavtrials));
            earned          = payoutinstr;
            payout			= round(100*max(min(maxpayout,earned),minpayout))/100;
            
            fprintf('\n******************************\n')
            fprintf('\t\tPayout: %g Euro\n',payout);
            fprintf('\n******************************\n')
            WaitSecs(7);
        end
        displaytext({'Dieses Experiment ist nun zu Ende. Vielen Dank.'},wd,wdw,wdh,txtcolor,0,1);
        
        T.exppart4 = GetSecs-T.tmp;
    end
    
    %.............. save all in two separate files .............................
    
    if dosave; eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat']);end
    if dosave; eval(['save data/' namestring2 '_exppart' num2str(exppart) '.mat']);end
    
    ListenChar(0);
    
    % ONLY WINDOWS
%    if strcmpi(exploc,'b') & scanning==1; ShowHideWinTaskbarMex(1); end
    ShowCursor;
    Screen('CloseAll');
    
catch % execute this if there's an error, or if we've pressed the escape key
    
    if aborted==0;	 % if there was an error
        fprintf(' ******************************\n')
        fprintf(' **** Something went WRONG ****\n')
        fprintf(' ******************************\n')
        if dosave; eval(['save data/' namestring  '_exppart' num2str(exppart) '.crashed.mat;']);end
    elseif aborted==1; % if we've abored by pressing the escape key
        fprintf('                               \n')
        fprintf(' ******************************\n')
        fprintf(' **** Experiment aborted ******\n')
        fprintf(' ******************************\n')
        if dosave; eval(['save data/' namestring  '_exppart' num2str(exppart) '.aborted.mat;']);end 
    end
    
    ListenChar(0);
    ShowCursor;
    Screen('CloseAll'); % close psychtoolbox, return screen control to OSX
    rethrow(lasterror)
end

% process individual data
preprocessindividualdata;


diary off;
