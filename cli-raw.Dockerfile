# Pull base image.
FROM ubuntu:18.04 as base

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV HOME /home/ffettes

# Standard apt installs
RUN \
     apt update && apt install -y man tree locales openssh-server curl wget build-essential cmake python3-dev software-properties-common \
     iputils-ping \
     vim python3-neovim tmux zsh git mosh \
     python3

# Configuration
RUN \
     locale-gen en_US.UTF-8 && \
     mkdir /var/run/sshd && \
     sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

COPY --chown=1000:1000 --from=content /content/ $HOME/
COPY --chown=1000:1000 cli-config $HOME/

# installs from content ycm, fzf, oh-my-zsh, bat
RUN \
     cd $HOME/.vim/plugged/youcompleteme/ && \
     python3 install.py && \
     $HOME/.fzf/install && \
     mv $HOME/.zsh $HOME/.temp && \
     cd $HOME/.temp && \
     ZSH=$HOME/.zsh \
     sh install.sh --unattended --keep-zshrc && \
     mv $HOME/.temp/* $HOME/.zsh && \
     dpkg -i $HOME/.debs/ripgrep.deb && \
     dpkg -i $HOME/.debs/bat.deb

COPY --from=randomvilliager/docker-apps:content /etc/passwd /etc/passwd
COPY --from=randomvilliager/docker-apps:content /etc/shadow /etc/shadow
COPY --from=randomvilliager/docker-apps:content /etc/group /etc/group
COPY --from=randomvilliager/docker-apps:content /etc/sudoers.d/ /etc/

RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     echo "$(which sshd)" >> /startapp.sh && \
     echo "exec /usr/bin/zsh" >> /startapp.sh && \
     chmod +x /startapp.sh
ENTRYPOINT /startapp.sh
EXPOSE 22
WORKDIR $HOME
USER $UNAME
