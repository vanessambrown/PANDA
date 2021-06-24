%----------------------------------------------------------------------------
%        MAIN FILE TO EDIT
%
%        This is the *ONLY* file that should ever by changed
%
%        It *CANNOT* be changed between parts of the experiment
%        (changes will be overwritten by settings from part 1)
%
%----------------------------------------------------------------------------
fprintf('............ Setting basic parameters according to \n')
fprintf('............            MODIFYME.M\n'); fprintf('............ \n')

debug   = 1;      % if this is set to 1, then a short version of the experiment is
                  % run. For testing/debugging. 
doinstr = 1;      % present instructions?

do_select_alc=1;    % should alcohol stimulus be selected by participant?
do_select_smoke=1;  % should smoking stimulus be selected by participant?

%----------------------------------------------------------------------------
%        To save or not to save
%        This should ALWAYS be set to 1 when doing experiments obviously
%----------------------------------------------------------------------------
dosave = 1;         % save output? 

%----------------------------------------------------------------------------
%        Patient Information 
%----------------------------------------------------------------------------
subjn    = '9990';  % Subject ID. This number has to be > 1000 
                    % *** subject number has to be in single quotes ***
dominanthand     = 'right';     % 'right' or 'left'
stress_intervention = 'n';  % 's' -> stress intervention; 'c' -> control intervention'; 'n' -> no intervention (WP1a)
PIT_version = 1;    % version 1 -> original version with shells, version 2 -> leaves
type     = 'P';     % 'C' for controls, and 'P' for patients 
session  = '1';     % Which session (first time, or follow-up?)
exploc   = 'd';     % 'b' for berlin, 'd' for dresden 
payment  = 1;       % is this subject being paid / should payment info be displayed
                    % at the end? 

                    % project  = '1a';     % Project ID - either '1a' for chronic stress experiment or '1b' for acute stress experiment 
% name     = 'MS';    % Subject name *** name has to be in single quotes ***
% age      = 34 ;      % subject's age in years 
% sex      = 'f';     % subject's sex; 'm' = male; 'f' = female
%                     % please make sure this is a string, i.e. in single quotes

%----------------------------------------------------------------------------
%        Input device type  
% 			Device can be: 'keyboard', 'nnl', 'lumitouch',
% 			'currentdesigns', currentdesignsoffMRT,
% 			or 'joystick' or 'cur_joystick'
%			in part 3, it shoudl always be 'keyboard'
%----------------------------------------------------------------------------
devicetype_part1 = 'cur_joystick';  
devicetype_part2 = 'cur_joystick';  
devicetype_part3 = 'cur_joystick';
devicetype_part4 = 'cur_joystick';		% part 3 should ALWAYS be 'keyboard' 


%----------------------------------------------------------------------------
%        Is the third part inside the fMRI scanner? 
%          Set this to one for when the third part is inside the scanner
%----------------------------------------------------------------------------
scanning = 0;  % 0 = entirely outside scanner 
               % 1 = third part inside scanner

%----------------------------------------------------------------------------
%        Preferred drink 
%
%         1 = Bier                 2 = Weizen      
%         3 = Brauner schnaps      4 = Weisser schnaps   
%         5 = Weisswein            6 = Rotwein      
%         7 = Sekt      
%----------------------------------------------------------------------------
drink   = 1;

%----------------------------------------------------------------------------
%        EXPERIMENT VERSION 
%        PLEASE check this is correct! 
%----------------------------------------------------------------------------
expversion = '8.01.200220';

%----------------------------------------------------------------------------
%        MONITOR SIZE  and VIEWING DISTANCE 
%         if use eye tracking in Berlin , then this ABSOLUTELY needs to be checked. 
%----------------------------------------------------------------------------

if strcmpi(exploc,'d') % ????? stimmen diese Werte für Dresden ??
    monitor_size_xmm = 340;      % width of screen in millimitres
    monitor_size_ymm = 260;      % height of screen in millimitres
    viewing_dist     = 470;      % viewing distance in millimitres
elseif strcmpi(exploc,'b')
    monitor_size_xmm = 240;      % width of screen in millimitres
    monitor_size_ymm = 182;      % height of screen in millimitres
    viewing_dist     = 690;      % viewing distance in millimitres
end
