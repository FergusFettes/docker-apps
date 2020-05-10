# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-18.04

RUN add-pkg xterm
RUN echo "#!/bin/sh" > /startapp.sh && \
    echo "exec /usr/bin/xterm" >> /startapp.sh

ENV \
  APP_NAME="VScode"
