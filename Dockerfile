FROM node:latest
WORKDIR /app

RUN echo "deb http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://www.deb-multimedia.org jessie main non-free" >>  /etc/apt/sources.list

RUN apt-get update

RUN apt-get install deb-multimedia-keyring --assume-yes --force-yes
#ENV PATH="/app/bin:${PATH}"
RUN apt-get install curl xvfb tar --assume-yes
#TODO Clean this out
RUN apt-get install ffmpeg libgtk2.0-0 libxss1 libgconf-2-4 libnss3 --assume-yes  --force-yes

# Finally, build app
RUN apt-get install dos2unix --assume-yes

ADD . /app
RUN npm i

# Fix CRLF when building on windows

RUN dos2unix scripts/exec-stream-headless.sh
#RUN apt-get --purge remove -y dos2unix

CMD scripts/exec-stream-headless.sh
