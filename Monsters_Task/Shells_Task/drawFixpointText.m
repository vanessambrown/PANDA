% drawFixpointText

% show a fixation point and text above it
[wt]=Screen(wd,'TextBounds',txt{1});
xpos = wdw/2-wt(3)/2;
ypos = wdh*4/9 - 2*wt(4);
Screen('Drawtext',wd,txt{1},xpos,ypos,orange);
drawfixationcross(wd,2,fixationdotsize,0);
