
### Use These Vars for Controlling what gets rendered and when
#####!/bin/bash
# If BROADCAST_END isn't defined, run test of 100 seconds
# (plus the 10 second sleep to wait on electron's launch)
if [ -z ${BROADCAST_END} ]; then
  _NOW=$(date +%s)
  BROADCAST_END=$(($_NOW + 110))
fi

#Tune this to make sure Electron is open
STARTUPTIME=3
## Tweak these Vars for Streaming
FRAMERATE=30
export WIDTH=1280
export HEIGHT=720
RESOLUTION="$WIDTH"x"$HEIGHT"


## X Settings
XFORMAT="$RESOLUTION"x24
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
echo $XSERVERNUM $XFORMAT
Xvfb $XSERVERNUM -screen 1 $XFORMAT &
xvfb=$!

export DISPLAY=$XSERVERNUM

node_modules/.bin/electron src/index  &
electon=$!
sleep $STARTUPTIME

ffmpeg -y -f x11grab -framerate $FRAMERATE -video_size $RESOLUTION -i $XSERVERNUM \
-c:v libx264 -preset ultrafast -maxrate $MAXRATE -bufsize $BUFSIZE -g $GOP -f flv $STREAMHOST &
ffmpeg=$!

wait $electon
exit $RC
