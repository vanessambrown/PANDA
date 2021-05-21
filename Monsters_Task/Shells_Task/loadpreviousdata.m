fprintf('Data file please\nChoose the one starting with the date, NOT the one called ''subject_xxxx''');

% data we'll check fits between current modifyme.m file and loaded file
tmpsc = exppart; 
tmpsubjn = subjn; 
tmpsession = session; 
tmptype = type; 

% ............ load data 
uiopen('load'); 

% ............ First check the subject name, session and type match 
if ~strcmpi(subjn,tmpsubjn) | ~strcmpi(session,tmpsession) | ~strcmpi(type,tmptype)
	error(['Subject information is incorrect. Please check you''re running the coirrect subjet (check modifyme.m and loaded data file match.']);
end

% ............ Check we've loaded the previous experiment part 
if exppart~=(tmpsc-1); 
	error(['Trying to run part' num2str(tmpsc) ', ' ...
			 'so expecting data for part' num2str(tmpsc-1) ', ' ...
			 'but data loaded is for part ' num2str(exppart) ...
			 '.  Please check.']); 
else
	exppart = tmpsc; 
	clear tmpsc;
end


