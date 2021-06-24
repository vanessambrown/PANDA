fprintf('............. Displaying instructions \n');
i=0; clear tx ypos func;
func{1}=[];

i=i+1;
ypos{i}=yposm;
if ~scanning
    tx{i}='Welcome to the next part of the task. Please use the arrow keys to scroll forwards and backwards again.';
else
    tx{i}='Welcome to the next part of the task. Please use the arrow keys to scroll forwards and backwards again.';
end

i=i+1;
ypos{i}=ypostt;
tx{i}='Imagine once again that you are on a long journey, when you encounter a series of magic caves. For example, you might see this:';
func{i}='Screen(''Drawtexture'',wd,shapeinstr(1),[],drm(2,:));getleftrightarrow;';

i=i+1;
ypos{i}=ypostt;
tx{i}='or this: ';
func{i}='Screen(''Drawtexture'',wd,shapeinstr(2),[],drm(2,:));getleftrightarrow;';

i=i+1;
ypos{i}=yposm;
tx{i}='Some caves lead to you winning money, others lead to you losing money, and others lead to nothing at all. Try to remember what each cave is associated with, as we will ask you about it later. The monetary amounts you see on the screen will be credited or deducted from you.';

i=i+1;
ypos{i}=yposm;
tx{i}='For now, there''s nothing you can do to earn or lose money. So just memorize what each cave is associated with (winning money, losing money, or nothing at all).';

i=i+1;
ypos{i}=yposm;
tx{i}='Imagine the amount of money associated with each cave when you see the cave on the screen.';

i=i+1;
ypos{i}=yposm;
tx{i}='This part of the experiment takes a long time so that you can accurately memorize what each cave is associated with. Please pay close attention to this part of the experiment.';

i=i+1;
ypos{i}=yposm;
tx{i}= 'It''s time to start. But first, please briefly explain to the research assistant what this part of the task is about.';
func{i}='checkunderstood';

instr_display;

checkabort;
fprintf('.........done\n');
