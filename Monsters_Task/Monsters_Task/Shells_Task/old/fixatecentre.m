% Draw central fixation point and check that gaze is within small area around
% it. The protocol is to wait for fixation for "gazewait" seconds. Then:
%
%  failure to fixate 1:  nothing happens
%  failure to fixate 2:  reminder
%  failure to fixate 3:  reminder
%  failure to fixate 4:  turn of fixation check for 1st half
%  half of the trials over: recalibrate
%  failure to fixate 5:  nothing happens
%  failure to fixate 6:  reminder
%  failure to fixate 7:  reminder
%  failure to fixate 8:  turn of fixation check for good
%
% The number of failures to fixate is counted in the variable "fixationfailure"
%
% If there is no fixation failure, then recalibration happens after 60% of the
% total Pavlovian trials.
%
% These keys can modify the behaviour of this file:
%    e to recalibrate eyetracker
%    p to stop eyetracker for good
% 	esc to terminate experiment
%


% Draw central fixation point
drawfixationcross(wd,2,fixationdotsize,0);
if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end % draw frame
T.pav_fixationonset(np) = Screen('Flip',wd);
t0 = T.pav_fixationonset(np);
stim_trig = UpdateStimulusTrigger(exploc, scanning, exppart, eyetrack, stim_trig, [pav_FC_on np]);

%----------------------------------------------------------------------
% Implement time average:
% check whether gaze was within the fixation box for 'fix_check_interval'
%----------------------------------------------------------------------

fix_check_interval = 60; % in ms
% initialize variables for time average
if strcmpi(exploc,'b');  %....................... Berlin
    if exppart == 2 & scanning==1
        sampling_rate = 50; % sampling rate in Hz
    else
        error('fixatecenter.m is not yet implemented for Berlin outside the scanner');
        % what is the sampling rate here?
        % sampling_rate = ??; % sampling rate in Hz
    end
elseif strcmpi(exploc,'d'); %....................... Dresden
    sampling_rate = 1000; % sampling rate in Hz
end
check_n_samples = round( sampling_rate / 1000 * fix_check_interval ); % (tranform to n samples / ms) (multiply by time average: fixation in box for 50 ms)
fix_in_box = zeros(check_n_samples,1);
samp_cnt = 0;

%----------------------------------------------------------------------

if np==(1+round(Z.Npav*.5)) && fixationcontrol_off~=1
    fixationcontrol = 1;
end

% now check for gaze
FlagExtraITIMessage = 0;
TempExtraTime = 0;
while 1 & fixationcontrol;
    
    % check whether fixation delay is exceeded
    FixationDelayExceeded = (GetSecs-t0) > gazewait;
    if FixationDelayExceeded
        Fixationfailuretrial(fixationfailure+1) = np;
    end
    
    % -----------------------------------------------------------------
    %		Check whether gaze is within fixation area
    % -----------------------------------------------------------------
    if strcmpi(exploc,'b');  %....................... Berlin
        if exppart == 2 & scanning==1
            calllib('iViewXAPI', 'iV_GetSample', pSampleData);
            samp=get(pSampleData,'Value');
            
            % update next sample
            samp_cnt = samp_cnt + 1;
            if samp_cnt > check_n_samples; samp_cnt = 1; end
            % is the gaze in the box?
            if strcmpi(leftRightEye,'right') % leftRightEye % FlagEyeTracking
                fix_in_box(samp_cnt) = ...
                    (samp.rightEye.gazeX < ROI_centre_x + size_ROI_Px) && ...
                    (samp.rightEye.gazeX > ROI_centre_x - size_ROI_Px) && ...
                    (samp.rightEye.gazeY < ROI_centre_y + size_ROI_Px) && ...
                    (samp.rightEye.gazeY > ROI_centre_y - size_ROI_Px);
            elseif strcmpi(leftRightEye,'left') % leftRightEye % FlagEyeTracking
                fix_in_box(samp_cnt) = ...
                    (samp.leftEye.gazeX < ROI_centre_x + size_ROI_Px) && ...
                    (samp.leftEye.gazeX > ROI_centre_x - size_ROI_Px) && ...
                    (samp.leftEye.gazeY < ROI_centre_y + size_ROI_Px) && ...
                    (samp.leftEye.gazeY > ROI_centre_y - size_ROI_Px);
            end
            
        else
            DataEyeTracker=vetgetLatestEyePosition;
            if DataEyeTracker.region==0 && DataEyeTracker.tracked==1; break; end
        end
        
    elseif strcmpi(exploc,'d'); %....................... Dresden
        DataEyeTracker = Eyelink('NewestFloatSample');
        
        Gaze.x = Inf;
        Gaze.y = Inf;
        if (DataEyeTracker.gx(1) >= 0)
            Gaze.x = DataEyeTracker.gx(1);
            Gaze.y = DataEyeTracker.gy(1);
        end
        if (DataEyeTracker.gx(2) >= 0)
            Gaze.x = DataEyeTracker.gx(2);
            Gaze.y = DataEyeTracker.gy(2);
        end
        
        % update next sample
        samp_cnt = samp_cnt + 1;
        if samp_cnt > check_n_samples; samp_cnt = 1; end
        % is the gaze in the box?
        fix_in_box(samp_cnt) = (abs(wdw/2 - Gaze.x) <= EyeLinkBoxHalfLength) && (abs(wdh/2 - Gaze.y) <= EyeLinkBoxHalfLength);
    end
    % if at least 90% of last check_n_samples were in the fixation_box, then accept fixation
    if mean(fix_in_box)>0.9
        break;
    end
    
    % -----------------------------------------------------------------
    %		Display reminder about fixation to subject
    %		after 1st (i.e. on 2nd) and after 3rd (i.e. on 4th) failure
    % -----------------------------------------------------------------
    if FixationDelayExceeded & any(fixationfailure==[1 2  4 5]); % [1 3]
        txt = {'Schauen Sie bitte auf den Punkt'};
        drawFixpointText;
        if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end % draw frame
        T.fixationfailure_reminder_onset(fixationfailure+1) = Screen('Flip',wd);
    end
    if  ((GetSecs-t0) > (gazeremindlength+gazewait)) & any(fixationfailure==[1 2  4 5]) % [1 3]
        fprintf('Reminder displayed, but no fixation achieved in %i seconds\n',gazeremindlength);
        break;
    end
    
    % -----------------------------------------------------------------
    %		Display fixation excess length to experimenter
    % -----------------------------------------------------------------
    
    if (GetSecs - t0) > Z.ITIPav(np)
        if ~FlagExtraITIMessage
            fprintf('Extra ITI (s): 00');
            FlagExtraITIMessage = 1;
        end
        
        if (TempExtraTime ~= floor(GetSecs - t0))
            TempExtraTime = floor(GetSecs - t0);
            fprintf('\b\b%2d', TempExtraTime);
            
            if (TempExtraTime > (gazeremindlength+gazewait))
                break;
            end
        end
    end
    
    % -----------------------------------------------------------------
    % check for keyboard input
    %    e to recalibrate eyetracker
    %    p to stop eyetracker for good
    % 	esc to terminate experiment
    % -----------------------------------------------------------------
    
    [foo, foo, keyCode ] = KbCheck;
    key = KbName(keyCode);
    recalibcause(1) = any(strcmpi(key,'e')); 	% pressed key 'e'
    recalibcause(2) = np==(1+round(Z.Npav*.5)); % after 50% of trials
    
    %  if 1
    %      recalibcause(2) =  np==(1+round(Z.Npav*.5)); % after 50% of trials
    %  else
    %      recalibcause(2) = (np> (1+round(Z.Npav*.5))) && (fixationfailure==4); % ==4 failures & >50% of trials done
    %  end
    %recalibcause(2) = (fixationfailure==3) & FixationDelayExceeded; % third failure - (fixationfailure==2)
    %recalibcause(3) = (fixationfailure<4) & (np>sum(Z.Npav)*.6); % <3
    %failures & >60% of trials done - (fixationfailure<3)
    
    if any(recalibcause)
        if recalibcause(1)
            fprintf('............ Pressed key ''e'' to re-calibrate eye tracker\n');
            fixationcontrol_off = 1;
        elseif recalibcause(2);
            fprintf('............ automatic recalibration after 50% of Pavlovian trials\n');
            fixationfailure=4; % to allow for turning off fixation check after further failures
            automaticrecalibration=1; % but disambiguate this:
        end
        
        txt = {'Kalibrierung folgt'};
        drawFixpointText;
        if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end % draw frame
        T.recalib_onset = Screen('Flip',wd);
        
        WaitSecs(10);
        
        if strcmpi(exploc,'b')
            eyetrackstop;	% stop current eye tracker
            eyetrackcalib;	% recalibrate eye tracker
        elseif strcmpi(exploc,'d')
            Eyelink('Stoprecording');
            Eyelink('CloseFile');
            eyelinkcalib;
        end
        eyetrackT=GetSecs;
        
        %if scanning; T.fMRI_triggerT01r_pav = WaitForMRITrigger(MRITriggerCode, NumInitialfMRITriggers, Display); end
        drawfixationcross(wd,2,fixationdotsize,0); % Draw central fixation point
        if small_screen_berlin_scanning; Screen('FillRect', wd , black, frameBlack ); end % draw frame
        T.recalib_offset = Screen('Flip',wd);
        
        WaitSecs(10);
        
        break;
        
    elseif any(strcmpi(key,'p')) | (fixationfailure==7 & FixationDelayExceeded) | (fixationfailure==3 & FixationDelayExceeded)
        
        if any(strcmpi(key,'p'))
            fprintf('............ Pressed key ''p'' to stop eyetracking for good\n');
            fixationcontrol_off = 1;
        elseif (fixationfailure==3 & FixationDelayExceeded) % fixationfailure==3
            fprintf('............ 4th fixation failure: stopping fixation control for first half \n');
        elseif (fixationfailure==7 & FixationDelayExceeded) % fixationfailure==7
            fprintf('............ 8th fixation failure: stopping fixation control for good\n');
        end
        fixationcontrol = 0;
        
        break;
        
    elseif any(strcmpi(key,abortkey))
        aborted = 1;
        Screen('Fillrect',wd,ones(1,3)*80);
        text='Aborting experiment';
        col=[200 30 0];
        Screen('TextSize',wd,60);
        DrawFormattedText(wd,text,'center','center',col,60);
        ShowCursor;
        error('Pressed abort key --- aborting experiment');
    end
end

if FlagExtraITIMessage
    fprintf('\n');
end

if FixationDelayExceeded
    fixationfailure=fixationfailure+1;
end

T.pav_fixationend(np) = GetSecs;
stim_trig = UpdateStimulusTrigger(exploc, scanning, exppart, eyetrack, stim_trig, [pav_FC_off np]);

