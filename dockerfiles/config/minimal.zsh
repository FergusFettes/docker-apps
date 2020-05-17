export ZSH="$USER/.zsh"
export PATH="$PATH":/snap/bin

bindkey '^[n' beginning-of-line
bindkey '^[m' forward-word
bindkey '^[,' forward-char
bindkey '^[.' backward-word
bindkey '^[/' backward-delete-word
bindkey "^[\'" delete-word

alias \?='uname -n'

alias vi=vim
alias dk=docker
alias dc=docker-compose
alias dc-restart="docker-compose down && docker-compose build && docker-compose up -d && docker-compose logs -f"
alias v="vi ."

alias gl='git log --graph --decorate --oneline $(git rev-list -g --all)'
alias glp="git log -p"
alias gll="git pull"

alias x=exit
alias xz="exec zsh"
alias t=tmux
alias tk="tmux attach"
