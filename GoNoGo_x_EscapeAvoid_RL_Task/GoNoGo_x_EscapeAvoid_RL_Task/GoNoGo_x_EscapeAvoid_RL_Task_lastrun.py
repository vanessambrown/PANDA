#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy2 Experiment Builder (v1.90.1),
    on Wed May 23 12:25:22 2018
If you publish work using this script please cite the PsychoPy publications:
    Peirce, JW (2007) PsychoPy - Psychophysics software in Python.
        Journal of Neuroscience Methods, 162(1-2), 8-13.
    Peirce, JW (2009) Generating stimuli for neuroscience using PsychoPy.
        Frontiers in Neuroinformatics, 2:10. doi: 10.3389/neuro.11.010.2008
"""

from __future__ import absolute_import, division
from psychopy import locale_setup, sound, gui, visual, core, data, event, logging, clock, parallel
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)
import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle
import os  # handy system and path functions
import sys  # to get file system encoding

# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__)).decode(sys.getfilesystemencoding())
os.chdir(_thisDir)

# Store info about the experiment session
expName = u'GoNoGo_x_EscapeAvoid'  # from the Builder filename that created this script
expInfo = {u'trials_per_cond': u'40', u'session': u'01', u'prac_type': u'random', u'subjnum': u''}
dlg = gui.DlgFromDict(dictionary=expInfo, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
filename = _thisDir + os.sep + u'data' + os.sep + 'GNGxEscapeAvoid_sub_%s_sess_%s_%s' %(expInfo['subjnum'],expInfo['session'], expInfo['date'])

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath=u'/Users/alexmillner/Desktop/GoNoGo_x_EscapeAvoid_RL_Task/GoNoGo_x_EscapeAvoid_RL_Task.psyexp',
    savePickle=True, saveWideText=True,
    dataFileName=filename)
# save a log file for detail verbose info
logFile = logging.LogFile(filename+'.log', level=logging.EXP)
logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file

endExpNow = False  # flag for 'escape' or other condition => quit the exp

# Start Code - component code to be run before the window creation

# Setup the Window
win = visual.Window(
    size=[1920, 1080], fullscr=True, screen=0,
    allowGUI=True, allowStencil=False,
    monitor=u'testMonitor', color=[-1.000,-1.000,-1.000], colorSpace='rgb',
    blendMode='avg', useFBO=True)
# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess

# Initialize components for Routine "startvars"
startvarsClock = core.Clock()
p_port = parallel.ParallelPort(address = 'D010')
from psychopy import sound

#Time in seconds
#Cue duration (feedback will not respond to a key press during cue, but Psychopy will record a key press)
cue_dur = 0
#Target and ITI duration
target_dur = 2
iti_dur = 1

fdbk_dur = 2
#Set to 1 if you want transition to feedback to occur once target has ended
#Set to 2 if you want transition to feedback to occur following a key press (not recommended)
fdbk_aftertarget1_afterpress2 = 1
fdbk_dur_orig = fdbk_dur

#You could shorten the feedback duration for trials without sound 
#as a way to speed up the task (not recommended) Set to 1 to turn this on
if_nosound_skipfdbk = 0
#Duration of no sound feedback in secs
fdbkskipdur = .75
#Show an image during feedback
fdbk_img_on = 1

#available keys (misnamed target key b/c q will advance through the practice during the instructions)
allwd_keys = ['space','q']

#Sound files
#Sound during practice
prac_sound = 'Sounds/fullscrapefork_with2highpitch.wav'
#Different sound clips
sound1 = 'Sounds/fullscrapefork_with2highpitch.wav'
sound2 = 'Sounds/fullscrapefork_with2highpitch_clip2.wav'
sound3 = 'Sounds/fullscrapefork_with2highpitch_clip3.wav'
#File of image during feedback (selected depending on whether sound is playing)
soundimage = 'xxx.png'

#Did sound play during feedback (regardless of correct or incorrect)
#1 - yes, 0 = no
sound_fdbk = 0


pics = ['Pics/Fractals/6.bmp','Pics/Fractals/8.bmp','Pics/Fractals/11.bmp','Pics/Fractals/12.bmp']
trialtypes = ['avoidGo_pic','escapeGo_pic','escapeNoGo_pic','avoidNoGo_pic']

#Now shuffle pictures but make sure left and right do not have the same stim
import random
from random import shuffle

random.shuffle(pics)
random.shuffle(trialtypes)

pic_dict = dict(zip(trialtypes,pics))
main_trlst = os.path.join('TrialLists/', 'GoNoGo_x_EscapeAvoid_%dtrials.xlsx' %(int(expInfo['trials_per_cond'])))
import pandas as pd
import numpy as np
trllst=pd.read_excel(main_trlst)
a=list(range(1,trllst.GroupingOrder.max()+1))
b = list(a)
np.random.shuffle(b)
trllst['randomize'] = np.random.normal(size = trllst.shape[0])
trllst['GroupingOrder'] = trllst.GroupingOrder.replace(dict(zip(a,b)))
trllst.sort_values(['GroupingOrder','randomize'],axis=0,inplace=True)
trllst.reset_index(drop=True,inplace=True)
trllst['TrialNum'] = range(1,trllst.shape[0]+1)

trllst.to_excel(os.path.join('TrialLists/subs_trialLists','GNGxEscapeAvoid_TrialList_sub_%s_%s.xlsx' %(expInfo['subjnum'], expInfo['date'])))
conditions_file = os.path.join('TrialLists/subs_trialLists','GNGxEscapeAvoid_TrialList_sub_%s_%s.xlsx' %(expInfo['subjnum'], expInfo['date']))

#practice
prac_type=expInfo['prac_type']
prac_trlst = os.path.join('TrialLists/', 'TrialList_prac1.xlsx')
prac_trllst=pd.read_excel(prac_trlst)
if prac_type=='random':
 prac_type=np.random.choice(['go','nogo'])
if prac_type=='go':
 prac_trllst.CorrectResp.replace({'nogo':'go'},inplace=True)
prac_trllst.to_excel(os.path.join('TrialLists/subs_prac_trialLists','GNGxEscapeAvoid_PracTrialList_sub_%s_%s.xlsx' %(expInfo['subjnum'], expInfo['date'])))
prac_conditions_file = os.path.join('TrialLists/subs_prac_trialLists','GNGxEscapeAvoid_PracTrialList_sub_%s_%s.xlsx' %(expInfo['subjnum'], expInfo['date']))




# Initialize components for Routine "sound_chk_intro_past"
sound_chk_intro_pastClock = core.Clock()
soundchktxt1 = visual.TextStim(win=win, name='soundchktxt1',
    text='This task involves unpleasant sounds. First, we would like you to rate the unpleasantness of the sound.\n\n\n\n\n\n\nClick the mouse or press the spacebar to listen to the sound and make your rating.',
    font='Arial',
    units='cm', pos=[0, 0], height=1, wrapWidth=30, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);
mouse = event.Mouse(win=win)
x, y = [None, None]

# Initialize components for Routine "sound_chk_rate_past"
sound_chk_rate_pastClock = core.Clock()
sound_chk_txt2_1 = visual.TextStim(win=win, name='sound_chk_txt2_1',
    text='Please rate how unpleasant this sound was.\n\nClick the ratings line to rate and then click the button to complete the rating.',
    font='Arial',
    units='cm', pos=[0, 4], height=1, wrapWidth=30, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

soundcheck_rating = visual.RatingScale(win=win, name='soundcheck_rating', marker='triangle', size=1.9, pos=[0.0, -0.4], low=0, high=1, precision=100, showValue=False, scale='')
sound_chk_txt2_2 = visual.TextStim(win=win, name='sound_chk_txt2_2',
    text='not unpleasant                    a little                  fairly                  very                   extremely                  intolerable',
    font='Arial',
    units='cm', pos=[0, -3], height=.5, wrapWidth=40, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-3.0);

# Initialize components for Routine "sound_chk_intro_current"
sound_chk_intro_currentClock = core.Clock()
soundchktxt1_3 = visual.TextStim(win=win, name='soundchktxt1_3',
    text="Now we're going to ask you to rate the sound again but this time we want you to rate it while the sound is playing. \n\nIt will play for 2 seconds and then you can make your rating.\n\n\n\nClick the mouse or press the spacebar to listen to the sound and make your rating.",
    font='Arial',
    units='cm', pos=[0, 0], height=1, wrapWidth=30, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);
mouse_2 = event.Mouse(win=win)
x, y = [None, None]

# Initialize components for Routine "sound_chk_rate_current"
sound_chk_rate_currentClock = core.Clock()
sound_chk_txt2_4 = visual.TextStim(win=win, name='sound_chk_txt2_4',
    text='Please rate how unpleasant this sound was.',
    font='Arial',
    units='cm', pos=[0, 4], height=1, wrapWidth=30, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

soundcheck_rating_3 = visual.RatingScale(win=win, name='soundcheck_rating_3', marker='triangle', size=1.9, pos=[0.0, -0.4], low=0, high=1, precision=100, showValue=False, scale='')
sound_chk_txt2_3 = visual.TextStim(win=win, name='sound_chk_txt2_3',
    text='not unpleasant                    a little                  fairly                  very                   extremely                  intolerable',
    font='Arial',
    units='cm', pos=[0, -3], height=.5, wrapWidth=40, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-3.0);

# Initialize components for Routine "instructions"
instructionsClock = core.Clock()
InstructionPictures = visual.ImageStim(
    win=win, name='InstructionPictures',units='cm', 
    image='sin', mask=None,
    ori=0, pos=[0,0], size=1.0,
    color=[1,1,1], colorSpace='rgb', opacity=1,
    flipHoriz=False, flipVert=False,
    texRes=128, interpolate=True, depth=0.0)
instruction_text = visual.TextStim(win=win, name='instruction_text',
    text='default text',
    font='Arial',
    units='cm', pos=[0,0], height=1, wrapWidth=37, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-1.0);


# Initialize components for Routine "prac_cue"
prac_cueClock = core.Clock()
cue_img_2 = visual.ImageStim(
    win=win, name='cue_img_2',units='cm', 
    image='Pics/Fractals/1.bmp', mask=None,
    ori=0, pos=[0, 0], size=[8.1, 8.1],
    color=[1,1,1], colorSpace='rgb', opacity=1,
    flipHoriz=False, flipVert=False,
    texRes=128, interpolate=True, depth=0.0)


# Initialize components for Routine "prac_target"
prac_targetClock = core.Clock()

target_img_2 = visual.ImageStim(
    win=win, name='target_img_2',units='cm', 
    image='sin', mask=None,
    ori=0, pos=[0, 0], size=[8.1, 8.1],
    color=[1,1,1], colorSpace='rgb', opacity=1,
    flipHoriz=False, flipVert=False,
    texRes=128, interpolate=True, depth=-1.0)
choose_text = visual.TextStim(win=win, ori=0, name='Choose_Text',
    text='CHOOSE: PRESS OR NOT PRESS',    font='Arial',
    units='cm', pos=[0, 7], height=1, wrapWidth=35,
    color='white', colorSpace='rgb', opacity=1,
    depth=-2.0)


# Initialize components for Routine "prac_fdbk"
prac_fdbkClock = core.Clock()








fdbk_msg_screen_2 = visual.TextStim(win=win, name='fdbk_msg_screen_2',
    text='default text',
    font='Arial',
    units='cm', pos=[0, 5], height=1.3, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-6.0);
chose_msg_2 = visual.TextStim(win=win, name='chose_msg_2',
    text='You chose to',
    font='Arial',
    units='cm', pos=[0, 6], height=.6, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-7.0);

# Initialize components for Routine "prac_iti"
prac_itiClock = core.Clock()
b_iti_screen_2_ = visual.TextStim(win=win, name='b_iti_screen_2_',
    text='+',
    font='Arial',
    units='cm', pos=[0, 0], height=2, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);


# Initialize components for Routine "instructions"
instructionsClock = core.Clock()
InstructionPictures = visual.ImageStim(
    win=win, name='InstructionPictures',units='cm', 
    image='sin', mask=None,
    ori=0, pos=[0,0], size=1.0,
    color=[1,1,1], colorSpace='rgb', opacity=1,
    flipHoriz=False, flipVert=False,
    texRes=128, interpolate=True, depth=0.0)
instruction_text = visual.TextStim(win=win, name='instruction_text',
    text='default text',
    font='Arial',
    units='cm', pos=[0,0], height=1, wrapWidth=37, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-1.0);


# Initialize components for Routine "cue"
cueClock = core.Clock()

cue_img = visual.ImageStim(
    win=win, name='cue_img',units='cm', 
    image='sin', mask=None,
    ori=0, pos=[0, 0], size=[8.1, 8.1],
    color=[1,1,1], colorSpace='rgb', opacity=1,
    flipHoriz=False, flipVert=False,
    texRes=128, interpolate=True, depth=-1.0)


# Initialize components for Routine "target"
targetClock = core.Clock()
target_img = visual.ImageStim(
    win=win, name='target_img',units='cm', 
    image='sin', mask=None,
    ori=0, pos=[0, 0], size=[8.1, 8.1],
    color=[1,1,1], colorSpace='rgb', opacity=1,
    flipHoriz=False, flipVert=False,
    texRes=128, interpolate=True, depth=0.0)
choose_text = visual.TextStim(win=win, ori=0, name='Choose_Text',
    text='CHOOSE: PRESS OR NOT PRESS',    font='Arial',
    units='cm', pos=[0, 7], height=1, wrapWidth=35,
    color='white', colorSpace='rgb', opacity=1,
    depth=-2.0)


# Initialize components for Routine "fdbk"
fdbkClock = core.Clock()
#Set message to inform on feedback
if if_nosound_skipfdbk == 1:
    go_msg = '\n\n           PRESS \n\n Skipping to next trial'
    nogo_msg = '\n\n      NOT PRESS \n\n Skipping to next trial'
elif  if_nosound_skipfdbk == 0:
    go_msg = '\n   PRESS'
    nogo_msg = '\n NOT PRESS'
#Functions

def corr_v_prob_err(trialcorrect):
  if (trialcorrect == CorrResp_eq_NoSound):
   return 'off'
  elif trialcorrect != CorrResp_eq_NoSound:
   return 'on'

def sound_fdbk_det_outcome(correct_resp,keypressed):
 if (correct_resp == 'go' and go_resp == 1) or (correct_resp == 'nogo' and go_resp == 0):
  trialcorrect = 1
 elif (correct_resp == 'nogo' and go_resp == 1) or (correct_resp == 'go' and go_resp == 0):
  trialcorrect = 0

 sound_fdbk_outcome = corr_v_prob_err(trialcorrect)

 if sound_fdbk_outcome == 'off':
  sound_fdbk = 0
 else:
  sound_fdbk = 1
 
 return trialcorrect,sound_fdbk_outcome,sound_fdbk
import random


if fdbk_img_on == 1:
 fdbk_img = visual.ImageStim(win=win, name='soundimage',units='cm',image='sin', mask=None,ori=0, pos=[0, -3], size=[16.4, 6.8],color=[1,1,1], colorSpace='rgb', opacity=1, texRes=128, interpolate=True, depth=-5.0)


fdbk_msg_screen = visual.TextStim(win=win, name='fdbk_msg_screen',
    text='default text',
    font='Arial',
    units='cm', pos=[0, 5], height=1.3, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-5.0);
chose_msg = visual.TextStim(win=win, name='chose_msg',
    text='You chose to',
    font='Arial',
    units='cm', pos=[0, 6], height=.6, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-6.0);

# Initialize components for Routine "iti"
itiClock = core.Clock()
iti_screen = visual.TextStim(win=win, name='iti_screen',
    text='+',
    font='Arial',
    units='cm', pos=[0, 0], height=2, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "sound_chk_intro_past_end"
sound_chk_intro_past_endClock = core.Clock()
soundchktxt1_4 = visual.TextStim(win=win, name='soundchktxt1_4',
    text="The task is over. Thank you for completing it. \n\nWe're going to ask you to rate the sound once again.\n\n\n\n\n\nClick the mouse or press the spacebar to listen to the sound and make your rating.",
    font='Arial',
    units='cm', pos=[0, 0], height=1, wrapWidth=30, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);
mouse_3 = event.Mouse(win=win)
x, y = [None, None]

# Initialize components for Routine "sound_chk_rate_past"
sound_chk_rate_pastClock = core.Clock()
sound_chk_txt2_1 = visual.TextStim(win=win, name='sound_chk_txt2_1',
    text='Please rate how unpleasant this sound was.\n\nClick the ratings line to rate and then click the button to complete the rating.',
    font='Arial',
    units='cm', pos=[0, 4], height=1, wrapWidth=30, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

soundcheck_rating = visual.RatingScale(win=win, name='soundcheck_rating', marker='triangle', size=1.9, pos=[0.0, -0.4], low=0, high=1, precision=100, showValue=False, scale='')
sound_chk_txt2_2 = visual.TextStim(win=win, name='sound_chk_txt2_2',
    text='not unpleasant                    a little                  fairly                  very                   extremely                  intolerable',
    font='Arial',
    units='cm', pos=[0, -3], height=.5, wrapWidth=40, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-3.0);

# Initialize components for Routine "sound_chk_intro_current"
sound_chk_intro_currentClock = core.Clock()
soundchktxt1_3 = visual.TextStim(win=win, name='soundchktxt1_3',
    text="Now we're going to ask you to rate the sound again but this time we want you to rate it while the sound is playing. \n\nIt will play for 2 seconds and then you can make your rating.\n\n\n\nClick the mouse or press the spacebar to listen to the sound and make your rating.",
    font='Arial',
    units='cm', pos=[0, 0], height=1, wrapWidth=30, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);
mouse_2 = event.Mouse(win=win)
x, y = [None, None]

# Initialize components for Routine "sound_chk_rate_current"
sound_chk_rate_currentClock = core.Clock()
sound_chk_txt2_4 = visual.TextStim(win=win, name='sound_chk_txt2_4',
    text='Please rate how unpleasant this sound was.',
    font='Arial',
    units='cm', pos=[0, 4], height=1, wrapWidth=30, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

soundcheck_rating_3 = visual.RatingScale(win=win, name='soundcheck_rating_3', marker='triangle', size=1.9, pos=[0.0, -0.4], low=0, high=1, precision=100, showValue=False, scale='')
sound_chk_txt2_3 = visual.TextStim(win=win, name='sound_chk_txt2_3',
    text='not unpleasant                    a little                  fairly                  very                   extremely                  intolerable',
    font='Arial',
    units='cm', pos=[0, -3], height=.5, wrapWidth=40, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-3.0);

# Initialize components for Routine "taskend"
taskendClock = core.Clock()
text = visual.TextStim(win=win, name='text',
    text='default text',
    font='Arial',
    units='cm', pos=[0, 3], height=1, wrapWidth=35, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);
taskendmsg = 'The task has ended.\n\n\nThank you very much for participating and sorry about the sound!'
mouse_4 = event.Mouse(win=win)
x, y = [None, None]

# Create some handy timers
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.CountdownTimer()  # to track time remaining of each (non-slip) routine 

# ------Prepare to start Routine "startvars"-------
t = 0
startvarsClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat



# keep track of which components have finished
startvarsComponents = []
for thisComponent in startvarsComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "startvars"-------
while continueRoutine:
    # get current time
    t = startvarsClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    
    
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in startvarsComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "startvars"-------
for thisComponent in startvarsComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)



# the Routine "startvars" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "sound_chk_intro_past"-------
t = 0
sound_chk_intro_pastClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
sound_chk_key_resp = event.BuilderKeyResponse()
# setup some python lists for storing info about the mouse
gotValidClick = False  # until a click is received
# keep track of which components have finished
sound_chk_intro_pastComponents = [soundchktxt1, sound_chk_key_resp, mouse]
for thisComponent in sound_chk_intro_pastComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "sound_chk_intro_past"-------
while continueRoutine:
    # get current time
    t = sound_chk_intro_pastClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *soundchktxt1* updates
    if t >= 0.0 and soundchktxt1.status == NOT_STARTED:
        # keep track of start time/frame for later
        soundchktxt1.tStart = t
        soundchktxt1.frameNStart = frameN  # exact frame index
        soundchktxt1.setAutoDraw(True)
    
    # *sound_chk_key_resp* updates
    if t >= 0.0 and sound_chk_key_resp.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_key_resp.tStart = t
        sound_chk_key_resp.frameNStart = frameN  # exact frame index
        sound_chk_key_resp.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(sound_chk_key_resp.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if sound_chk_key_resp.status == STARTED:
        theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            sound_chk_key_resp.keys = theseKeys[-1]  # just the last key pressed
            sound_chk_key_resp.rt = sound_chk_key_resp.clock.getTime()
            # a response ends the routine
            continueRoutine = False
    # *mouse* updates
    if t >= 0.0 and mouse.status == NOT_STARTED:
        # keep track of start time/frame for later
        mouse.tStart = t
        mouse.frameNStart = frameN  # exact frame index
        mouse.status = STARTED
        prevButtonState = mouse.getPressed()  # if button is down already this ISN'T a new click
    if mouse.status == STARTED:  # only update if started and not stopped!
        buttons = mouse.getPressed()
        if buttons != prevButtonState:  # button state changed?
            prevButtonState = buttons
            if sum(buttons) > 0:  # state changed to a new click
                # abort routine on response
                continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in sound_chk_intro_pastComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "sound_chk_intro_past"-------
for thisComponent in sound_chk_intro_pastComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if sound_chk_key_resp.keys in ['', [], None]:  # No response was made
    sound_chk_key_resp.keys=None
thisExp.addData('sound_chk_key_resp.keys',sound_chk_key_resp.keys)
if sound_chk_key_resp.keys != None:  # we had a response
    thisExp.addData('sound_chk_key_resp.rt', sound_chk_key_resp.rt)
thisExp.nextEntry()
# store data for thisExp (ExperimentHandler)
thisExp.nextEntry()
# the Routine "sound_chk_intro_past" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "sound_chk_rate_past"-------
t = 0
sound_chk_rate_pastClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
trialsounds1,trialsounds2 = random.sample([sound1,sound2,sound3],2)

#cueSoundCode
#set up variable and volume for cue sound (trialsounds and cue_dur are set in starting vars)
cuesound1= sound.Sound(trialsounds1, secs=cue_dur)
cuesound1.setVolume(5)
cuesound2= sound.Sound(trialsounds2, secs=cue_dur)
cuesound2.setVolume(5)


cuesound1.play()
cuesound2.play()
soundcheck_rating.reset()
# keep track of which components have finished
sound_chk_rate_pastComponents = [sound_chk_txt2_1, soundcheck_rating, sound_chk_txt2_2]
for thisComponent in sound_chk_rate_pastComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "sound_chk_rate_past"-------
while continueRoutine:
    # get current time
    t = sound_chk_rate_pastClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *sound_chk_txt2_1* updates
    if t >= 2.0 and sound_chk_txt2_1.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_txt2_1.tStart = t
        sound_chk_txt2_1.frameNStart = frameN  # exact frame index
        sound_chk_txt2_1.setAutoDraw(True)
    if t > 2:
        cuesound1.stop()
        cuesound2.stop()
    # *soundcheck_rating* updates
    if t >= 2 and soundcheck_rating.status == NOT_STARTED:
        # keep track of start time/frame for later
        soundcheck_rating.tStart = t
        soundcheck_rating.frameNStart = frameN  # exact frame index
        soundcheck_rating.setAutoDraw(True)
    continueRoutine &= soundcheck_rating.noResponse  # a response ends the trial
    
    # *sound_chk_txt2_2* updates
    if t >= 2 and sound_chk_txt2_2.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_txt2_2.tStart = t
        sound_chk_txt2_2.frameNStart = frameN  # exact frame index
        sound_chk_txt2_2.setAutoDraw(True)
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in sound_chk_rate_pastComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "sound_chk_rate_past"-------
for thisComponent in sound_chk_rate_pastComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
cuesound1.stop()
cuesound2.stop()
# store data for thisExp (ExperimentHandler)
thisExp.addData('soundcheck_rating.response', soundcheck_rating.getRating())
thisExp.addData('soundcheck_rating.rt', soundcheck_rating.getRT())
thisExp.addData('soundcheck_rating.history', soundcheck_rating.getHistory())
thisExp.nextEntry()
# the Routine "sound_chk_rate_past" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "sound_chk_intro_current"-------
t = 0
sound_chk_intro_currentClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
sound_chk_key_resp_2 = event.BuilderKeyResponse()
# setup some python lists for storing info about the mouse_2
gotValidClick = False  # until a click is received
# keep track of which components have finished
sound_chk_intro_currentComponents = [soundchktxt1_3, sound_chk_key_resp_2, mouse_2]
for thisComponent in sound_chk_intro_currentComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "sound_chk_intro_current"-------
while continueRoutine:
    # get current time
    t = sound_chk_intro_currentClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *soundchktxt1_3* updates
    if t >= 0.0 and soundchktxt1_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        soundchktxt1_3.tStart = t
        soundchktxt1_3.frameNStart = frameN  # exact frame index
        soundchktxt1_3.setAutoDraw(True)
    
    # *sound_chk_key_resp_2* updates
    if t >= 0.0 and sound_chk_key_resp_2.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_key_resp_2.tStart = t
        sound_chk_key_resp_2.frameNStart = frameN  # exact frame index
        sound_chk_key_resp_2.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(sound_chk_key_resp_2.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if sound_chk_key_resp_2.status == STARTED:
        theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            sound_chk_key_resp_2.keys = theseKeys[-1]  # just the last key pressed
            sound_chk_key_resp_2.rt = sound_chk_key_resp_2.clock.getTime()
            # a response ends the routine
            continueRoutine = False
    # *mouse_2* updates
    if t >= 0.0 and mouse_2.status == NOT_STARTED:
        # keep track of start time/frame for later
        mouse_2.tStart = t
        mouse_2.frameNStart = frameN  # exact frame index
        mouse_2.status = STARTED
        prevButtonState = mouse_2.getPressed()  # if button is down already this ISN'T a new click
    if mouse_2.status == STARTED:  # only update if started and not stopped!
        buttons = mouse_2.getPressed()
        if buttons != prevButtonState:  # button state changed?
            prevButtonState = buttons
            if sum(buttons) > 0:  # state changed to a new click
                # abort routine on response
                continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in sound_chk_intro_currentComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "sound_chk_intro_current"-------
for thisComponent in sound_chk_intro_currentComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if sound_chk_key_resp_2.keys in ['', [], None]:  # No response was made
    sound_chk_key_resp_2.keys=None
thisExp.addData('sound_chk_key_resp_2.keys',sound_chk_key_resp_2.keys)
if sound_chk_key_resp_2.keys != None:  # we had a response
    thisExp.addData('sound_chk_key_resp_2.rt', sound_chk_key_resp_2.rt)
thisExp.nextEntry()
# store data for thisExp (ExperimentHandler)
thisExp.nextEntry()
# the Routine "sound_chk_intro_current" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "sound_chk_rate_current"-------
t = 0
sound_chk_rate_currentClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
trialsounds1,trialsounds2 = random.sample([sound1,sound2,sound3],2)

#cueSoundCode
#set up variable and volume for cue sound (trialsounds and cue_dur are set in starting vars)
cuesound1= sound.Sound(trialsounds1, secs=cue_dur)
cuesound1.setVolume(5)
cuesound2= sound.Sound(trialsounds2, secs=cue_dur)
cuesound2.setVolume(5)


cuesound1.play()
cuesound2.play()
soundcheck_rating_3.reset()
# keep track of which components have finished
sound_chk_rate_currentComponents = [sound_chk_txt2_4, soundcheck_rating_3, sound_chk_txt2_3]
for thisComponent in sound_chk_rate_currentComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "sound_chk_rate_current"-------
while continueRoutine:
    # get current time
    t = sound_chk_rate_currentClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *sound_chk_txt2_4* updates
    if t >= 2 and sound_chk_txt2_4.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_txt2_4.tStart = t
        sound_chk_txt2_4.frameNStart = frameN  # exact frame index
        sound_chk_txt2_4.setAutoDraw(True)
    
    # *soundcheck_rating_3* updates
    if t >= 2 and soundcheck_rating_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        soundcheck_rating_3.tStart = t
        soundcheck_rating_3.frameNStart = frameN  # exact frame index
        soundcheck_rating_3.setAutoDraw(True)
    continueRoutine &= soundcheck_rating_3.noResponse  # a response ends the trial
    
    # *sound_chk_txt2_3* updates
    if t >= 2 and sound_chk_txt2_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_txt2_3.tStart = t
        sound_chk_txt2_3.frameNStart = frameN  # exact frame index
        sound_chk_txt2_3.setAutoDraw(True)
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in sound_chk_rate_currentComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "sound_chk_rate_current"-------
for thisComponent in sound_chk_rate_currentComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
cuesound1.stop()
cuesound2.stop()
# store data for thisExp (ExperimentHandler)
thisExp.addData('soundcheck_rating_3.response', soundcheck_rating_3.getRating())
thisExp.addData('soundcheck_rating_3.rt', soundcheck_rating_3.getRT())
thisExp.addData('soundcheck_rating_3.history', soundcheck_rating_3.getHistory())
thisExp.nextEntry()
# the Routine "sound_chk_rate_current" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
instructionsloop1 = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('TrialLists/TrialList_Instructions1.xlsx'),
    seed=None, name='instructionsloop1')
thisExp.addLoop(instructionsloop1)  # add the loop to the experiment
thisInstructionsloop1 = instructionsloop1.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisInstructionsloop1.rgb)
if thisInstructionsloop1 != None:
    for paramName in thisInstructionsloop1:
        exec('{} = thisInstructionsloop1[paramName]'.format(paramName))

for thisInstructionsloop1 in instructionsloop1:
    currentLoop = instructionsloop1
    # abbreviate parameter names if possible (e.g. rgb = thisInstructionsloop1.rgb)
    if thisInstructionsloop1 != None:
        for paramName in thisInstructionsloop1:
            exec('{} = thisInstructionsloop1[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "instructions"-------
    t = 0
    instructionsClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    InstructionPictures.setPos([0, InstrPicYPos])
    InstructionPictures.setImage(InstructionPics)
    InstructionPictures.setSize([InstrPicSize1,InstrPicSize2])
    instruction_text.setText( 
"%s\n\n%s\n\n%s\n\n%s"%(InstructionsText, InstructionsText2, InstructionsText3,InstructionsText4))
    instruction_text.setPos([0, InstrYTextPos])
    key_resp_2 = event.BuilderKeyResponse()
    escape_noresp_blocknum = escape_resp_blocknum = avoid_noresp_blocknum = avoid_resp_blocknum = 1
    escape_noresp_block_trialnum = escape_resp_block_trialnum = avoid_noresp_block_trialnum = avoid_resp_block_trialnum = 0
    # keep track of which components have finished
    instructionsComponents = [InstructionPictures, instruction_text, key_resp_2]
    for thisComponent in instructionsComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "instructions"-------
    while continueRoutine:
        # get current time
        t = instructionsClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *InstructionPictures* updates
        if t >= 0.0 and InstructionPictures.status == NOT_STARTED:
            # keep track of start time/frame for later
            InstructionPictures.tStart = t
            InstructionPictures.frameNStart = frameN  # exact frame index
            InstructionPictures.setAutoDraw(True)
        
        # *instruction_text* updates
        if t >= 0.0 and instruction_text.status == NOT_STARTED:
            # keep track of start time/frame for later
            instruction_text.tStart = t
            instruction_text.frameNStart = frameN  # exact frame index
            instruction_text.setAutoDraw(True)
        
        # *key_resp_2* updates
        if t >= 0.0 and key_resp_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            key_resp_2.tStart = t
            key_resp_2.frameNStart = frameN  # exact frame index
            key_resp_2.status = STARTED
            # keyboard checking is just starting
            win.callOnFlip(key_resp_2.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        if key_resp_2.status == STARTED:
            theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                if key_resp_2.keys == []:  # then this was the first keypress
                    key_resp_2.keys = theseKeys[0]  # just the first key pressed
                    key_resp_2.rt = key_resp_2.clock.getTime()
                    # a response ends the routine
                    continueRoutine = False
        
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in instructionsComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "instructions"-------
    for thisComponent in instructionsComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if key_resp_2.keys in ['', [], None]:  # No response was made
        key_resp_2.keys=None
    instructionsloop1.addData('key_resp_2.keys',key_resp_2.keys)
    if key_resp_2.keys != None:  # we had a response
        instructionsloop1.addData('key_resp_2.rt', key_resp_2.rt)
    
    # the Routine "instructions" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'instructionsloop1'

# get names of stimulus parameters
if instructionsloop1.trialList in ([], [None], None):
    params = []
else:
    params = instructionsloop1.trialList[0].keys()
# save data for this loop
instructionsloop1.saveAsExcel(filename + '.xlsx', sheetName='instructionsloop1',
    stimOut=params,
    dataOut=['n','all_mean','all_std', 'all_raw'])
instructionsloop1.saveAsText(filename + 'instructionsloop1.csv', delim=',',
    stimOut=params,
    dataOut=['n','all_mean','all_std', 'all_raw'])

# set up handler to look after randomisation of conditions etc
practrials = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions(prac_conditions_file),
    seed=None, name='practrials')
thisExp.addLoop(practrials)  # add the loop to the experiment
thisPractrial = practrials.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisPractrial.rgb)
if thisPractrial != None:
    for paramName in thisPractrial:
        exec('{} = thisPractrial[paramName]'.format(paramName))

for thisPractrial in practrials:
    currentLoop = practrials
    # abbreviate parameter names if possible (e.g. rgb = thisPractrial.rgb)
    if thisPractrial != None:
        for paramName in thisPractrial:
            exec('{} = thisPractrial[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "prac_cue"-------
    t = 0
    prac_cueClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    cue_resp_2 = event.BuilderKeyResponse()
    import random
    
    #cueSoundCode
    #set up variable and volume for cue sound (trialsounds and cue_dur are set in starting vars)
    cuesound1= sound.Sound(sound1, secs=cue_dur)
    cuesound1.setVolume(2)
    
    if Condition == 'escape':
        cuesound1.play()
    # keep track of which components have finished
    prac_cueComponents = [cue_img_2, cue_resp_2]
    for thisComponent in prac_cueComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "prac_cue"-------
    while continueRoutine:
        # get current time
        t = prac_cueClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *cue_img_2* updates
        if t >= 0.0 and cue_img_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            cue_img_2.tStart = t
            cue_img_2.frameNStart = frameN  # exact frame index
            cue_img_2.setAutoDraw(True)
        frameRemains = 0.0 + cue_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if cue_img_2.status == STARTED and t >= frameRemains:
            cue_img_2.setAutoDraw(False)
        
        # *cue_resp_2* updates
        if t >= 0.0 and cue_resp_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            cue_resp_2.tStart = t
            cue_resp_2.frameNStart = frameN  # exact frame index
            cue_resp_2.status = STARTED
            # AllowedKeys looks like a variable named `allwd_keys`
            if not type(allwd_keys) in [list, tuple, np.ndarray]:
                if not isinstance(allwd_keys, basestring):
                    logging.error('AllowedKeys variable `allwd_keys` is not string- or list-like.')
                    core.quit()
                elif not ',' in allwd_keys: allwd_keys = (allwd_keys,)
                else:  allwd_keys = eval(allwd_keys)
            # keyboard checking is just starting
            win.callOnFlip(cue_resp_2.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        frameRemains = 0.0 + cue_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if cue_resp_2.status == STARTED and t >= frameRemains:
            cue_resp_2.status = STOPPED
        if cue_resp_2.status == STARTED:
            theseKeys = event.getKeys(keyList=list(allwd_keys))
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                if cue_resp_2.keys == []:  # then this was the first keypress
                    cue_resp_2.keys = theseKeys[0]  # just the first key pressed
                    cue_resp_2.rt = cue_resp_2.clock.getTime()
        
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in prac_cueComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "prac_cue"-------
    for thisComponent in prac_cueComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if cue_resp_2.keys in ['', [], None]:  # No response was made
        cue_resp_2.keys=None
    practrials.addData('cue_resp_2.keys',cue_resp_2.keys)
    if cue_resp_2.keys != None:  # we had a response
        practrials.addData('cue_resp_2.rt', cue_resp_2.rt)
    
    # the Routine "prac_cue" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # ------Prepare to start Routine "prac_target"-------
    t = 0
    prac_targetClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    
    target_img_2.setImage('Pics/Fractals/1.bmp')
    choose_text.setAutoDraw(True)
    
    
    target_resp_2 = event.BuilderKeyResponse()
    
    # keep track of which components have finished
    prac_targetComponents = [target_img_2, target_resp_2]
    for thisComponent in prac_targetComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "prac_target"-------
    while continueRoutine:
        # get current time
        t = prac_targetClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        if target_resp_2.keys=='q':
            continueRoutine=False
        
        
        # *target_img_2* updates
        if t >= 0.0 and target_img_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            target_img_2.tStart = t
            target_img_2.frameNStart = frameN  # exact frame index
            target_img_2.setAutoDraw(True)
        frameRemains = 0.0 + target_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if target_img_2.status == STARTED and t >= frameRemains:
            target_img_2.setAutoDraw(False)
        if len(target_resp_2.keys) > 0:
            choose_text.setAutoDraw(False)
        
        # *target_resp_2* updates
        if t >= 0.0 and target_resp_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            target_resp_2.tStart = t
            target_resp_2.frameNStart = frameN  # exact frame index
            target_resp_2.status = STARTED
            # AllowedKeys looks like a variable named `allwd_keys`
            if not type(allwd_keys) in [list, tuple, np.ndarray]:
                if not isinstance(allwd_keys, basestring):
                    logging.error('AllowedKeys variable `allwd_keys` is not string- or list-like.')
                    core.quit()
                elif not ',' in allwd_keys: allwd_keys = (allwd_keys,)
                else:  allwd_keys = eval(allwd_keys)
            # keyboard checking is just starting
            win.callOnFlip(target_resp_2.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        frameRemains = 0.0 + target_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if target_resp_2.status == STARTED and t >= frameRemains:
            target_resp_2.status = STOPPED
        if target_resp_2.status == STARTED:
            theseKeys = event.getKeys(keyList=list(allwd_keys))
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                if target_resp_2.keys == []:  # then this was the first keypress
                    target_resp_2.keys = theseKeys[0]  # just the first key pressed
                    target_resp_2.rt = target_resp_2.clock.getTime()
        if fdbk_aftertarget1_afterpress2 == 2 and len(target_resp_2.keys) > 0:
            continueRoutine = False
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in prac_targetComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "prac_target"-------
    for thisComponent in prac_targetComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    if target_resp_2.keys=='q':
        practrials.finished=True
    prac_targetComponents.append(choose_text)
    choose_text.setAutoDraw(False)
    # check responses
    if target_resp_2.keys in ['', [], None]:  # No response was made
        target_resp_2.keys=None
    practrials.addData('target_resp_2.keys',target_resp_2.keys)
    if target_resp_2.keys != None:  # we had a response
        practrials.addData('target_resp_2.rt', target_resp_2.rt)
    if target_resp_2.keys != None:
        go_resp = 1
    elif target_resp_2.keys == None:
        go_resp = 0
    
    # the Routine "prac_target" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # ------Prepare to start Routine "prac_fdbk"-------
    t = 0
    prac_fdbkClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    if target_resp_2.keys == 'q':
        practrials.finished=True
        continueRoutine=False
    if fdbk_aftertarget1_afterpress2 == 2 and target_resp_2.keys != None and Condition == 'escape':
        fdbk_dur = fdbk_dur_orig+(target_dur - target_resp_2.rt)
    else:
        fdbk_dur = fdbk_dur_orig
    
    if go_resp == 1:
        fdbk_msg=go_msg
    elif go_resp == 0:
        fdbk_msg=nogo_msg
     
    trialcorrect,sound_fdbk_outcome,sound_fdbk = sound_fdbk_det_outcome(CorrectResp,go_resp)
    
     
    
    
    #FeedbackSoundCode
    #set up variable and volume for feedback sound (trialsounds and fdbk_dur are set in starting vars)
    feedbacksound1= sound.Sound(sound1, secs=fdbk_dur)
    feedbacksound1.setVolume(3)
    
    if Condition == 'escape' and sound_fdbk == 0:
        cuesound1.stop()
    elif Condition == 'avoid' and sound_fdbk == 1:
        feedbacksound1.play()
    if fdbk_img_on == 1:
        if sound_fdbk == 0:
            soundimages = 'Pics/Feedback/NoNoiseBlue.png'
        elif sound_fdbk == 1:
            soundimages = 'Pics/Feedback/LoudNoise.png'
    
        fdbk_img.setImage(soundimages)
        fdbk_img.setAutoDraw(True)
    
    
    fdbk_msg_screen_2.setText(fdbk_msg)
    # keep track of which components have finished
    prac_fdbkComponents = [fdbk_msg_screen_2, chose_msg_2]
    for thisComponent in prac_fdbkComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "prac_fdbk"-------
    while continueRoutine:
        # get current time
        t = prac_fdbkClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        if target_resp_2.keys=='q':
            continueRoutine=False
            practrials.finished=True
        
        
        
        
        if if_nosound_skipfdbk == 1 and sound_fdbk == 0:
            if t>=fdbkskipdur:
                continueRoutine = False
        
        # *fdbk_msg_screen_2* updates
        if t >= 0.0 and fdbk_msg_screen_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            fdbk_msg_screen_2.tStart = t
            fdbk_msg_screen_2.frameNStart = frameN  # exact frame index
            fdbk_msg_screen_2.setAutoDraw(True)
        frameRemains = 0.0 + fdbk_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if fdbk_msg_screen_2.status == STARTED and t >= frameRemains:
            fdbk_msg_screen_2.setAutoDraw(False)
        
        # *chose_msg_2* updates
        if t >= 0.0 and chose_msg_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            chose_msg_2.tStart = t
            chose_msg_2.frameNStart = frameN  # exact frame index
            chose_msg_2.setAutoDraw(True)
        frameRemains = 0.0 + fdbk_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if chose_msg_2.status == STARTED and t >= frameRemains:
            chose_msg_2.setAutoDraw(False)
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in prac_fdbkComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "prac_fdbk"-------
    for thisComponent in prac_fdbkComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    
    prac_fdbkComponents.append(fdbk_dur)
    practrials.addData('fdbk_dur', fdbk_dur)
    fdbk_dur = fdbk_dur_orig
    #End Routine
    practrials.addData('trialcorrect', trialcorrect)
    practrials.addData('sound_fdbk_outcome', sound_fdbk_outcome)
    practrials.addData('sound_fdbk', sound_fdbk)
    prac_fdbkComponents.append(feedbacksound1)
    practrials.addData('sound_fdbk', sound_fdbk)
    
    if Condition == 'escape' and sound_fdbk == 1:
        cuesound1.stop()
    elif Condition == 'avoid' and sound_fdbk == 1:
        feedbacksound1.stop()
    if fdbk_img_on == 1:
        prac_fdbkComponents.append(fdbk_img)
        fdbk_img.setAutoDraw(False)
    practrials.addData('fdbkskipdur', fdbkskipdur)
    # the Routine "prac_fdbk" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # ------Prepare to start Routine "prac_iti"-------
    t = 0
    prac_itiClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    if target_resp_2=='q':
        continueRoutine=False
        practrials.finished=True
    # keep track of which components have finished
    prac_itiComponents = [b_iti_screen_2_]
    for thisComponent in prac_itiComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "prac_iti"-------
    while continueRoutine:
        # get current time
        t = prac_itiClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *b_iti_screen_2_* updates
        if t >= 0.0 and b_iti_screen_2_.status == NOT_STARTED:
            # keep track of start time/frame for later
            b_iti_screen_2_.tStart = t
            b_iti_screen_2_.frameNStart = frameN  # exact frame index
            b_iti_screen_2_.setAutoDraw(True)
        frameRemains = 0.0 + iti_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if b_iti_screen_2_.status == STARTED and t >= frameRemains:
            b_iti_screen_2_.setAutoDraw(False)
        if target_resp_2=='q':
            continueRoutine=False
            practrials.finished=True
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in prac_itiComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "prac_iti"-------
    for thisComponent in prac_itiComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    
    # the Routine "prac_iti" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'practrials'

# get names of stimulus parameters
if practrials.trialList in ([], [None], None):
    params = []
else:
    params = practrials.trialList[0].keys()
# save data for this loop
practrials.saveAsExcel(filename + '.xlsx', sheetName='practrials',
    stimOut=params,
    dataOut=['n','all_mean','all_std', 'all_raw'])
practrials.saveAsText(filename + 'practrials.csv', delim=',',
    stimOut=params,
    dataOut=['n','all_mean','all_std', 'all_raw'])

# set up handler to look after randomisation of conditions etc
instructionsloop2 = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('TrialLists/TrialList_Instructions2.xlsx'),
    seed=None, name='instructionsloop2')
thisExp.addLoop(instructionsloop2)  # add the loop to the experiment
thisInstructionsloop2 = instructionsloop2.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisInstructionsloop2.rgb)
if thisInstructionsloop2 != None:
    for paramName in thisInstructionsloop2:
        exec('{} = thisInstructionsloop2[paramName]'.format(paramName))

for thisInstructionsloop2 in instructionsloop2:
    currentLoop = instructionsloop2
    # abbreviate parameter names if possible (e.g. rgb = thisInstructionsloop2.rgb)
    if thisInstructionsloop2 != None:
        for paramName in thisInstructionsloop2:
            exec('{} = thisInstructionsloop2[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "instructions"-------
    t = 0
    instructionsClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    InstructionPictures.setPos([0, InstrPicYPos])
    InstructionPictures.setImage(InstructionPics)
    InstructionPictures.setSize([InstrPicSize1,InstrPicSize2])
    instruction_text.setText( 
"%s\n\n%s\n\n%s\n\n%s"%(InstructionsText, InstructionsText2, InstructionsText3,InstructionsText4))
    instruction_text.setPos([0, InstrYTextPos])
    key_resp_2 = event.BuilderKeyResponse()
    escape_noresp_blocknum = escape_resp_blocknum = avoid_noresp_blocknum = avoid_resp_blocknum = 1
    escape_noresp_block_trialnum = escape_resp_block_trialnum = avoid_noresp_block_trialnum = avoid_resp_block_trialnum = 0
    # keep track of which components have finished
    instructionsComponents = [InstructionPictures, instruction_text, key_resp_2]
    for thisComponent in instructionsComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "instructions"-------
    while continueRoutine:
        # get current time
        t = instructionsClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *InstructionPictures* updates
        if t >= 0.0 and InstructionPictures.status == NOT_STARTED:
            # keep track of start time/frame for later
            InstructionPictures.tStart = t
            InstructionPictures.frameNStart = frameN  # exact frame index
            InstructionPictures.setAutoDraw(True)
        
        # *instruction_text* updates
        if t >= 0.0 and instruction_text.status == NOT_STARTED:
            # keep track of start time/frame for later
            instruction_text.tStart = t
            instruction_text.frameNStart = frameN  # exact frame index
            instruction_text.setAutoDraw(True)
        
        # *key_resp_2* updates
        if t >= 0.0 and key_resp_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            key_resp_2.tStart = t
            key_resp_2.frameNStart = frameN  # exact frame index
            key_resp_2.status = STARTED
            # keyboard checking is just starting
            win.callOnFlip(key_resp_2.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        if key_resp_2.status == STARTED:
            theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                if key_resp_2.keys == []:  # then this was the first keypress
                    key_resp_2.keys = theseKeys[0]  # just the first key pressed
                    key_resp_2.rt = key_resp_2.clock.getTime()
                    # a response ends the routine
                    continueRoutine = False
        
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in instructionsComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "instructions"-------
    for thisComponent in instructionsComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if key_resp_2.keys in ['', [], None]:  # No response was made
        key_resp_2.keys=None
    instructionsloop2.addData('key_resp_2.keys',key_resp_2.keys)
    if key_resp_2.keys != None:  # we had a response
        instructionsloop2.addData('key_resp_2.rt', key_resp_2.rt)
    
    # the Routine "instructions" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'instructionsloop2'

# get names of stimulus parameters
if instructionsloop2.trialList in ([], [None], None):
    params = []
else:
    params = instructionsloop2.trialList[0].keys()
# save data for this loop
instructionsloop2.saveAsExcel(filename + '.xlsx', sheetName='instructionsloop2',
    stimOut=params,
    dataOut=['n','all_mean','all_std', 'all_raw'])
instructionsloop2.saveAsText(filename + 'instructionsloop2.csv', delim=',',
    stimOut=params,
    dataOut=['n','all_mean','all_std', 'all_raw'])

# set up handler to look after randomisation of conditions etc
trials = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions(conditions_file),
    seed=None, name='trials')
thisExp.addLoop(trials)  # add the loop to the experiment
thisTrial = trials.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrial.rgb)
if thisTrial != None:
    for paramName in thisTrial:
        exec('{} = thisTrial[paramName]'.format(paramName))

for thisTrial in trials:
    currentLoop = trials
    # abbreviate parameter names if possible (e.g. rgb = thisTrial.rgb)
    if thisTrial != None:
        for paramName in thisTrial:
            exec('{} = thisTrial[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "cue"-------
    t = 0
    cueClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    CuePic_from_dict = pic_dict[CuePic]
    cue_img.setImage(CuePic_from_dict)
    cue_resp = event.BuilderKeyResponse()
    import random
    trialsounds1,trialsounds2 = random.sample([sound1,sound2,sound3],2)
    
    #cueSoundCode
    #set up variable and volume for cue sound (trialsounds and cue_dur are set in starting vars)
    cuesound1= sound.Sound(trialsounds1, secs=cue_dur)
    cuesound1.setVolume(5)
    cuesound2= sound.Sound(trialsounds2, secs=cue_dur)
    cuesound2.setVolume(5)
    
    if Condition == 'escape':
        cuesound1.play()
        cuesound2.play()
    # keep track of which components have finished
    cueComponents = [cue_img, cue_resp]
    for thisComponent in cueComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "cue"-------
    while continueRoutine:
        # get current time
        t = cueClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        
        # *cue_img* updates
        if t >= 0.0 and cue_img.status == NOT_STARTED:
            # keep track of start time/frame for later
            cue_img.tStart = t
            cue_img.frameNStart = frameN  # exact frame index
            cue_img.setAutoDraw(True)
        frameRemains = 0.0 + cue_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if cue_img.status == STARTED and t >= frameRemains:
            cue_img.setAutoDraw(False)
        
        # *cue_resp* updates
        if t >= 0.0 and cue_resp.status == NOT_STARTED:
            # keep track of start time/frame for later
            cue_resp.tStart = t
            cue_resp.frameNStart = frameN  # exact frame index
            cue_resp.status = STARTED
            # AllowedKeys looks like a variable named `allwd_keys`
            if not type(allwd_keys) in [list, tuple, np.ndarray]:
                if not isinstance(allwd_keys, basestring):
                    logging.error('AllowedKeys variable `allwd_keys` is not string- or list-like.')
                    core.quit()
                elif not ',' in allwd_keys: allwd_keys = (allwd_keys,)
                else:  allwd_keys = eval(allwd_keys)
            # keyboard checking is just starting
            win.callOnFlip(cue_resp.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        frameRemains = 0.0 + cue_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if cue_resp.status == STARTED and t >= frameRemains:
            cue_resp.status = STOPPED
        if cue_resp.status == STARTED:
            theseKeys = event.getKeys(keyList=list(allwd_keys))
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                if cue_resp.keys == []:  # then this was the first keypress
                    cue_resp.keys = theseKeys[0]  # just the first key pressed
                    cue_resp.rt = cue_resp.clock.getTime()
        
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in cueComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "cue"-------
    for thisComponent in cueComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    trials.addData('CuePic_from_dict', CuePic_from_dict)
    # check responses
    if cue_resp.keys in ['', [], None]:  # No response was made
        cue_resp.keys=None
    trials.addData('cue_resp.keys',cue_resp.keys)
    if cue_resp.keys != None:  # we had a response
        trials.addData('cue_resp.rt', cue_resp.rt)
    
    # the Routine "cue" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # ------Prepare to start Routine "target"-------
    t = 0
    targetClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    target_img.setImage(CuePic_from_dict)
    choose_text.setAutoDraw(True)
    
    
    target_resp = event.BuilderKeyResponse()
    
    # keep track of which components have finished
    targetComponents = [target_img, target_resp]
    for thisComponent in targetComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "target"-------
    while continueRoutine:
        # get current time
        t = targetClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *target_img* updates
        if t >= 0.0 and target_img.status == NOT_STARTED:
            # keep track of start time/frame for later
            target_img.tStart = t
            target_img.frameNStart = frameN  # exact frame index
            target_img.setAutoDraw(True)
        frameRemains = 0.0 + target_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if target_img.status == STARTED and t >= frameRemains:
            target_img.setAutoDraw(False)
        if len(target_resp.keys) > 0:
            choose_text.setAutoDraw(False)
        
        # *target_resp* updates
        if t >= 0.0 and target_resp.status == NOT_STARTED:
            # keep track of start time/frame for later
            target_resp.tStart = t
            target_resp.frameNStart = frameN  # exact frame index
            target_resp.status = STARTED
            # AllowedKeys looks like a variable named `allwd_keys`
            if not type(allwd_keys) in [list, tuple, np.ndarray]:
                if not isinstance(allwd_keys, basestring):
                    logging.error('AllowedKeys variable `allwd_keys` is not string- or list-like.')
                    core.quit()
                elif not ',' in allwd_keys: allwd_keys = (allwd_keys,)
                else:  allwd_keys = eval(allwd_keys)
            # keyboard checking is just starting
            win.callOnFlip(target_resp.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        frameRemains = 0.0 + target_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if target_resp.status == STARTED and t >= frameRemains:
            target_resp.status = STOPPED
        if target_resp.status == STARTED:
            theseKeys = event.getKeys(keyList=list(allwd_keys))
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                if target_resp.keys == []:  # then this was the first keypress
                    target_resp.keys = theseKeys[0]  # just the first key pressed
                    target_resp.rt = target_resp.clock.getTime()
        if fdbk_aftertarget1_afterpress2 == 2 and len(target_resp.keys) > 0:
            continueRoutine = False
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in targetComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "target"-------
    for thisComponent in targetComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    targetComponents.append(choose_text)
    choose_text.setAutoDraw(False)
    # check responses
    if target_resp.keys in ['', [], None]:  # No response was made
        target_resp.keys=None
    trials.addData('target_resp.keys',target_resp.keys)
    if target_resp.keys != None:  # we had a response
        trials.addData('target_resp.rt', target_resp.rt)
    if target_resp.keys != None:
        go_resp = 1
    elif target_resp.keys == None:
        go_resp = 0
    
    # the Routine "target" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # ------Prepare to start Routine "fdbk"-------
    t = 0
    fdbkClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    if fdbk_aftertarget1_afterpress2 == 2 and target_resp.keys != None and Condition == 'escape':
        fdbk_dur = fdbk_dur_orig+(target_dur - target_resp.rt)
    else:
        fdbk_dur = fdbk_dur_orig
    
    if go_resp == 1:
        fdbk_msg=go_msg
    elif go_resp == 0:
        fdbk_msg=nogo_msg
     
    trialcorrect,sound_fdbk_outcome,sound_fdbk = sound_fdbk_det_outcome(CorrectResp,go_resp)
    
     
    
    
    trialsounds1,trialsounds2 = random.sample([sound1,sound2,sound3],2)
    
    #FeedbackSoundCode
    #set up variable and volume for feedback sound (trialsounds and fdbk_dur are set in starting vars)
    feedbacksound1= sound.Sound(trialsounds1, secs=fdbk_dur)
    feedbacksound1.setVolume(5)
    feedbacksound2= sound.Sound(trialsounds2, secs=fdbk_dur)
    feedbacksound2.setVolume(5)
    
    if Condition == 'escape' and sound_fdbk == 0:
        cuesound1.stop()
        cuesound2.stop()
    elif Condition == 'avoid' and sound_fdbk == 1:
        feedbacksound1.play()
        feedbacksound2.play()
    if fdbk_img_on == 1:
        if sound_fdbk == 0:
            soundimages = 'Pics/Feedback/NoNoiseBlue.png'
        elif sound_fdbk == 1:
            soundimages = 'Pics/Feedback/LoudNoise.png'
    
        fdbk_img.setImage(soundimages)
        fdbk_img.setAutoDraw(True)
    
    
    fdbk_msg_screen.setText(fdbk_msg)
    # keep track of which components have finished
    fdbkComponents = [fdbk_msg_screen, chose_msg]
    for thisComponent in fdbkComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "fdbk"-------
    while continueRoutine:
        # get current time
        t = fdbkClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        
        
        
        if if_nosound_skipfdbk == 1 and sound_fdbk == 0:
            if t>=fdbkskipdur:
                continueRoutine = False
        
        # *fdbk_msg_screen* updates
        if t >= 0.0 and fdbk_msg_screen.status == NOT_STARTED:
            # keep track of start time/frame for later
            fdbk_msg_screen.tStart = t
            fdbk_msg_screen.frameNStart = frameN  # exact frame index
            fdbk_msg_screen.setAutoDraw(True)
        frameRemains = 0.0 + fdbk_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if fdbk_msg_screen.status == STARTED and t >= frameRemains:
            fdbk_msg_screen.setAutoDraw(False)
        
        # *chose_msg* updates
        if t >= 0.0 and chose_msg.status == NOT_STARTED:
            # keep track of start time/frame for later
            chose_msg.tStart = t
            chose_msg.frameNStart = frameN  # exact frame index
            chose_msg.setAutoDraw(True)
        frameRemains = 0.0 + fdbk_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if chose_msg.status == STARTED and t >= frameRemains:
            chose_msg.setAutoDraw(False)
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in fdbkComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "fdbk"-------
    for thisComponent in fdbkComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    fdbkComponents.append(fdbk_dur)
    trials.addData('fdbk_dur', fdbk_dur)
    fdbk_dur = fdbk_dur_orig
    #End Routine
    trials.addData('trialcorrect', trialcorrect)
    trials.addData('sound_fdbk_outcome', sound_fdbk_outcome)
    trials.addData('sound_fdbk', sound_fdbk)
    
    
    fdbkComponents.append(feedbacksound1)
    fdbkComponents.append(feedbacksound2)
    trials.addData('sound_fdbk', sound_fdbk)
    
    if Condition == 'escape' and sound_fdbk == 1:
        cuesound1.stop()
        cuesound2.stop()
    elif Condition == 'avoid' and sound_fdbk == 1:
        feedbacksound1.stop()
        feedbacksound2.stop()
    if fdbk_img_on == 1:
        fdbkComponents.append(fdbk_img)
        fdbk_img.setAutoDraw(False)
    trials.addData('fdbkskipdur', fdbkskipdur)
    # the Routine "fdbk" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # ------Prepare to start Routine "iti"-------
    t = 0
    itiClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    # keep track of which components have finished
    itiComponents = [iti_screen]
    for thisComponent in itiComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "iti"-------
    while continueRoutine:
        # get current time
        t = itiClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *iti_screen* updates
        if t >= 0.0 and iti_screen.status == NOT_STARTED:
            # keep track of start time/frame for later
            iti_screen.tStart = t
            iti_screen.frameNStart = frameN  # exact frame index
            iti_screen.setAutoDraw(True)
        frameRemains = 0.0 + iti_dur- win.monitorFramePeriod * 0.75  # most of one frame period left
        if iti_screen.status == STARTED and t >= frameRemains:
            iti_screen.setAutoDraw(False)
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in itiComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "iti"-------
    for thisComponent in itiComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # the Routine "iti" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'trials'

# get names of stimulus parameters
if trials.trialList in ([], [None], None):
    params = []
else:
    params = trials.trialList[0].keys()
# save data for this loop
trials.saveAsExcel(filename + '.xlsx', sheetName='trials',
    stimOut=params,
    dataOut=['n','all_mean','all_std', 'all_raw'])
trials.saveAsText(filename + 'trials.csv', delim=',',
    stimOut=params,
    dataOut=['n','all_mean','all_std', 'all_raw'])

# ------Prepare to start Routine "sound_chk_intro_past_end"-------
t = 0
sound_chk_intro_past_endClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
sound_chk_key_resp_3 = event.BuilderKeyResponse()
# setup some python lists for storing info about the mouse_3
gotValidClick = False  # until a click is received
# keep track of which components have finished
sound_chk_intro_past_endComponents = [soundchktxt1_4, sound_chk_key_resp_3, mouse_3]
for thisComponent in sound_chk_intro_past_endComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "sound_chk_intro_past_end"-------
while continueRoutine:
    # get current time
    t = sound_chk_intro_past_endClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *soundchktxt1_4* updates
    if t >= 0.0 and soundchktxt1_4.status == NOT_STARTED:
        # keep track of start time/frame for later
        soundchktxt1_4.tStart = t
        soundchktxt1_4.frameNStart = frameN  # exact frame index
        soundchktxt1_4.setAutoDraw(True)
    
    # *sound_chk_key_resp_3* updates
    if t >= 0.0 and sound_chk_key_resp_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_key_resp_3.tStart = t
        sound_chk_key_resp_3.frameNStart = frameN  # exact frame index
        sound_chk_key_resp_3.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(sound_chk_key_resp_3.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if sound_chk_key_resp_3.status == STARTED:
        theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            sound_chk_key_resp_3.keys = theseKeys[-1]  # just the last key pressed
            sound_chk_key_resp_3.rt = sound_chk_key_resp_3.clock.getTime()
            # a response ends the routine
            continueRoutine = False
    # *mouse_3* updates
    if t >= 0.0 and mouse_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        mouse_3.tStart = t
        mouse_3.frameNStart = frameN  # exact frame index
        mouse_3.status = STARTED
        prevButtonState = mouse_3.getPressed()  # if button is down already this ISN'T a new click
    if mouse_3.status == STARTED:  # only update if started and not stopped!
        buttons = mouse_3.getPressed()
        if buttons != prevButtonState:  # button state changed?
            prevButtonState = buttons
            if sum(buttons) > 0:  # state changed to a new click
                # abort routine on response
                continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in sound_chk_intro_past_endComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "sound_chk_intro_past_end"-------
for thisComponent in sound_chk_intro_past_endComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if sound_chk_key_resp_3.keys in ['', [], None]:  # No response was made
    sound_chk_key_resp_3.keys=None
thisExp.addData('sound_chk_key_resp_3.keys',sound_chk_key_resp_3.keys)
if sound_chk_key_resp_3.keys != None:  # we had a response
    thisExp.addData('sound_chk_key_resp_3.rt', sound_chk_key_resp_3.rt)
thisExp.nextEntry()
# store data for thisExp (ExperimentHandler)
thisExp.nextEntry()
# the Routine "sound_chk_intro_past_end" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "sound_chk_rate_past"-------
t = 0
sound_chk_rate_pastClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
trialsounds1,trialsounds2 = random.sample([sound1,sound2,sound3],2)

#cueSoundCode
#set up variable and volume for cue sound (trialsounds and cue_dur are set in starting vars)
cuesound1= sound.Sound(trialsounds1, secs=cue_dur)
cuesound1.setVolume(5)
cuesound2= sound.Sound(trialsounds2, secs=cue_dur)
cuesound2.setVolume(5)


cuesound1.play()
cuesound2.play()
soundcheck_rating.reset()
# keep track of which components have finished
sound_chk_rate_pastComponents = [sound_chk_txt2_1, soundcheck_rating, sound_chk_txt2_2]
for thisComponent in sound_chk_rate_pastComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "sound_chk_rate_past"-------
while continueRoutine:
    # get current time
    t = sound_chk_rate_pastClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *sound_chk_txt2_1* updates
    if t >= 2.0 and sound_chk_txt2_1.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_txt2_1.tStart = t
        sound_chk_txt2_1.frameNStart = frameN  # exact frame index
        sound_chk_txt2_1.setAutoDraw(True)
    if t > 2:
        cuesound1.stop()
        cuesound2.stop()
    # *soundcheck_rating* updates
    if t >= 2 and soundcheck_rating.status == NOT_STARTED:
        # keep track of start time/frame for later
        soundcheck_rating.tStart = t
        soundcheck_rating.frameNStart = frameN  # exact frame index
        soundcheck_rating.setAutoDraw(True)
    continueRoutine &= soundcheck_rating.noResponse  # a response ends the trial
    
    # *sound_chk_txt2_2* updates
    if t >= 2 and sound_chk_txt2_2.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_txt2_2.tStart = t
        sound_chk_txt2_2.frameNStart = frameN  # exact frame index
        sound_chk_txt2_2.setAutoDraw(True)
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in sound_chk_rate_pastComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "sound_chk_rate_past"-------
for thisComponent in sound_chk_rate_pastComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
cuesound1.stop()
cuesound2.stop()
# store data for thisExp (ExperimentHandler)
thisExp.addData('soundcheck_rating.response', soundcheck_rating.getRating())
thisExp.addData('soundcheck_rating.rt', soundcheck_rating.getRT())
thisExp.addData('soundcheck_rating.history', soundcheck_rating.getHistory())
thisExp.nextEntry()
# the Routine "sound_chk_rate_past" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "sound_chk_intro_current"-------
t = 0
sound_chk_intro_currentClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
sound_chk_key_resp_2 = event.BuilderKeyResponse()
# setup some python lists for storing info about the mouse_2
gotValidClick = False  # until a click is received
# keep track of which components have finished
sound_chk_intro_currentComponents = [soundchktxt1_3, sound_chk_key_resp_2, mouse_2]
for thisComponent in sound_chk_intro_currentComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "sound_chk_intro_current"-------
while continueRoutine:
    # get current time
    t = sound_chk_intro_currentClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *soundchktxt1_3* updates
    if t >= 0.0 and soundchktxt1_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        soundchktxt1_3.tStart = t
        soundchktxt1_3.frameNStart = frameN  # exact frame index
        soundchktxt1_3.setAutoDraw(True)
    
    # *sound_chk_key_resp_2* updates
    if t >= 0.0 and sound_chk_key_resp_2.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_key_resp_2.tStart = t
        sound_chk_key_resp_2.frameNStart = frameN  # exact frame index
        sound_chk_key_resp_2.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(sound_chk_key_resp_2.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if sound_chk_key_resp_2.status == STARTED:
        theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            sound_chk_key_resp_2.keys = theseKeys[-1]  # just the last key pressed
            sound_chk_key_resp_2.rt = sound_chk_key_resp_2.clock.getTime()
            # a response ends the routine
            continueRoutine = False
    # *mouse_2* updates
    if t >= 0.0 and mouse_2.status == NOT_STARTED:
        # keep track of start time/frame for later
        mouse_2.tStart = t
        mouse_2.frameNStart = frameN  # exact frame index
        mouse_2.status = STARTED
        prevButtonState = mouse_2.getPressed()  # if button is down already this ISN'T a new click
    if mouse_2.status == STARTED:  # only update if started and not stopped!
        buttons = mouse_2.getPressed()
        if buttons != prevButtonState:  # button state changed?
            prevButtonState = buttons
            if sum(buttons) > 0:  # state changed to a new click
                # abort routine on response
                continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in sound_chk_intro_currentComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "sound_chk_intro_current"-------
for thisComponent in sound_chk_intro_currentComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if sound_chk_key_resp_2.keys in ['', [], None]:  # No response was made
    sound_chk_key_resp_2.keys=None
thisExp.addData('sound_chk_key_resp_2.keys',sound_chk_key_resp_2.keys)
if sound_chk_key_resp_2.keys != None:  # we had a response
    thisExp.addData('sound_chk_key_resp_2.rt', sound_chk_key_resp_2.rt)
thisExp.nextEntry()
# store data for thisExp (ExperimentHandler)
thisExp.nextEntry()
# the Routine "sound_chk_intro_current" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "sound_chk_rate_current"-------
t = 0
sound_chk_rate_currentClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
trialsounds1,trialsounds2 = random.sample([sound1,sound2,sound3],2)

#cueSoundCode
#set up variable and volume for cue sound (trialsounds and cue_dur are set in starting vars)
cuesound1= sound.Sound(trialsounds1, secs=cue_dur)
cuesound1.setVolume(5)
cuesound2= sound.Sound(trialsounds2, secs=cue_dur)
cuesound2.setVolume(5)


cuesound1.play()
cuesound2.play()
soundcheck_rating_3.reset()
# keep track of which components have finished
sound_chk_rate_currentComponents = [sound_chk_txt2_4, soundcheck_rating_3, sound_chk_txt2_3]
for thisComponent in sound_chk_rate_currentComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "sound_chk_rate_current"-------
while continueRoutine:
    # get current time
    t = sound_chk_rate_currentClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *sound_chk_txt2_4* updates
    if t >= 2 and sound_chk_txt2_4.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_txt2_4.tStart = t
        sound_chk_txt2_4.frameNStart = frameN  # exact frame index
        sound_chk_txt2_4.setAutoDraw(True)
    
    # *soundcheck_rating_3* updates
    if t >= 2 and soundcheck_rating_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        soundcheck_rating_3.tStart = t
        soundcheck_rating_3.frameNStart = frameN  # exact frame index
        soundcheck_rating_3.setAutoDraw(True)
    continueRoutine &= soundcheck_rating_3.noResponse  # a response ends the trial
    
    # *sound_chk_txt2_3* updates
    if t >= 2 and sound_chk_txt2_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        sound_chk_txt2_3.tStart = t
        sound_chk_txt2_3.frameNStart = frameN  # exact frame index
        sound_chk_txt2_3.setAutoDraw(True)
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in sound_chk_rate_currentComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "sound_chk_rate_current"-------
for thisComponent in sound_chk_rate_currentComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
cuesound1.stop()
cuesound2.stop()
# store data for thisExp (ExperimentHandler)
thisExp.addData('soundcheck_rating_3.response', soundcheck_rating_3.getRating())
thisExp.addData('soundcheck_rating_3.rt', soundcheck_rating_3.getRT())
thisExp.addData('soundcheck_rating_3.history', soundcheck_rating_3.getHistory())
thisExp.nextEntry()
# the Routine "sound_chk_rate_current" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "taskend"-------
t = 0
taskendClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
text.setText(taskendmsg)
key_resp_4 = event.BuilderKeyResponse()

# setup some python lists for storing info about the mouse_4
gotValidClick = False  # until a click is received
# keep track of which components have finished
taskendComponents = [text, key_resp_4, mouse_4]
for thisComponent in taskendComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "taskend"-------
while continueRoutine:
    # get current time
    t = taskendClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text* updates
    if t >= 0.0 and text.status == NOT_STARTED:
        # keep track of start time/frame for later
        text.tStart = t
        text.frameNStart = frameN  # exact frame index
        text.setAutoDraw(True)
    
    # *key_resp_4* updates
    if t >= 0.0 and key_resp_4.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_4.tStart = t
        key_resp_4.frameNStart = frameN  # exact frame index
        key_resp_4.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_4.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if key_resp_4.status == STARTED:
        theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_4.keys = theseKeys[-1]  # just the last key pressed
            key_resp_4.rt = key_resp_4.clock.getTime()
            # a response ends the routine
            continueRoutine = False
    
    # *mouse_4* updates
    if t >= 0.0 and mouse_4.status == NOT_STARTED:
        # keep track of start time/frame for later
        mouse_4.tStart = t
        mouse_4.frameNStart = frameN  # exact frame index
        mouse_4.status = STARTED
        prevButtonState = mouse_4.getPressed()  # if button is down already this ISN'T a new click
    if mouse_4.status == STARTED:  # only update if started and not stopped!
        buttons = mouse_4.getPressed()
        if buttons != prevButtonState:  # button state changed?
            prevButtonState = buttons
            if sum(buttons) > 0:  # state changed to a new click
                # abort routine on response
                continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in taskendComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "taskend"-------
for thisComponent in taskendComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_4.keys in ['', [], None]:  # No response was made
    key_resp_4.keys=None
thisExp.addData('key_resp_4.keys',key_resp_4.keys)
if key_resp_4.keys != None:  # we had a response
    thisExp.addData('key_resp_4.rt', key_resp_4.rt)
thisExp.nextEntry()

# store data for thisExp (ExperimentHandler)
thisExp.nextEntry()
# the Routine "taskend" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()






























# these shouldn't be strictly necessary (should auto-save)
thisExp.saveAsWideText(filename+'.csv')
thisExp.saveAsPickle(filename)
logging.flush()
# make sure everything is closed down
thisExp.abort()  # or data files will save again on exit
win.close()
core.quit()
