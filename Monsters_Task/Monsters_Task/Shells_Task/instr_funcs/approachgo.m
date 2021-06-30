
tdrm  = drm ; tdrm (:,[2 4]) = tdrm (:,[2 4])+0.1*wdh;
tdrmd = drmd; tdrmd(:,2)     = tdrmd(:,2)+0.1*wdh;



% draw a blue / black dot
% if ~strcmpi(devicetype,'joystick')
%     
%     % draw the mushroom in the given position given by lrt
%     Screen('DrawTexture',wd,msh(Nmsh+1),[],tdrm(1,:));
%     
%     % draw box
%     tmp = [tdrm(1,[1 3 3 1]); tdrm(1,[2 2 4 4])];
%     bluebox = [tmp(:,1:2) tmp(:,2:3) tmp(:,3:4) tmp(:,[4 1])];
%     Screen('DrawLines',wd,bluebox,3,blue);
%     
%     dotpos = [tdrmd(2,1); tdrmd(2,2)];
%     Screen('gluDisk',wd,1,dotpos(1),dotpos(2),dotsize+2);
%     Screen('gluDisk',wd,blue,dotpos(1),dotpos(2),dotsize);
%     Screen('gluDisk',wd,0,dotpos(1),dotpos(2),dotsize/2);
% end

getleftrightarrow;

