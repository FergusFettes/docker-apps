# Pull base image.
FROM ubuntu:18.04 as base

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV HOME /home/ffettes

# Standard apt installs
# TODO: find out which of these are build dependencies and delete them afterwards, use the jlesage image for these things
RUN \
     apt update && apt install -y man tree locales openssh-server curl wget build-essential cmake python3-dev software-properties-common \
     iputils-ping iproute2 sudo \
     vim python3-neovim tmux zsh git mosh \
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
     rm $HOME/.bashrc $HOME/.fzf.bash && \
     mv $HOME/.zsh $HOME/.temp && \
     ZSH=$HOME/.zsh \
     sh $HOME/.temp/install.sh --unattended --keep-zshrc && \
     mv $HOME/.temp/custom/plugins/* $HOME/.zsh/custom/plugins && \
     dpkg -i $HOME/.debs/ripgrep.deb && \
     dpkg -i $HOME/.debs/bat.deb && \
     rm -rf $HOME/.temp $HOME/.debs

COPY --from=randomvilliager/docker-apps:user /etc/passwd /etc/passwd
COPY --from=randomvilliager/docker-apps:user /etc/shadow /etc/shadow
COPY --from=randomvilliager/docker-apps:user /etc/group /etc/group
COPY --from=randomvilliager/docker-apps:user /etc/sudoers.d/ /etc/sudoers.d/
COPY --chown=1000:1000 cli-config $HOME/

ENV UNAME ffettes
RUN \
     echo "[user]" > $HOME/.gitconfig && \
     echo "  email = $UNAME@cli-raw.image" >> $HOME/.gitconfig && \
     echo "  name = $UNAME" >> $HOME/.gitconfig

RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     # So you can ssh in (if you are authorized)
     echo "$(which sshd)" >> /startapp.sh && \
     # The next two lines are useful if you map your ssh keys in and want to use github
     echo "eval `ssh-agent -s`" >> /startapp.sh && \
     echo "ssh-add ~/.ssh/id_rsa" >> /startapp.sh && \
     # Chown the work folder
     echo "sudo chown -R $UNAME:1000 $HOME/work" && \
     echo "export SHELL=/bin/zsh" >> /startapp.sh && \
     echo "exec /bin/zsh" >> /startapp.sh && \
     chmod +x /startapp.sh
ENTRYPOINT /startapp.sh
EXPOSE 22
VOLUME $HOME/work
WORKDIR $HOME/work
USER $UNAME

# Metadata.
ARG IMAGE_VERSION=cli-raw
LABEL \
      org.label-schema.name="cli-raw" \
      org.label-schema.description="My basic terminal environment" \
      org.label-schema.version="${IMAGE_VERSION}" \
      org.label-schema.vcs-url="https://github.com/fergusfettes/docker-apps" \
      org.label-schema.schema-version="1.0"
