% =========================================================================
% PAVLOV ==================================================================

% TrialNumber, StimulusOnset, pavpres, pavpres Count, pavout

IndixTrialNumber	= 1;
IndixStimulusOnset	= 2;
IndixPavPres		= 3;
IndixPavPresCount	= 4;
IndixPavOut			= 5;

Data = NaN(Z.Npav, 5);

CountPavPres = zeros(1, Z.Nps);

Data(:, IndixTrialNumber) = 1:Z.Npav;
Data(:, IndixStimulusOnset)	= stim_trig(stim_trig(:, 3) == pav_on, 1);
if(size(pavpres, 1) < size(pavpres, 2))
	pavpres = pavpres';
end
Data(:, IndixPavPres) = pavpres(1:Z.Npav);
if(size(pavout, 1) < size(pavout, 2))
	pavout = pavout';
end
Data(:, IndixPavOut) = pavout(1:Z.Npav);

for CountTrial = 1:Z.Npav
	TempPavPres = pavpres(CountTrial);
	CountPavPres(TempPavPres) = CountPavPres(TempPavPres) + 1;
	Data(CountTrial, IndixPavPresCount) = CountPavPres(TempPavPres);
end
