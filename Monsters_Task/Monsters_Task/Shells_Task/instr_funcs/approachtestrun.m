
mprestest = [1 1 2 2 1 2 1 2];
lrtest =    [1 3 3 1 1 3 3 1]; lrtest=[lrtest;4-lrtest];
crtestfb = ones(1,8);
ainstest = mprestest;
mprestest=mprestest+2;

if debug; mprestest = mprestest(1:2);end

approachtest=0; %change since we are doing withdrawal
for ntest=1:length(mprestest);
    pittraining_test;
end

if strcmpi(respkey,'joystick')
    DrawFormattedText(wd, ...
        ['Ok, you completed the exercise.'],...
        'center','center',txtcolor,60,[],[],1.3);
            %['Ok, Sie haben die Übung geschafft.'],...
    
end


getleftrightarrow;
