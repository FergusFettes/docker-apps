# Pull base image.
FROM jlesage/baseimage:ubuntu-18.04

# install basic packages for cli dev TODO: once ubuntu 2020 is out, change to kitty
RUN \
     apt update && apt install -y man tree locales openssh-server curl wget build-essential cmake python3-dev software-properties-common \
     vim python3-neovim tmux zsh git \
     python3 python3-pip && \
     locale-gen en_US.UTF-8 && \
     mkdir /var/run/sshd && \
     sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
     curl -fLo $HOME/.installs/bat.deb --create-dirs \
     https://github.com/sharkdp/bat/releases/download/v0.15.0/bat_0.15.0_amd64.deb && \
     dpkg -i $HOME/.installs/bat.deb && \
     add-apt-repository ppa:jgmath2000/et && \
     apt install -y et mosh

FROM ubuntu:18.04 as content

ARG HOME=/content
RUN \
     apt update && apt upgrade && apt install -y curl git

# add vim-plug, youcompleteme and fzf
RUN \
     curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
     mkdir $HOME/.vim/plugged/ -p && \
     git clone --depth 1  https://github.com/valloric/youcompleteme.git \
     $HOME/.vim/plugged/youcompleteme && \
     cd $HOME/.vim/plugged/youcompleteme/ && \
     git submodule update --init --recursive && \
     git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf

# Add zsh plugins
RUN \
     git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
     git clone https://github.com/supercrabtree/k $HOME/.oh-my-zsh/custom/plugins/k && \
     git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
     git clone https://github.com/b4b4r07/enhancd $HOME/.oh-my-zsh/custom/plugins/enhancd


FROM base

COPY --from=content /content $HOME

# install ycm, fzf, oh-my-zsh
RUN \
     cd $HOME/.vim/plugged/youcompleteme/ && \
     python3 install.py && \
     $HOME/.fzf/install && \
     mv $HOME/.oh-my-zsh $HOME/.temp-zsh && \
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
     cp -r $HOME/.temp-zsh/* $HOME/.oh-my-zsh/ && \
     rm -r $HOME/.temp-zsh $HOME/.bashrc

COPY cli-config /defaults/
RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     echo "sudo $(which sshd)" >> /startapp.sh && \
     echo "exec /usr/bin/zsh" >> /startapp.sh
ENV \
     APP_NAME="CLI"
