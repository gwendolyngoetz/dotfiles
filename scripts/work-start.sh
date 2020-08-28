#!/bin/sh 

  
i3-msg 'workspace 3; exec "QT_QPA_PLATFORMTHEME=kde vboxmanage startvm Windows10"' > /dev/null
