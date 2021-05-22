fprintf('............ Pavlovian refresher instructions');
i = 0;
clear tx ypos func;

func{1}=[];

i=i+1;
	ypos{i}=yposm;
    tx{i}= 'It''s time to start. But first, please briefly explain to the research assistant what this part of the task is about.';
    func{i}='checkunderstood';
instr_display;

for k=1:5
	text={['The next part of the experiment starts in ' num2str(6-k) ' seconds.']};
		displaytext(text,wd,wdw,wdh,txtcolor,0,0);
		WaitSecs(1);
end

display('done')
