%minimal setup
global parport sparport parportstatus phys;
parport = io64();
parportstatus = io64(parport);
phys=true;

sparport.parportaddress = 'D010'; %main computer in the eye-tracking room
sparport.parportduration = 2;

WaitSecs(10);
for ii=1:10
fprintf('sending 255\n');    %all on
    sendparport(255);
    WaitSecs(2);
end


%%%truly low level approach: http://apps.usd.edu/coglab/psyc770/IO64.html
%this works, but doesn't use internal structure
% address='0378';
% address = hex2dec(address);
% ioObj = io64;
% status = io64(ioObj);
% io64(ioObj,address,15);   %output command
% data_in=io64(ioObj,address);
% clear io64 mex data_in ioObj address