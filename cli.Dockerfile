# Pull base image.
FROM jlesage/baseimage:ubuntu-18.04 AS base

# install basic packages for cli dev TODO: once ubuntu 2020 is out, change to kitty
# Standard apt installs
# TODO: find out which of these are build dependencies and delete them afterwards, use the jlesage image for these things
RUN \
     add-pkg sudo tree man \
     vim python3-neovim tmux zsh git ranger

ENV UNAME ffettes
ENV HOME /home/ffettes
COPY --from=randomvilliager/docker-apps:user /etc/ /defaults/

COPY --chown=1000:1000 --from=randomvilliager/docker-apps:content /content/ $HOME/
# installs from content ycm, fzf, oh-my-zsh, bat
RUN \
     add-pkg --virtual deps curl cmake python3-dev software-properties-common build-essential && \
     cd $HOME/.vim/plugged/youcompleteme/ && \
     python3 install.py && \
     $HOME/.fzf/install && \
     rm $HOME/.bashrc $HOME/.fzf.bash && \
     mv $HOME/.zsh $HOME/.temp && \
     ZSH=$HOME/.zsh \
     sh $HOME/.temp/install.sh --unattended --keep-zshrc && \
     mv $HOME/.temp/custom/plugins/* $HOME/.zsh/custom/plugins && \
     dpkg -i $HOME/.debs/ripgrep.deb && \
     dpkg -i $HOME/.debs/bat.deb && \
     rm -rf $HOME/.temp $HOME/.debs && \
     del-pkg deps

# COPY --chown=1000:1000 --from=randomvilliager/docker-apps:user $HOME/.gitconfig $HOME/

RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     # echo "sudo $(which sshd)" >> /startapp.sh && \
     # echo "eval `ssh-agent -s`" >> /startapp.sh && \
     # echo "ssh-add ~/.ssh/id_rsa" >> /startapp.sh && \
     # Chown the work folder
     echo "sudo chown -R $UNAME:1000 $HOME/work" && \
     echo "exec /bin/zsh" >> /startapp.sh

ENV \
     APP_NAME="CLI"

# Metadata.
ARG IMAGE_VERSION=cli
LABEL \
      org.label-schema.name="cli" \
      org.label-schema.description="My basic terminal environment in nice s6 image" \
      org.label-schema.version="${IMAGE_VERSION}" \
      org.label-schema.vcs-url="https://github.com/fergusfettes/docker-apps" \
      org.label-schema.schema-version="1.0"
