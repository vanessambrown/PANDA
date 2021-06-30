
mprestest = [1 1 2 2 1 2 1 2];
lrtest =    [1 3 3 1 1 3 3 1]; lrtest=[lrtest;4-lrtest];
crtestfb = ones(1,8);
ainstest = mprestest;

approachtest=0;
for ntest=1:length(mprestest);
	pittraining_test;
end
getleftrightarrow;

