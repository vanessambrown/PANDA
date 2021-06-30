function [ResponseKeyCode, TimeofResponse, ResponseDuration] = GetSpecialKey(TargetResponseKey, Delay, FlagWaitTillRelease)
% This function is to get special characters while skipping others
% TargetResponseKey is the list of desired input characters. The list 
% should be entered as a matrix of cells. for example the command below is 
% calling GetSpecialKey function with three specified chars 'j', 'k' and 
% 'space' char.
% GetSpecialKey([{'j'}, {'k'}, {'space'}])
% The second input variable is Delay. This variable defines the waiting
% period of the function. The GetSpecialKey function will at most waits for
% Delay seconds if this optional variable is defined. If not, Delay is
% supposed to be 10 seconds.
% The outputs of the function are two ResponseKeyCode and TimeofResponse
% which are the number of the entered key and the response time of the
% subject from the beginning of calling this function, respectively.
% ResponseKeyCode and TimeofResponse would be zero if no key is pressed
% before the time lapse. For the example above, the 'j', 'k' and 'space'
% keys are numbered as 1, 2 and 3 respectively.

t = GetSecs;

if(nargin < 3)
	FlagWaitTillRelease = 0;
end

if((nargin < 2) || (isempty(Delay)))
	Delay = Inf;
end

TargetResponseKeyCode = KbName(TargetResponseKey);
while(FlagWaitTillRelease == 1)
	[touch, secs, keyCode] = KbCheck;
	if(~any(keyCode(TargetResponseKeyCode)))
		break;
	end
end

if(Delay < 0)
	ResponseKeyCode = 0;
	ResponseDuration = 0;
else
	Response = 0;
	
	while(Response == 0)
		[touch, secs, keyCode] = KbCheck;
		TimeofResponse		= secs;
		ResponseDuration	= TimeofResponse - t;
		
		if(ResponseDuration > Delay)
			ResponseKeyCode = 0;
			ResponseDuration = 0;
			
			break;
		end
		
		if(touch == 1)
			TempKeyNameAll = KbName(keyCode);
			if(iscell(TempKeyNameAll))
				TempTotalInputChar = length(TempKeyNameAll);
			else
				TempTotalInputChar = 1;
			end
			
			for CountKeyname = 1:TempTotalInputChar
				if(iscell(TempKeyNameAll))
					TempKeyNameSingle = TempKeyNameAll{CountKeyname};
				else
					TempKeyNameSingle = TempKeyNameAll;
				end
				
				if((TempKeyNameSingle(1) >= '0') && (TempKeyNameSingle(1) <= '9'))
					TempKeyNameSingle = TempKeyNameSingle(1);
				end
				
				TempStrCompare = strcmpi(TargetResponseKey, TempKeyNameSingle);
				if(any(TempStrCompare))
					Response = 1;
					ResponseKeyCode = find(TempStrCompare);
				end
			end
		end
	end
end
