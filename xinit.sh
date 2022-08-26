#!/bin/bash
Xvfb :10 -screen 0 ${RESOLUTION} &
x11vnc -noipv6 -xkb -noxdamage -xfixes -noxrecord -noscrollcopyrect \
  -nowireframe -nowcr -passwd fixthisbug -nonc \
  -noserverdpms -nodpms -display :10 -N -nevershared -forever &
sleep 5 
x-terminal-emulator &
exec mate-session
