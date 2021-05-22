function Result = WaitForMRITrigger(NumberOfTriggers, Display)

if(nargin < 2)
	Display = [];
end

Result				= nan(1, NumberOfTriggers);
CountTriggerInput	= 0;

while (CountTriggerInput < NumberOfTriggers)
    [joy_pos, buttons] = mat_joy(0); 
    secs=GetSecs;
	if buttons(2)==1
        
		CountTriggerInput = CountTriggerInput + 1;
		
		if ((~isempty(Display)) && (CountTriggerInput == 1))
			drawfixationcross(Display.wd, 2, Display.fixationdotsize,0);
			Screen('Flip',Display.wd); 

			disp('First Trigger Received!');
		end
			
		Result(CountTriggerInput) = secs;
		
		while buttons(2)==1
			[joy_pos, buttons] = mat_joy(0);
		end
	end
end
