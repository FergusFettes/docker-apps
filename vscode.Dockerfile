# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-18.04

# Install vscode.
RUN \
     add-pkg wget && \
     wget -q https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb && \
     add-pkg libnotify4 libnss3 libsecret-1-0 libgtk-3-0 libxss1 gnupg libsound2 && \
     dpkg -i vscode.deb

# This is where I will install extra things like languages I want to use
RUN \
     add-pkg python3.8 python3-pip

RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     echo "export HOME=/config" >> /startapp.sh && \
     echo "exec /usr/bin/code --user-data-dir /config" >> /startapp.sh

# Set the name of the application.
ENV \
     APP_NAME="VScode"

