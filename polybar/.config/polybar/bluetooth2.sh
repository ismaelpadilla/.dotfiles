#!/bin/sh
# https://github.com/msaitz/polybar-bluetooth

if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  echo "%{F#66ffffff}B"
else
  if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
  then 
    echo "B"
  fi
  echo "%{F#2193ff}B"
fi
