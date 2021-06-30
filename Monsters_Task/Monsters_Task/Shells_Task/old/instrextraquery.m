fprintf('............ Displaying instructions \n');
i=0; clear tx ypos func;
func{1}=[];

i=i+1; 
	ypos{i}=yposm;
	tx{i}='There is no money to be made or lost in this last part of the experiment.';
    %tx{i}='In diesem, letzten, Teil des Experiments können Sie kein Geld mehr gewinnen oder verlieren.';

i=i+1; 
	ypos{i}=yposm;
	tx{i}='We would like to ask you to choose between two images again. One of the pictures will be of a drink, the other will be one of the pictures you just saw.';
    %tx{i}='Wir möchten Sie jetzt noch einmal bitten, zwischen zwei Bildern auszuwählen. Eines der Bilder wird ein Getränk darstellen, das andere die Bilder, die sie gerade gesehen haben.';

i=i+1; 
	ypos{i}=yposm;
    tx{i}='Please choose the image that you prefer, for whatever reason. The colorful pictures no longer lead to you making or losing money.';
	%tx{i}='Wählen Sie bitte dasjenige Bild, das Ihnen mehr zusagt - in welcher Weise auch immer. Die bunten Bilder führen nicht mehr zu Gewinn oder Verlust.';

i=i+1; 
	ypos{i}=yposm;
	tx{i}='Once again, the left arrow key selects the first picture, and the right arrow key selects the second picture.';
    %tx{i}='Die linke Pfeiltaste wählt wiederum das erste Bild, die rechte Pfeiltaste das zweite Bild.';

i=i+1; 
	ypos{i}=yposm;
	tx{i}='Please briefly explain to the research assistant what this part of the experiment is about.';
    %tx{i}='Erklären Sie bitte kurz dem Versuchsleiter, worum es jetzt geht.';
	func{i}='checkunderstood';

instr_display;

for k=1:5
	text={['The next part of the experiment starts in ' num2str(6-k) ' seconds.']};
    %text={['Der nächste Teil des Experiments fängt in ' num2str(6-k) ' Sekunden an.']};
		displaytext(text,wd,wdw,wdh,txtcolor,0,0);
		WaitSecs(1);
end
display('done')
