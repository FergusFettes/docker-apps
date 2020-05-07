#
# https://github.com/fergusfettes/docker-apps
#
FROM ubuntu:18.04
RUN \
     apt update && apt install -y curl wget git

RUN \
     mkdir /root/.vim /root/.debs /root/.zsh /root/.local
ARG HOME=/root

# clone debs
RUN \
     curl -fLo $HOME/.debs/bat.deb --create-dirs \
     https://github.com/sharkdp/bat/releases/download/v0.15.0/bat_0.15.0_amd64.deb

# Add zsh plugins
RUN \
     git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/custom/plugins/zsh-autosuggestions && \
     git clone https://github.com/supercrabtree/k $HOME/.zsh/custom/plugins/k && \
     git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.zsh/custom/plugins/zsh-syntax-highlighting && \
     git clone https://github.com/b4b4r07/enhancd $HOME/.zsh/custom/plugins/enhancd

# Add zsh install script
RUN \
     curl -fsSLo $HOME/.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

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

# my vim plugins
RUN \
     'git clone --depth 1 https://github.com/scrooloose/nerdtree'
     # Silver Searcher
     'git clone --depth 1 https://github.com/rking/ag.vim'
     # CtrlP --fuzzy file searcher
     'git clone --depth 1 https://github.com/ctrlpvim/ctrlp.vim'
     # Git-related
     'git clone --depth 1 https://github.com/airblade/vim-gitgutter'
     'git clone --depth 1 https://github.com/Xuyuanp/nerdtree-git-plugin'
     'git clone --depth 1 https://github.com/tpope/vim-fugitive'
     # Fancy status bar
     'git clone --depth 1 https://github.com/vim-airline/vim-airline'
     'git clone --depth 1 https://github.com/vim-airline/vim-airline-themes'
     # Goyo, beautiful reading mode
     'git clone --depth 1 https://github.com/junegunn/goyo.vim'
     'git clone --depth 1 https://github.com/junegunn/limelight.vim'
     'git clone --depth 1 https://github.com/junegunn/seoul256.vim'
     # Linter
     'git clone --depth 1 https://github.com/w0rp/ale'
     # Other
     'git clone --depth 1 https://github.com/ntpeters/vim-better-whitespace'
     'git clone --depth 1 https://github.com/tpope/vim-commentary'
     'git clone --depth 1 https://github.com/Raimondi/delimitMate'
     'git clone --depth 1 https://github.com/sheerun/vim-polyglot'
     # Close buffers
     'git clone --depth 1 https://github.com/Asheq/close-buffers.vim'
     #  rust
     #  Vim racer
     'git clone --depth 1 https://github.com/racer-rust/vim-racer'
     #  Plugs I want to check out at some point:
     # 'git clone --depth 1 https://github.com/skanehira/docker.vim'
     # 'git clone --depth 1 https://github.com/ivanov/vim-ipython'
     #
     # Track the engine.
     # 'git clone --depth 1 https://github.com/SirVer/ultisnips'
     # Snippets are separated from the engine. Add this if you want them:
     # 'git clone --depth 1 https://github.com/honza/vim-snippets'
     #  Slimv
     # 'git clone --depth 1 https://github.com/kovisoft/slimv'




# Bunch of vim plugs from elsewhere
# RUN \
#     git clone --depth 1 https://github.com/pangloss/vim-javascript && \
#     git clone --depth 1 https://github.com/scrooloose/nerdcommenter && \
#     git clone --depth 1 https://github.com/godlygeek/tabular && \
#     git clone --depth 1 https://github.com/nathanaelkane/vim-indent-guides && \
#     git clone --depth 1 https://github.com/groenewege/vim-less && \
#     git clone --depth 1 https://github.com/othree/html5.vim && \
#     git clone --depth 1 https://github.com/elzr/vim-json && \
#     git clone --depth 1 https://github.com/easymotion/vim-easymotion && \
#     git clone --depth 1 https://github.com/mbbill/undotree && \
#     git clone --depth 1 https://github.com/majutsushi/tagbar && \
#     git clone --depth 1 https://github.com/vim-scripts/EasyGrep && \
#     git clone --depth 1 https://github.com/jlanzarotta/bufexplorer && \
#     git clone --depth 1 https://github.com/jistr/vim-nerdtree-tabs && \
#     git clone --depth 1 https://github.com/scrooloose/syntastic && \
#     git clone --depth 1 https://github.com/tomtom/tlib_vim && \
#     git clone --depth 1 https://github.com/marcweber/vim-addon-mw-utils && \
#     git clone --depth 1 https://github.com/vim-scripts/taglist.vim && \
#     git clone --depth 1 https://github.com/terryma/vim-expand-region && \
#     git clone --depth 1 https://github.com/fatih/vim-go && \
#     git clone --depth 1 https://github.com/plasticboy/vim-markdown && \
#     git clone --depth 1 https://github.com/michaeljsmith/vim-indent-object && \
#     git clone --depth 1 https://github.com/terryma/vim-multiple-cursors && \
#     git clone --depth 1 https://github.com/tpope/vim-repeat && \
#     git clone --depth 1 https://github.com/tpope/vim-surround && \
#     git clone --depth 1 https://github.com/vim-scripts/mru.vim && \
#     git clone --depth 1 https://github.com/vim-scripts/YankRing.vim && \
#     git clone --depth 1 https://github.com/tpope/vim-haml && \
#     git clone --depth 1 https://github.com/derekwyatt/vim-scala && \
#     git clone --depth 1 https://github.com/christoomey/vim-tmux-navigator && \
#     git clone --depth 1 https://github.com/ekalinin/Dockerfile.vim && \
# # Theme
#     git clone --depth 1 https://github.com/altercation/vim-colors-solarized

# Metadata.
ARG IMAGE_VERSION=unknown
LABEL \
      org.label-schema.name="terminal-content" \
      org.label-schema.description="All my terminal content that needs to be curled, wgetted or git cloned" \
      org.label-schema.version="${IMAGE_VERSION}" \
      org.label-schema.vcs-url="https://github.com/fergusfettes/docker-apps" \
      org.label-schema.schema-version="1.0"
