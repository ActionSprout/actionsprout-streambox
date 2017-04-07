FROM node:latest
WORKDIR /app

RUN apt-get update
RUN apt-get install curl xvfb tar --assume-yes
RUN mkdir /app
ADD . /app
RUN tar -xzvf bin/ffmpeg.tar.gz /bin

CMD scripts/exec-stream-headless.sh
