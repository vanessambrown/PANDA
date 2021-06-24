
i=0; clear tx ypos func;
func{1}=[];

i = i+1;;
	ypos{i}=wdh*0.35;
    tx{i} = 'Please look carefully at this point when it is shown in the next part of the experiment.';
	%tx{i} = 'Bitte schauen Sie im folgenden Teil des Experiments immer genau auf diesen Punkt wenn er gezeigt wird.';
	func{i} = 'drawfixationcross(wd,2,fixationdotsize,0); getleftrightarrow;';

i = i+1;
	ypos{i}=wdh*0.35;
	tx{i} = 'You do not need to pay attention to these crosses in the following.';
    %tx{i} = 'Diese Kreuze brauchen Sie im Folgenden nicht weiter zu beachten.';
	func{i} = 'for k=[1 3]; drawfixationcross(wd,k,fixationdotsize,1);end; getleftrightarrow;';
	instr_display;
