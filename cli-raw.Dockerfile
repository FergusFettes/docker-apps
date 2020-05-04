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
    UHOME=/home/ffettes

# User
RUN \
     apt update && apt install -y sudo && \
     # Create HOME dir
     mkdir -p "${UHOME}" && \
     chown "${UID}":"${GID}" "${UHOME}" && \
     # Create user
     echo "${UNAME}:x:${UID}:${GID}:${UNAME},,,:${UHOME}:${SHELL}" \
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
     curl -fLo $UHOME/.installs/bat.deb --create-dirs \
     https://github.com/sharkdp/bat/releases/download/v0.15.0/bat_0.15.0_amd64.deb && \
     dpkg -i $UHOME/.installs/bat.deb && \
     add-apt-repository ppa:jgmath2000/et && \
     apt install -y et mosh

FROM ubuntu:18.04 as content

ARG UHOME=/content
RUN \
     apt update && apt upgrade && apt install -y curl git

# add vim-plug, youcompleteme and fzf
RUN \
     curl -fLo $UHOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
     mkdir $UHOME/.vim/plugged/ -p && \
     git clone --depth 1  https://github.com/Valloric/youcompleteme.git \
     $UHOME/.vim/plugged/youcompleteme && \
     cd $UHOME/.vim/plugged/youcompleteme/ && \
     git submodule update --init --recursive && \
     git clone --depth 1 https://github.com/junegunn/fzf.git $UHOME/.fzf

# Add zsh plugins
RUN \
     git clone https://github.com/zsh-users/zsh-autosuggestions $UHOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
     git clone https://github.com/supercrabtree/k $UHOME/.oh-my-zsh/custom/plugins/k && \
     git clone https://github.com/zsh-users/zsh-syntax-highlighting $UHOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
     git clone https://github.com/b4b4r07/enhancd $UHOME/.oh-my-zsh/custom/plugins/enhancd


FROM base

COPY --from=content /content $UHOME

RUN chown -R "${UID}":"${GID}" "${UHOME}"
USER ffettes

# install ycm, fzf, oh-my-zsh
RUN \
     cd $UHOME/.vim/plugged/youcompleteme/ && \
     python3 install.py --rust-completer && \
     $UHOME/.fzf/install

RUN \
     mv $UHOME/.oh-my-zsh $UHOME/.temp-zsh && \
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
     cp -r $UHOME/.temp-zsh/* $UHOME/.oh-my-zsh/ && \
     rm -r $UHOME/.temp-zsh

COPY --chown=$UID:$GID cli-config $UHOME/

WORKDIR $UHOME
ENTRYPOINT /usr/bin/zsh

RUN rm $UHOME/.bashrc #need to sort our the home for the ssh incomers and delete all the spare conifgs

# Then afterwards run
# nvim -E -c PlugInstall -c qa!
# And you should be done (make sure you map .vim for persistence)

EXPOSE 22
