##########################
#       .zshrc DIDI      #
##########################

# Path to your oh-my-zsh installation.
export ZSH="/root/.oh-my-zsh"

ZSH_THEME="obraun"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

plugins=(
git
dnf
zsh-autosuggestions
zsh-syntax-highlighting
zsh-completions
tmux)

source $ZSH/oh-my-zsh.sh

#########################
#       DIDI ZSH        #
#########################

# Lancement TMUX en même temps que ZSH
if [ -z "$TMUX" ]; then
    tmux attach -t $SUDO_USER || tmux new -s $SUDO_USER
fi

# Affichage du MOTD
cat /etc/motd