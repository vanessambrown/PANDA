fprintf('............. Displaying instructions \n');
i=0; clear tx ypos func;
func{1}=[];

i=i+1; 
	ypos{i}=yposm;
    tx{i}='We would like to ask you to do something else now.';
i=i+1; 
	ypos{i}=yposm;
	tx{i}='We will show you two magic caves, one after the other. Please choose the cave that you prefer. ';
    
i=i+1; 
	ypos{i}=yposm;
	tx{i}='To select the first cave, press the left arrow key; to select the second cave, press the right arrow key.';

i=i+1;
	ypos{i}=yposm;
	tx{i}= 'Please briefly explain to the research assistant what this part of the experiment is about.';
	func{i}='checkunderstood';

instr_display;

for k=1:5
	text={['The next part of the experiment starts in ' num2str(6-k) ' seconds.']};
		displaytext(text,wd,wdw,wdh,txtcolor,0,0);
		WaitSecs(1);
end

checkabort;
fprintf('.........done\n');
