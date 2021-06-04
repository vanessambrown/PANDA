%----------------------------------------------------------------------------
%        MAIN FILE TO EDIT
%
%        This is the *ONLY* file that should ever be changed
%
%        It *CANNOT* be changed between parts of the experiment
%        (changes will be overwritten by settings from part 1)
%
%----------------------------------------------------------------------------
fprintf('............ Setting basic parameters according to \n')
fprintf('............            MODIFYME.M\n'); fprintf('............ \n')

%----------------------------------------------------------------------------
%        Patient Information 
%----------------------------------------------------------------------------
subjn    = '555555';  % Subject ID. This number has to be > 1000 
                    % *** subject number has to be in single quotes ***
dominanthand     = 'left';     % 'right' or 'left' % for "left" this did not work

%----------------------------------------------------------------------------
%        Is the third part inside the fMRI scanner? 
%          Set this to one for when the third part is inside the scanner
%----------------------------------------------------------------------------
scanning = 1;  % 0 = entirely outside scanner %set scanning to 0/1
               % 1 = third part inside scanner 

%---------------------------------------------------------------------------

debug   = 0;      % if this is set to 1, then a short version of the experiment is
                  % run. For testing/debugging. 
doinstr = 1;      % present instructions?

%----------------------------------------------------------------------------
%        To save or not to save
%        This should ALWAYS be set to 1 when doing experiments obviously
%----------------------------------------------------------------------------
dosave = 1;         % save output? 
                                     

%----------------------------------------------------------------------------
%        LEAVE THESE ALONE
%----------------------------------------------------------------------------
approach = 0; 	% withdrawal variant
exploc   = 'p';     % 'p' for pittsburgh, 'b' for berlin
PIT_version = 2;    % version 1 -> shells, version 2 -> monsters
session  = '1';     
payment  = 1;       % is this subject being paid / should payment info be displayed
                    % at the end? 

                    
%----------------------------------------------------------------------------
%        Input device type  
% 			Device can be: 'keyboard', 'nnl', 'lumitouch',
% 			'currentdesigns', currentdesignsoffMRT,
% 			or 'joystick' or 'cur_joystick'
%			in part 3, it should always be 'keyboard'
%----------------------------------------------------------------------------
devicetype_part1 = 'keyboard'; %'cur_joystick';  
devicetype_part2 = 'keyboard'; %'cur_joystick';  
if scanning == 1
    devicetype_part3 = 'MRRC'; 
    else
    devicetype_part3 = 'keyboard';
end
devicetype_part4 = 'keyboard';	

%----------------------------------------------------------------------------
%        EXPERIMENT VERSION 
%        PLEASE check this is correct! 
%----------------------------------------------------------------------------
expversion = '05.21.2021.01';

%----------------------------------------------------------------------------
%        MONITOR SIZE  and VIEWING DISTANCE 
%         if use eye tracking in Berlin , then this ABSOLUTELY needs to be checked. 
%----------------------------------------- -----------------------------------

if strcmpi(exploc,'p') % ????? are these values correct for Dresden ??
    monitor_size_xmm = 310;      % width of screen in millimitres
    monitor_size_ymm = 174;      % height of screen in millimitres
    viewing_dist     = 530;      % viewing distance in millimitres
elseif strcmpi(exploc,'b')
    monitor_size_xmm = 240;      % width of screen in millimitres
    monitor_size_ymm = 182;      % height of screen in millimitres
    viewing_dist     = 690;      % viewing distance in millimitres
end