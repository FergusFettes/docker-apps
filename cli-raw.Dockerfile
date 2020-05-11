# Pull base image.
FROM ubuntu:18.04 as base

ENV HOME /home/ffettes
ENV UNAME ffettes
ENV SHELL /bin/zsh

# Core apt componenets
RUN \
     apt update && apt install -y sudo tree man \
     vim python3-neovim tmux zsh git ranger

COPY --chown=1000:1000 --from=randomvilliager/docker-apps:content /content/ $HOME/
# installs from content ycm, fzf, oh-my-zsh, bat
RUN \
     apt update && apt install -y curl cmake python3-dev software-properties-common build-essential && \
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
     apt remove curl cmake python3-dev software-properties-common build-essential && apt autoremove

COPY --from=randomvilliager/docker-apps:user /etc/ /etc/
COPY --chown=1000:1000 --from=randomvilliager/docker-apps:user $HOME/.gitconfig $HOME/.gitconfig

RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     # So you can ssh in (if you are authorized)
     # echo "$(which sshd)" >> /startapp.sh && \
     # The next two lines are useful if you map your ssh keys in and want to use github
     # echo "eval `ssh-agent -s`" >> /startapp.sh && \
     # echo "ssh-add ~/.ssh/id_rsa" >> /startapp.sh && \
     # Chown the work folder
     echo "sudo chown -R $UNAME:1000 $HOME/work" && \
     echo "exec /bin/zsh" >> /startapp.sh && \
     chmod +x /startapp.sh
ENTRYPOINT /startapp.sh
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
