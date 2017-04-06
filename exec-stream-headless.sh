#!/bin/bash

## Tweak these Vars for Streaming
FRAMERATE=30
RESOLUTION=1280x720


## X Settings
XFORMAT=${XVFB_WHD:-1280x720x16}
XSCREEN=:99

## FFMPEG Settings
FRAMERATE=30
CRF=23 #Constant Quality. 0 Is Lossless, 51 is Worstless
PRESET=veryfast
MAXRATE=2048k #Limit each stream node to 2048Mbps
BUFSIZE=4096k #Buffer 2 Seconds (Multiple of MAXRATE)
GOP=60 # 2 Second GroupOfPictures (Keyframe Interval) ((2x FRAMERATE))



_kill_procs() {
  kill -TERM $chromium-browser
  wait $chromium-browser
  kill -TERM $xvfb
  kill -TERM $ffmpeg
}

echo Streaming To: $STREAMHOST
# Setup a trap to catch SIGTERM and relay it to child processes
trap _kill_procs SIGTERM


# Start Xvfb
Xvfb $XSCREEN -ac -screen 0 $XFORMAT -nolisten tcp &
xvfb=$!

export DISPLAY=:99

chromium-browser --no-sandbox --kiosk $WEBHOST &
chromium-browser=$!
ffmpeg -y -f x11grab -video_size $RESOLUTION -framerate $FRAMERATE -i $XSCREEN \
-c:v libx264 -preset ultrafast -maxrate $MAXRATE -bufsize $BUFSIZE \
-vf "format=yuv420p" -g $GOP -f flv $STREAMHOST &
ffmpeg=$!

wait $chromium
wait $avconv
