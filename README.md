# Streambox
A Docker container with Xvfb and Electron which can stream to a file or RTMP endpoint 

## Usage

<!-- ### Prereqs (CURRENTLY NOT USED, CONTINUE ON)
* Download the FFMpeg Binaries from the buildbox and extract them into ./bin
* Or use this [This Link](https://drive.google.com/open?id=0B0p9GlzfEbsDeWZVRERKRDJNTFE) -->


### Building

```sh
docker build -t cgrinker/actionsprout-streambox .
```

### Testing
```sh
WEBHOST=https://news.google.com
STREAMHOST=/video/out.flv
docker run -e WEBHOST=$WEBHOST -e STREAMHOST=$STREAMHOST -v $(pwd)/tmp:/video cgrinker/actionsprout-streambox
```

### Streaming
```sh
WEBHOST=https://news.google.com
STREAMKEY=XXXX-XXXX-XXXX-XXXX
ENDPOINT=rtmp://a.rtmp.youtube.com/live2
## Or rtmp://rtmp-api.facebook.com:80/rtmp/
## Or rtmp://live.twitch.tv/app/
docker run -e WEBHOST=$WEBHOST -e STREAMHOST=$ENDPOINT/$STREAMKEY cgrinker/streambox
```
