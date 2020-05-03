# Pull base image.
FROM ubuntu:18.04

RUN apt update && apt upgrade && apt install -y curl wget build-essential cmake python3-dev \
      vim python3-neovim tmux zsh git \
      python3 python3-pip

# add vim-plug, youcompleteme and fzf
RUN \
     curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
     mkdir /root/.vim/plugged/ -p && \
     git clone --depth 1  https://github.com/Valloric/youcompleteme.git \
     /root/.vim/plugged/youcompleteme && \
     cd /root/.vim/plugged/youcompleteme/ && \
     git submodule update --init --recursive && \
     python3 install.py --rust-completer && \
     git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf && \
     /root/.fzf/install

# Add zsh with plugins
RUN \
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
     git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
     git clone https://github.com/supercrabtree/k ~/.oh-my-zsh/custom/plugins/k && \
     git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
     git clone https://github.com/b4b4r07/enhancd ~/.oh-my-zsh/custom/plugins/enhancd

RUN rm /root/.profile /root/.bashrc /root/.fzf.bash
COPY cli-config /root/

ENTRYPOINT /usr/bin/zsh

# Then afterwards run
# nvim -E -c PlugInstall -c qa!
# And you should be done (make sur eyou map .vim for persistence)
RUN \
      apt install -y software-properties-common && \
      add-apt-repository ppa:jgmath2000/et && \
      apt update && \
      apt install -y et mosh
