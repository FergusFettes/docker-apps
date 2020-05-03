# Pull base image.
FROM jlesage/baseimage:ubuntu-18.04

# install basic packages for cli dev TODO: once ubuntu 2020 is out, change to kitty
RUN \
     add-pkg vim python3-neovim tmux zsh git curl wget build-essential cmake python3-dev

# # add vim-plug
# RUN \
#      add-pkg --virtual deps curl && \
#      curl -fLo /default/.local/share/nvim/site/autoload/plug.vim --create-dirs \
#      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# RUN \
#      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#      # del-pkg deps

# # Install zsh plugins
# RUN \
#      git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
#      git clone https://github.com/supercrabtree/k ~/.oh-my-zsh/custom/plugins/k
#      git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
#      git clone https://github.com/b4b4r07/enhancd ~/.oh-my-zsh/custom/plugins/enhancd

COPY cli-config /defaults/
RUN \
     echo "#!/bin/sh" > /startapp.sh && \
     echo "export HOME=/defaults" >> /startapp.sh && \
     echo "exec /usr/bin/zsh" >> /startapp.sh
ENV \
     APP_NAME="CLI"
