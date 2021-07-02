fprintf('............ Displaying instructions ');
i=0; clear tx ypos func;
func{1}=[];

if shrooms
    obj='Shells'; 
else
    obj='monsters';
end

i=i+1;
ypos{i}=yposm;
if shrooms
    tx{i}=['Ok, now comes the most important part. You will now go back to collecting ' obj ' .'];
else
    tx{i}=['Ok, now comes the most important part of the task. Imagine that you are on your journey again when you reencounter the monsters.'];
end

i=i+1;
ypos{i}=yposm;
    if shrooms
        tx{i}=['Keep collecting the ' obj ' that were good and leave the bad ones behind. You will continue to receive 20 cents each for this.'];    
    else
        tx{i}=['Decide whether to run away or hide from each monster, just like before. Keep choosing whichever action has helped you escape that monster in the past.'];
    end

i=i+1;
ypos{i}=yposm;
tx{i}='This time, the monsters you encounter will be inside one of the magic caves you saw earlier. The magic cave will be in the background each time you see a monster.';

i=i+1;
ypos{i}=yposm;
tx{i}='You have learned that each cave is associated with either a certain amount of money or nothing at all. When you see a cave in the background, please imagine what that cave is associated with.';

i=i+1;
ypos{i}=yposm;
tx{i}='The monetary value associated with each cave will be credited or deducted randomly half the time. So for example, if you see a cave in the background that is associated with a gain of 1 dollar, then you win 1 dollar in half the cases. \n\n If you see a cave in the background that is associated with a loss of 1 dollar, then half of the time you will lose 1 dollar.';

i=i+1;
ypos{i}=yposm;
tx{i}='This is done automatically by the computer without any action on your part.';

i=i+1;
ypos{i}=yposm;
if shrooms
    tx{i}='So focus on making as much money as possible by collecting shells properly.';
else
    tx{i}='Your focus should be on choosing the action that helps you avoid each monster.';
end

i=i+1;
ypos{i}=yposm;
if shrooms
    tx{i}='How much you win or lose in each round, be it because of the abstract shape in the background or because of the shell, is no longer displayed. Your total balance at the end of the experiment will be paid out to you.';
else
    tx{i}='There is one other important difference in this part of the task. Sometimes, you may not see whether you got caught or escaped in each round. However, the computer will continue to track your performance, so just keep choosing the action that you think will help you escape the monster.';
end

i=i+1;
ypos{i}=yposm;

if shrooms
    tx{i}=['You have ' num2str(round(nogodelay_pit*10)/10) ' seconds to collect or leave a shell. Press the forward button to begin.'];
else
    tx{i}=['You have ' num2str(round(nogodelay_pit*10)/10) ' seconds to either hide or run away. The research assistant will start the task now.']
    func{i}='checkunderstood';
end

instr_display;

for k=1:5
    text={['The next part of the experiment starts in ' num2str(6-k) ' seconds.']};
    displaytext(text,wd,wdw,wdh,txtcolor,0,0);
    WaitSecs(1);
end
fprintf('............ end of instructions ');
