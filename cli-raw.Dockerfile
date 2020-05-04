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
     apt update && apt install -y man tree locales openssh-server curl wget build-essential cmake python3-dev \
     vim python3-neovim tmux zsh git \
     python3 python3-pip && \
     locale-gen en_US.UTF-8 && \
     mkdir /var/run/sshd && \
     sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

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

# install ycm, fzf, oh-my-zsh
RUN \
     cd $UHOME/.vim/plugged/youcompleteme/ && \
     python3 install.py --rust-completer && \
     $UHOME/.fzf/install && \
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN rm $UHOME/.profile $UHOME/.bashrc $UHOME/.fzf.bash
COPY cli-config $UHOME/

ENTRYPOINT /usr/bin/zsh

# Then afterwards run
# nvim -E -c PlugInstall -c qa!
# And you should be done (make sur eyou map .vim for persistence)
RUN \
      apt install -y software-properties-common && \
      add-apt-repository ppa:jgmath2000/et && \
      apt update && \
      apt install -y et mosh

EXPOSE 22
