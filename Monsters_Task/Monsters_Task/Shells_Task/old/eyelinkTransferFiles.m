try
	DirectoryTarget = 'c:\EyeLink';

	FlagError = 0;

	if(~exist(DirectoryTarget, 'dir'))
		if(~mkdir(DirectoryTarget))
			FlagError = 1;
			
			disp('=== Could not create Eye data directory!');
			disp('=== NO DATA FILE WILL BE TRANSFERED!');
		end
	end

	if(~exist(fullfile(DirectoryTarget, 'edf2asc.exe'), 'file'))
		if(~copyfile('edf2asc.exe', DirectoryTarget))
			disp('=== Could not copy EDF2ASC file!');
			disp('=== It is fine. You can do the conversion later!');
		end
	end

	if(~FlagError)
		fprintf('Transfering Eye Data! Please wait...\n');
		for CountEDFFile = 1:length(EyeLinkEDFFileList)
			fprintf('Receiving data file ''%s''\n', EyeLinkEDFFileList{CountEDFFile});

			if(~Eyelink('IsConnected'))
				Eyelink('Initialize');
			end

			status = Eyelink('ReceiveFile', ...
				EyeLinkEDFFileList{CountEDFFile}, ...
				fullfile(DirectoryTarget, EyeLinkEDFFileList{CountEDFFile}));
% 				if status > 0
% 				fprintf('ReceiveFile status %d\n', status);
% 				end
		end
		fprintf('Done!');

		for CountEDFFile = 1:length(EyeLinkEDFFileList)
			fprintf('Converting data file ''%s''\n', EyeLinkEDFFileList{CountEDFFile});

			[TempDosA, TempDosB] = dos([fullfile(DirectoryTarget, 'edf2asc') ' ' fullfile(DirectoryTarget, EyeLinkEDFFileList{CountEDFFile})]);
		end
		fprintf('Done!\n');

		movefile(fullfile(DirectoryTarget, '*.edf'), fullfile('data'))
		movefile(fullfile(DirectoryTarget, '*.asc'), fullfile('data'))

		fprintf('Done!\n');

		fprintf('Data file(s) can be found in ''data'' directory!\n');
	end

catch 

	fprintf('Problem processing data file ''%s''\n', EyeLinkEDFFileList{CountEDFFile});
	disp(lasterror);

end

Eyelink('Shutdown');
