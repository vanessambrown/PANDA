[foo, foo, key ] = KbCheck;
if strcmpi(KbName(key),abortkey) %abortkey is q
	aborted=1; 
	Screen('Fillrect',wd,ones(1,3)*100);
	text='Aborting experiment';col=red;
	displaycentraltxt; 

	ListenChar(0);
	Screen('CloseAll');
	ShowCursor;

	error('Pressed abort key--- aborting experiment')
end
