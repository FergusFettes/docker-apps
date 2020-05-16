# Pull base image.
FROM ubuntu:18.04 as base

ENV HOME /home/ffettes
ENV UNAME ffettes
ENV SHELL /bin/zsh

# Core apt componenets
RUN \
     apt update && apt install -y sudo tree man ncdu zip unzip \
     vim python3-neovim tmux zsh git ranger

COPY --chown=1000:1000 --from=ffettes/cli:content /content/ $HOME/
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
     apt remove -y curl cmake python3-dev software-properties-common build-essential && apt autoremove -y

COPY --from=ffettes/cli:user /etc/ /etc/
COPY --chown=1000:1000 --from=ffettes/cli:user $HOME/.gitconfig $HOME/.gitconfig
COPY --chown=1000:1000 config $HOME/

ENV UID=1000
ENV GID=1000
COPY script/usermod.sh /usr/bin/mod_user_id

RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     # Chown the work folder
     echo "mod_user_id"
     echo "sudo chown -R $UID:$GID $HOME/work" >> && \
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
