%----------------------------------------------------------------------------
%			Set up Eyelink eye tracker for Dresden outside scanner 
%----------------------------------------------------------------------------

% Calibrate the eye tracker
EyelinkDoTrackerSetup(el);

% do a final check of calibration using driftcorrection
% EyelinkDoDriftCorrection(el);

% open file to record data to
block = block + 1; % update block for saving
edfFile = [num2str(subjn) '_' num2str(block)];
EyeLinkEDFFileList(end + 1) = {[edfFile '.edf']};
Eyelink('Openfile', edfFile);

% start recording eye position
Eyelink('StartRecording');

% record a few samples before we actually start displaying
WaitSecs(1);

% mark zero-plot time in data file
Eyelink('Message', 'SYNCTIME');
