fprintf('............ Displaying end of inside scanner part \n');
i=0; clear tx ypos func;
func{1}=[];

i=i+1; 
	ypos{i}=yposm;
	tx{i}='Thank you. The second part of the experiment is now over. At the end of the day, your current balance will be combined with what you earn in the following parts. We will start the next part of the experiment soon.  You can now relax for a few moments.'; 
	%tx{i}='Vielen Dank. Der zweite Teil des Experiments ist nun beendet. Ihr jetziges Guthaben wird am Ende mit dem, was Sie in den folgenden Teilen erarbeiten, zusammengelegt. Wir werden nden nächsten Teil des Experimentes bald starten. Bitte bleiben Sie möglichst ruhig liegen, Sie können sich aber einige Momente entspannen.'; 

page	= 1;
DrawFormattedText(wd,tx{page},'center',ypos{page},txtcolor,60,[],[],2);
Screen('Flip',wd);
WaitSecs(5);

display('done');
