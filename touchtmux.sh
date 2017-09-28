#!/bin/bash 
# (For machines that mount the same disk) this (somewhat) prevents starting tmux
# if it's already set in the ssh client machine.
if [ ! -z "$TMUX" ]; then
  touch -m ~/.tmux-lock
  echo touched lock > ~/log
else 
  echo didn\'t touch lock > ~/log
fi
