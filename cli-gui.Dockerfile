# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-18.04

# install basic packages for cli dev TODO: once ubuntu 2020 is out, change to kitty
RUN \
     add-pkg vim python3-neovim tmux xterm zsh git

# add vim-plug
RUN \
     add-pkg --virtual deps curl && \
     curl -fLo /config/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
     del-pkg deps

COPY cli-config /defaults/

RUN \
     add-pkg gimp

RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     echo "export HOME=/config" >> /startapp.sh && \
     echo "exec /usr/bin/gimp" >> /startapp.sh

ENV \
     APP_NAME="CLI"
