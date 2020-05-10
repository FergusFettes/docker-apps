# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-18.04 AS base

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV HOME /defaults

# Standard apt installs
RUN \
     apt update && apt install -y man tree locales openssh-server curl wget build-essential cmake python3-dev software-properties-common \
     iputils-ping sudo \
     vim python3-neovim tmux zsh git mosh xterm \
     python3

# Configuration
RUN \
     locale-gen en_US.UTF-8 && \
     mkdir /var/run/sshd && \
     sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

COPY --chown=1000:1000 --from=randomvilliager/docker-apps:content /content/ $HOME/

# installs from content ycm, fzf, oh-my-zsh, bat
RUN \
     cd $HOME/.vim/plugged/youcompleteme/ && \
     python3 install.py && \
     $HOME/.fzf/install && \
     mv $HOME/.zsh $HOME/.temp && \
     cd $HOME/.temp && \
     ZSH=$HOME/.zsh \
     sh install.sh --unattended --keep-zshrc && \
     mv $HOME/.temp/custom/plugins/* $HOME/.zsh/custom/plugins && \
     dpkg -i $HOME/.debs/ripgrep.deb && \
     dpkg -i $HOME/.debs/bat.deb

ARG UNAME=app
RUN \
     echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" \
     > "/etc/sudoers.d/${UNAME}" && \
     chmod 0440 "/etc/sudoers.d/${UNAME}"
COPY --chown=1000:1000 cli-config $HOME/

RUN chown -R 1000:1000 /defaults

RUN \
   add-pkg x11-utils
RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     echo "export HOME=${HOME}" >> /startapp.sh && \
     echo "$(which sshd)" >> /startapp.sh && \
     echo "export SHELL=/usr/bin/zsh" >> /startapp.sh && \
     echo "exec /usr/bin/xev" >> /startapp.sh
ENV \
     APP_NAME="CLI"
