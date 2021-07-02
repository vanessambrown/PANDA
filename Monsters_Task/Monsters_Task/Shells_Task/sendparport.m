function sendparport(code, address, durationsecs)
global parport parportstatus sparport;

if nargin < 2
    try
        address = sparport.parportaddress;
    catch
        error('Parallel port address not passed to sendparport');
    end
end

if nargin < 3 
    try
        durationsecs = sparport.parportduration;
    catch
        durationsecs = -1;
    end
end

%exit if parallel port connection cannot be established
if parportstatus ~= 0
    return
end

address = hex2dec(address);
io64(parport, address, code); %send code
if durationsecs > -1, WaitSecs(durationsecs); end %wait briefly to reset port
io64(parport, address, 0); %reset port

end
