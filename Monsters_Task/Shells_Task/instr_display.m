if length(func) < i
	func{i}=[]; 
end

%if length(selectiontask) < i
%	selectiontask{i}=[]; 
%end


Pages	= i;
page	= 1;
while 1 
	DrawFormattedText(wd,tx{page},'center',ypos{page},txtcolor,60,[],[],2);
	if ~isempty(func{page});
		eval(func{page}); % must contain 'getleftrightarrow' command 
	else
		getleftrightarrow;
	end
	
	if page > Pages
		break;
	end
end
