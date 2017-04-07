#!/bin/bash

## Tweak these Vars for Streaming
FRAMERATE=30
WIDTH=1280
HEIGHT=720
RESOLUTION=$WIDTHx$HEIGHT


## X Settings
XFORMAT=$RESOLUTIONx24
XSERVERNUM=:99

## FFMPEG Settings
FRAMERATE=30
CRF=23 #Constant Quality. 0 Is Lossless, 51 is Worstless
PRESET=veryfast
MAXRATE=2048k #Limit each stream node to 2048Mbps
BUFSIZE=4096k #Buffer 2 Seconds (Multiple of MAXRATE)
GOP=60 # 2 Second GroupOfPictures (Keyframe Interval) ((2x FRAMERATE))

RC=0

_kill_procs() {
  kill -TERM $chromium-browser
  wait $chromium-browser
  kill -TERM $xvfb
  kill -TERM $ffmpeg
}

# Setup a trap to catch SIGTERM and relay it to child processes
trap _kill_procs SIGTERM


# Start Xvfb
Xvfb $XSERVERNUM -screen 0 $XFORMAT &
xvfb=$!

export DISPLAY=$XSERVERNUM

node_modules/.bin/electron  &
electon=$!
sleep 10

ffmpeg -y -f x11grab -video_size $RESOLUTION -framerate $FRAMERATE -i $XSERVERNUM \
-c:v libx264 -preset ultrafast -maxrate $MAXRATE -bufsize $BUFSIZE \
-vf "format=yuv420p" -g $GOP -f flv $STREAMHOST &
ffmpeg=$!

wait $electon
exit $RC
