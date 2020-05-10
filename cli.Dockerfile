# Pull base image.
FROM jlesage/baseimage:ubuntu-18.04 AS base

# install basic packages for cli dev TODO: once ubuntu 2020 is out, change to kitty
# Standard apt installs
# TODO: find out which of these are build dependencies and delete them afterwards, use the jlesage image for these things
RUN \
     add-pkg build-essential cmake python3-dev software-properties-common \
     sudo tree man \
     vim python3-neovim tmux zsh git ranger

ENV UNAME ffettes
ENV HOME /home/ffettes
COPY --from=randomvilliager/docker-apps:user /etc/ /defaults/

COPY --chown=1000:1000 --from=randomvilliager/docker-apps:content /content/ $HOME/
# installs from content ycm, fzf, oh-my-zsh, bat
RUN \
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
     rm -rf $HOME/.temp $HOME/.debs
COPY --chown=1000:1000 cli-config $HOME/.gitconfig $HOME/.gitconfig

RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     echo "sudo $(which sshd)" >> /startapp.sh && \
     echo "eval `ssh-agent -s`" >> /startapp.sh && \
     echo "ssh-add ~/.ssh/id_rsa" >> /startapp.sh && \
     # Chown the work folder
     echo "sudo chown -R $UNAME:1000 $HOME/work" && \
     echo "exec /bin/zsh" >> /startapp.sh

ENV \
     APP_NAME="CLI"
