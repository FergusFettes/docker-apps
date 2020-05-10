# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-18.04

RUN add-pkg x11-utils    # Use with xev to capture keystrokes
RUN add-pkg xterm
RUN echo "#!/bin/sh" > /startapp.sh && \
    # echo "exec /usr/bin/xterm" >> /startapp.sh
    echo "exec /usr/bin/xev" >> /startapp.sh


ENV \
  APP_NAME="Examples/testing"
