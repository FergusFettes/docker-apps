# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-18.04

# Install vlc.
RUN add-pkg vlc && \
    echo "#!/bin/sh" > /startapp.sh && \
    echo "exec /usr/bin/vlc" >> /startapp.sh

# Set the name of the application.
ENV APP_NAME="VLC"
