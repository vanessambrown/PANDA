
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Main script for PIT experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;		% Tabula rasa
aborted = 0;	% if this parameter is set to one, things will abort.
modifymePIT;	% set additional experimental parameters
diary('data/debug_pitt.txt'); % establishes debugging diary
scan = scanning; %pulls from modify me


%.................. Set experimental session
while 1
   exppart = str2num(input('Part 1, 2, 3 or 4? (only part 3 to be run inside scanner)? ','s'));
    if isempty(exppart) || ~any(exppart==[1 2 3 4]);
       fprintf('\n *** ERROR *** Please enter 1, 2, 3 or 4:\n\t 1 (part 1 is instrumental training, always outside scanner)\n\t 2 (part 2 is Pavlovian training) and \n\t 3 (part 3 PIT, can be in scanner)\n\t (part 4 contains only the query trials outside the scanner)')
    else break;
    end
end
%.................. Ensure we know which version we're running
while 0
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
    
    % ............... Setup
    
    % setup for stimulus presentation sequences and other stuff. We only want to
    % do this the first, time, i.e. when exppart is 1. After that, we want to
    % load the previous settings and data. This is true regardless of whether
    % we're in the scanner for part 3 or not.
    
    expparams;	% set the general experimental parameters
    
    if exppart == 1
        preps;		      % generate new stimulus sequence etc.
    elseif any(exppart == [2 3 4]) % load everything from previous session
        loadandcheckpreviousdata;
    end
    scanning = scan; % if the subject breaks the scanning session and we decide to not scan between exppart 2 and 3

    
    setdevicetype;  % set device type; this may change between parts
    setup;			% setup display, stimulus coordinates, load images etc.
    
    if psychophys
        getParPortInfo;
        initialize_parport; %initialize the parallel port for psychophys
        subject.parportaddress = 'D010'; %main computer in the eye-tracking room
    end

    
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
        sparport.parportcodes.expstart = 1; %parport code marking start of experiment
        if doinstr; instrpitapproach; end
        T.instrpitapproach=toc;
        
        %.............. Instrumental training ......................................
        tic;
        dobreak = 0;
        sparport.parportcodes.startp1 = 11; %send parport marking start of P1 trials
        for nt = 1:Z.Ntrain
            pittraining;
            if dobreak; break; end	% if criterion reached, end instrumental training
        end
        sparport.parportcodes.endp1 = 12; %send parport marking end of P1 trials
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
        
%         %.............. Pavlovian refresher instructions ..........................
%         tic;
%         if doinstr; instrpavscanner; end
%         T.instrpav=toc;
        
        %................ Pavlovian training .......................................
        tic;
        sparport.parportcodes.startp2 = 21; %parport code marking start of P2 trials
        for np = 1:Z.Npav;	
            pavlov;				
        end			
        sparport.parportcodes.endp2 = 22; %parport code marking end of P2 trials
        T.pavapproach=toc;
        
     
        %we are not scanning part 2
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
        fprintf('............. PIT session \n');
        % save everything at the outset
        if dosave; eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat']);end
        T.tmp=GetSecs;	% to measure length of experiment part
        
        tic
        if doinstr; instrpitstart; end
        T.instrpit=toc;
        
        %................ wait for scanner trigger.................................
        if scanning
            DrawFormattedText(wd,'We are about to start...','center', 'center', txtcolor);
            Screen('Flip',wd);
            if strcmp(exploc,'p')
                T.fMRI_triggerT0_pit = WaitForMRITrigger(MRITriggerCode, NumInitialfMRITriggers, Display);
            else
                T.fMRI_triggerT0_pit = WaitForMRITrigger(MRITriggerCode, NumInitialfMRITriggers, Display);
            end
            drawfixationcross(wd,2,fixationdotsize,0); % Draw central fixation point
            Screen('Flip',wd);
            WaitSecs(10);
        end
        
        %................ PIT ......................................................
        tic;
        sparport.parportcodes.startp3 = 31; %parport code marking start of P3 trials
        for npit = 1:Z.Npit
            pit;
        end
        sparport.parportcodes.endp3 = 32; %parport code marking end of P3 trials
        T.pitapproach=toc;
        
        % acquire some final volumes until end of HRF
        if scanning
            fprintf('\nAcquiring final volumes\n');
            drawfixationcross(wd,2,fixationdotsize,0);
            Screen('Flip',wd);
            if strcmp(exploc,'p')
                T.fMRI_triggerTend_pit = WaitForMRITrigger(MRITriggerCode,NumFinalfMRITriggers);
            else
                T.fMRI_triggerTend_pit = WaitForMRITrigger(MRITriggerCode,NumFinalfMRITriggers);
            end
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
        sparport.parportcodes.startp4 = 41; %parport code marking start of P4 trials
        for npp = 1:Z.Nquerypav
            comparesequential;
        end
        sparport.parportcodes.endp4 = 42; %parport code marking end of P4 trials
        T.querypav=toc;

        %.............. payment ....................................................
        if payment
           payoutinstr		= 0.25*((sum(crt==1) + sum(cr==1)) - (sum(crt==0) + sum(cr==0))); %25 cents for every correct response on instrumental
            payoutpav		= Z.Pavout(mpresp(mpresp<6)); %identifies Pav value associated with each PIT trial
            payoutpavtrials = rand(1,sum(mpresp<6))>.5;	% coin toss on each PIT trial
            %earned          = payoutinstr+sum(payoutpav(payoutpavtrials));
            earned          = payoutinstr;
            payout			= round(100*max(min(maxpayout,earned),minpayout))/100;
            
            fprintf('\n******************************\n')
            fprintf('\t\tPayout: %g Dollars\n',payout);
            fprintf('\n******************************\n')
            WaitSecs(7);
        end
        
        displaytext({'The experiment is now over. Thank you.'},wd,wdw,wdh,txtcolor,0,1);
        
        subject.parportcodes.endexperiment = 2; %parpart code marking end of experiment
        
        T.exppart4 = GetSecs-T.tmp;
    end
    
    %.............. save all in two separate files .............................
   
    if dosave; eval(['save data/' namestring  '_exppart' num2str(exppart) '.mat']);end
    if dosave; eval(['save data/' namestring2 '_exppart' num2str(exppart) '.mat']);end
    
    ListenChar(0);
    
    % ONLY WINDOWS
    if strcmpi(exploc,'b') & scanning==1; ShowHideWinTaskbarMex(1); end
    if strcmpi(exploc,'p') & scanning==1; ShowHideWinTaskbarMex(1); end
    if strcmpi(exploc,'p') & scanning==0; ShowHideWinTaskbarMex(1); end
    
   
    ShowCursor;
    Screen('CloseAll');
    
% process individual data
preprocessindividualdata;

diary off;
