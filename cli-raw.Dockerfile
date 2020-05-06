# Pull base image.
FROM ubuntu:18.04 as base

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# User config
ENV UID="1000" \
    UNAME="ffettes" \
    GID="1000" \
    GNAME="ffettes" \
    SHELL="/bin/zsh" \
    HOME=/home/ffettes

# User
RUN \
     apt update && apt install -y sudo && \
     # Create HOME dir
     mkdir -p "${HOME}" && \
     chown "${UID}":"${GID}" "${HOME}" && \
     # Create user
     echo "${UNAME}:x:${UID}:${GID}:${UNAME},,,:${HOME}:${SHELL}" \
     >> /etc/passwd && \
     echo "${UNAME}::17032:0:99999:7:::" \
     >> /etc/shadow && \
     # No password sudo
     echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" \
     > "/etc/sudoers.d/${UNAME}" && \
     chmod 0440 "/etc/sudoers.d/${UNAME}" && \
     # Create group
     echo "${GNAME}:x:${GID}:${UNAME}" && \
     >> /etc/group

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
RUN chown -R "${UID}":"${GID}" "${HOME}"

USER $UNAME
WORKDIR $HOME
EXPOSE 22

# install ycm, fzf, oh-my-zsh
RUN \
     cd $HOME/.vim/plugged/youcompleteme/ && \
     python3 install.py --rust-completer && \
     $HOME/.fzf/install && \
     mv $HOME/.oh-my-zsh $HOME/.temp-zsh && \
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
     cp -r $HOME/.temp-zsh/* $HOME/.oh-my-zsh/ && \
     rm -r $HOME/.temp-zsh $HOME/.bashrc

COPY --chown=1000:1000 cli-config "${HOME}"/

USER root
RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     echo "sudo $(which sshd)" >> /startapp.sh && \
     echo "exec /usr/bin/zsh" >> /startapp.sh && \
     chmod +x /startapp.sh
ENTRYPOINT /startapp.sh
USER $UNAME



# Then afterwards run
# RUN /nvim -E -c PlugInstall -c qa!
# And you should be done (make sure you map .vim for persistence)
