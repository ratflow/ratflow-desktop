#!/bin/bash
cd /home/rfuser

Xvfb $DISPLAY -screen 0 1280x800x24 &
x11vnc -loop -forever &
su -c "ratflow-session" rfuser &
sleep infinity
