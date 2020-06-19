#
# https://github.com/fergusfettes/docker-apps
#
FROM alpine:latest AS base
RUN \
     mkdir -p /content/.vim /content/.debs /content/.zsh /content/.local
ARG HOME=/content

FROM alpine:latest AS curl
RUN apk add curl
RUN \
     mkdir -p /content/.vim /content/.debs /content/.zsh /content/.local
ARG HOME=/content

RUN \
     # get debs for bat and ripgrep
     curl -fsSLo $HOME/.debs/bat.deb --create-dirs \
     https://github.com/sharkdp/bat/releases/download/v0.15.0/bat_0.15.0_amd64.deb && \
     curl -fsSLo $HOME/.debs/ripgrep.deb --create-dirs \
     https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb && \
     # Add zsh install script
     curl -fsSLo $HOME/.zsh/install.sh --create-dirs \
     https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh && \
     # add vim-plug
     curl -fsSLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

FROM alpine/git:latest AS git
RUN \
     mkdir -p /content/.vim /content/.debs /content/.zsh /content/.local
ARG HOME=/content

# Install bat extras
RUN \
     git clone https://github.com/eth-p/bat-extras $HOME/.local

# Add zsh plugins
RUN \
     git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/custom/plugins/zsh-autosuggestions && \
     git clone https://github.com/supercrabtree/k $HOME/.zsh/custom/plugins/k && \
     git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.zsh/custom/plugins/zsh-syntax-highlighting && \
     git clone https://github.com/b4b4r07/enhancd $HOME/.zsh/custom/plugins/enhancd

# my vim plugins
RUN \
     git clone --depth 1  https://github.com/valloric/youcompleteme.git $HOME/.vim/plugged/youcompleteme && \
     cd $HOME/.vim/plugged/youcompleteme/ && \
     git submodule update --init --recursive && \
     git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
     cd $HOME/.vim/plugged && \
     # Silver Searcher
     # TODO: properly try out these search tools and choose one
     git clone --depth 1 https://github.com/rking/ag.vim && \
     # git clone --depth 1 https://github.com/vim-scripts/EasyGrep && \
     # CtrlP --fuzzy file searcher
     git clone --depth 1 https://github.com/ctrlpvim/ctrlp.vim && \
     # Git-related
     git clone --depth 1 https://github.com/airblade/vim-gitgutter && \
     git clone --depth 1 https://github.com/tpope/vim-fugitive && \
     # Fancy status bar
     git clone --depth 1 https://github.com/vim-airline/vim-airline && \
     git clone --depth 1 https://github.com/vim-airline/vim-airline-themes && \
     # Goyo, beautiful reading mode
     git clone --depth 1 https://github.com/junegunn/goyo.vim && \
     git clone --depth 1 https://github.com/junegunn/limelight.vim && \
     # Linter
     # TODO: maybe ty out syntasti at some point
     git clone --depth 1 https://github.com/w0rp/ale && \
     # git clone --depth 1 https://github.com/scrooloose/syntastic && \
     # Other
     git clone --depth 1 https://github.com/ntpeters/vim-better-whitespace && \
     git clone --depth 1 https://github.com/godlygeek/tabular && \
     git clone --depth 1 https://github.com/nathanaelkane/vim-indent-guides && \
     git clone --depth 1 https://github.com/tpope/vim-commentary && \
     git clone --depth 1 https://github.com/Raimondi/delimitMate && \
     git clone --depth 1 https://github.com/sheerun/vim-polyglot && \
     # Close buffers
     git clone --depth 1 https://github.com/Asheq/close-buffers.vim && \
     # TODO: try these two out
     git clone --depth 1 https://github.com/mbbill/undotree && \
     git clone --depth 1 https://github.com/majutsushi/tagbar && \
     # git clone --depth 1 https://github.com/vim-scripts/taglist.vim && \
     # number converter
     # TODO: try out radical and surround
     git clone --depth 1 https://github.com/tpope/vim-repeat && \
     git clone --depth 1 https://github.com/tpope/vim-surround && \
     git clone --depth 1 https://github.com/glts/vim-magnum.git && \
     git clone --depth 1 https://github.com/glts/vim-radical.git && \
     # TODO: get to know this one and fix registers forever
     git clone --depth 1 https://github.com/svermeulen/vim-easyclip && \
     git clone --depth 1 https://github.com/easymotion/vim-easymotion && \
     #  rust
     #  Vim racer
     # git clone --depth 1 https://github.com/racer-rust/vim-racer && \
     #  Plugs I want to check out at some point:
     # git clone --depth 1 https://github.com/skanehira/docker.vim && \
     # git clone --depth 1 https://github.com/ivanov/vim-ipython && \
     #
     # Track the engine.
     # git clone --depth 1 https://github.com/SirVer/ultisnips && \
     # Snippets are separated from the engine. Add this if you want them:
     # git clone --depth 1 https://github.com/honza/vim-snippets && \
     #  Slimv
     # git clone --depth 1 https://github.com/kovisoft/slimv && \
     # git clone --depth 1 https://github.com/terryma/vim-expand-region && \
     # git clone --depth 1 https://github.com/michaeljsmith/vim-indent-object && \
     # Theme
     git clone --depth 1 https://github.com/junegunn/seoul256.vim

FROM base
COPY --from=curl /content/ /content/
COPY --from=git /content/ /content/

# Metadata.
ARG IMAGE_VERSION=helper
LABEL \
      org.label-schema.name="terminal-content" \
      org.label-schema.description="All my terminal content that needs to be curled, wgetted or git cloned" \
      org.label-schema.version="${IMAGE_VERSION}" \
      org.label-schema.vcs-url="https://github.com/fergusfettes/docker-apps" \
      org.label-schema.schema-version="1.0"
