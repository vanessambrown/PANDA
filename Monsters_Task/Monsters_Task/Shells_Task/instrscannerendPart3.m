fprintf('............ Displaying end of inside scanner part \n');
i=0; clear tx ypos func;
func{1}=[];

i=i+1; 
	ypos{i}=yposm;
	tx{i}='Thank you. The third part of the experiment is now over. At the end of the day, your current balance will be combined with what you earn in the fourth part outside of the scanner. You can now relax for a few moments.'; 

page	= 1;
DrawFormattedText(wd,tx{page},'center',ypos{page},txtcolor,60,[],[],2);
Screen('Flip',wd);
WaitSecs(5);

display('done');
