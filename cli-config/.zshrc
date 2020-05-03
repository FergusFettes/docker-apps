ZSH_THEME="robbyrussell"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
HYPHEN_INSENSITIVE="true"

plugins=(
	git
	colored-man-pages
	zsh-syntax-highlighting
	zsh-autosuggestions
	zsh-navigation-tools
	k
)

# Export all the environmental variables
source ~/.config/personal/.zshrc.vars
# Export all the aliases
source ~/.config/personal/.zshrc.alias
# Export all the functions
source ~/.config/personal/.zshrc.func

source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/custom/plugins/enhancd/init.sh
# source ~/.config/broot/launcher/bash/br

bindkey '^[n' beginning-of-line
bindkey '^[m' forward-word
bindkey '^[,' forward-char
bindkey '^[.' backward-word
bindkey '^[/' backward-delete-word
bindkey "^[\'" delete-word
