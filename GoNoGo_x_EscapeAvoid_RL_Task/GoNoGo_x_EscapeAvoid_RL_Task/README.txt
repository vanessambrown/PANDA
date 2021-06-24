Last run successfully with PsychoPy 1.90.1 on 05/23/18
4 conditions
EscapeGo = sound on during choice, press spacebar during target to turn off sound 80% of the time
EscapeNoGo = sound on during choice, do NOT press spacebar during target to turn off sound 80% of the time
AvoidGo = sound off during choice, press spacebar during target to avoid sound 80% of the time
AvoidGo = sound off during choice, do NOT press spacebar during target to avoid sound 80% of the time

Upon starting the task, there are 4 required parameters
subjnum = Study subject number; takes any alphanumeric combination
session = Session number; takes any number; default:01
prac_type = Specifies whether the practice trials, which contain only one cue, should be a go or nogo; options go, nogo, or random which will randomly pick go or nogo; default:random
trials_per_cond = trials per condition (e.g. total number of trials = trials per condition x 4 conditions); Options are 60, 40, 30, or 25 trials per condition; default : 40

## Trial lists
Trial lists are pseudo-randomized within the task and the final trialList for each subject is deposited in ./TrialLists/subs_trialLists

## Sound ratings
The task starts and ends with sound ratings. After the initial sound rating, move the mouse cursor to the side of the screen and use the keyboard to advance the instructions. 

## Practice
Practice contains 6 trials with a single cue. There is one probabilistic error on the 4th trial. 
Pressing ‘q’ during the cue presentation of the practice will skip the remaining practice trials. 

## Additional options
There are several options that can be found within the start_vars routine at the beginning of the builder view of the task. 

## Modify instructions
Instructions can be modified by modifying the TrialList_Instructions1.xlsx or TrialList_Instructions2.xlsx files within the TrialLists directory.

## Note
Do not delete any files or folders in the top level of the TrialList directory.

Questions? Email amillner@fas.harvard.edu