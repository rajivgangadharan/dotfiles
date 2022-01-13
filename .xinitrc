#!/usr/bin/env bash
xhost +SI:localuser:$USER # Disable access control
xsetroot -cursor_name left_ptr # Fallback cursor
setxkbmap -layout us -option ctrl:nocaps # Set capslock as ctrl
export VISUAL=emacsclient
export EDITOR="$VISUAL"
export TERM="xterm"
export DISPLAY=:0
xset b off &
xhost +
numlockx off # Turn off numlock
# Autostarts go here
exec dbus-launch --exit-with-session emacs
