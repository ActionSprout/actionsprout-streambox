# Streambox
A Docker container with Xvfb and Chromium which can stream to an RTMP endpoint

## Usage

### Testing
```sh
WEBHOST=https://news.google.com
STREAMHOST=/video/out.flv
docker run -e WEBHOST=$WEBHOST -e STREAMHOST=$ENDPOINT/$STREAMKEY -v $HOME/Desktop:/video cgrinker/streambox
```

### Streaming
```sh
WEBHOST=https://news.google.com
STREAMKEY=XXXX-XXXX-XXXX-XXXX
ENDPOINT=rtmp://a.rtmp.youtube.com/live2
docker run -e WEBHOST=$WEBHOST -e STREAMHOST=$ENDPOINT/$STREAMKEY cgrinker/streambox
```
