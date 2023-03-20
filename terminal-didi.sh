#!/bin/bash
# -----------------------------------------------------------------------------
# Script d'installation du terminal-didi
#
# Auteur: Adrien CROS
# Version: 1.2
#
# Utilisation: ./terminal-didi.sh
# -----------------------------------------------------------------------------

echo "-----------------------------------------"
echo "Mise à jour du système d'exploitation" 
echo "-----------------------------------------"
apt update && apt upgrade -y

echo "-----------------------------------------"
echo "Installation des dépendances nécessaires" 
echo "-----------------------------------------"
apt install zsh tmux curl -y

echo "-----------------------------------------"
echo "Installation d'Oh My ZSH" 
echo "-----------------------------------------"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "-----------------------------------------"
echo "Installation des plugins omz" 
echo "-----------------------------------------"
zsh_custom=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
git clone https://github.com/zsh-users/zsh-autosuggestions $zsh_custom/plugins/zsh-autosuggestions 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $zsh_custom/plugins/zsh-syntax-highlighting 
git clone https://github.com/zsh-users/zsh-completions $zsh_custom/plugins/zsh-completions

echo "-----------------------------------------"
echo "Copie des fichiers de configuration" 
echo "-----------------------------------------"
cp config/.tmux.conf ~/.tmux.conf
cp config/.zshrc ~/.zshrc

echo "-----------------------------------------"
echo "Toutes les installations sont terminées" 
echo "-----------------------------------------"
