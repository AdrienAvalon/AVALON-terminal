#!/bin/bash
# Script d'installation du terminal-didi
#
# Auteur: Adrien CROS
# Version: 1.1
#
# Utilisation: ./terminal-didi.sh
# -----------------------------------------------------------------------------

echo "Script d'installation du terminal de DIDI"
echo "-----------------------------------------"
echo "Mise à jour du système d'exploitation"
apt update && apt upgrade
echo "Installation des dépendance nécessaire"
apt install zsh -y && apt install tmux -y && apt install curl -y

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions