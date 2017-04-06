FROM ubuntu:latest

RUN apt-get update
RUN apt-get install curl xvfb chromium-browser ffmpeg --assume-yes

ADD ./exec-stream-headless.sh /bin/exec-stream-headless.sh

CMD /bin/exec-stream-headless.sh
