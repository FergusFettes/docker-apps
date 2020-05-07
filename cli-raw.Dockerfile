# Pull base image.
FROM ubuntu:18.04 as base

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV HOME

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

COPY --chown=1000:1000 --from=randomvilliager/docker-apps:content /root/.vim $HOME/.vim
COPY --chown=1000:1000 --from=randomvilliager/docker-apps:content /root/.zsh $HOME/.zsh
COPY --chown=1000:1000 --from=randomvilliager/docker-apps:content /root/.debs $HOME/.debs
COPY --chown=1000:1000 --from=randomvilliager/docker-apps:content /root/.local $HOME/.local
COPY --chown=1000:1000 cli-config "${HOME}"/

# installs from content ycm, fzf, oh-my-zsh
RUN \
     cd $HOME/.vim/plugged/youcompleteme/ && \
     python3 install.py --rust-completer && \
     $HOME/.fzf/install && \
     mv $HOME/.oh-my-zsh $HOME/.temp-zsh && \
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
     cp -r $HOME/.temp-zsh/* $HOME/.oh-my-zsh/ && \
     rm -r $HOME/.temp-zsh $HOME/.bashrc && \
     dpkg -i $HOME/.installs/bat.deb

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
