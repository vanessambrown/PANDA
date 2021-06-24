%initialize parallel port
global parport parportstatus

try
    parport = io64();
    parportstatus = io64(parport);
    if parportstatus ~= 0
        tolog('Opening parallel port failed with exit code: %d\n', parportstatus);
    end
catch
    parport = []; %use isempty calls downstream
    parportstatus = 1; %failure
    tolog('Unable to initialize connection with parallel port driver using io64.\n\n');
end