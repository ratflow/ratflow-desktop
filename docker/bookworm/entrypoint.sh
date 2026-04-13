#!/bin/bash

rm /tmp/.X0-lock ||:
Xvfb $DISPLAY -screen 0 1280x800x24 &
x11vnc -loop -forever &
su -c "ratflow-session" rfuser &
sleep infinity
