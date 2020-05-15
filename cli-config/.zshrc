export ZSH="/home/ffettes/.zsh"
export PATH="$PATH":/snap/bin

ZSH_THEME="robbyrussell"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
HYPHEN_INSENSITIVE="true"

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
	zsh-navigation-tools
	k
)

source $ZSH/oh-my-zsh.sh
source ~/.zsh/custom/plugins/enhancd/init.sh
# source /home/ffettes/.config/broot/launcher/bash/br

# Export all the environmental variables
source ~/.config/personal/.zshrc.vars
# Export all the aliases
source ~/.config/personal/.zshrc.alias
# Export all the functions
source ~/.config/personal/.zshrc.func

# User configuration

bindkey '^[n' beginning-of-line
bindkey '^[m' forward-word
bindkey '^[,' forward-char
bindkey '^[.' backward-word
bindkey '^[/' backward-delete-word
bindkey "^[\'" delete-word

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
