if strcmpi(exploc,'b') & scanning == 1 & exppart == 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Eyetracking calibration SMI for scanner
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % stop recording
    calllib('iViewXAPI', 'iV_StopRecording');
    
    % save recorded data
    block = block + 1; % update block for saving 
    user = formatString(64, int8(strcat([num2str(subjn) '_' num2str(block)])));
    description = formatString(64, int8('Description1'));
    ovr = int32(1);
    filename = formatString(256, int8(['C:\FOR\' user '.idf'])); %CHECK!
    calllib('iViewXAPI', 'iV_SaveData', filename, description, user, ovr)
    
elseif strcmpi(exploc,'b') 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Eyetracking calibration outside scanner in Berlin
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    block = block + 1; % update block for saving 
    vetStopTracking;    % stops eye tracking

    vetDestroyCameraScreen;
    vetDestroyMimicScreen;

    vetSaveResults(eyetrack_results_mat, ...
            CRS.ffMATfile);   % save eyetracking data as mat-file

    %vetSaveResults(eyetrack_results_csv, ...
    %        CRS.ffSemiColonDelimitedNumeric); % save eyetracking data as csv-file

    save(stim_trig_results,'stim_trig');    % save stimulus trigger
    
end
