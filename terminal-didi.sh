#!/bin/bash
# -----------------------------------------------------------------------------
# Script d'installation du terminal-didi
#
# Auteur: Adrien CROS
# Version: 1.3
#
# Utilisation: ./terminal-didi.sh
# -----------------------------------------------------------------------------

set -e

log() {
    echo "$(date "+%Y-%m-%d %H:%M:%S") [$(basename $0)] $@" | tee -a my_log_file.log
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log "Ce script doit être exécuté en tant que root."
        exit 1
    fi
}

update_system() {
    log "-----------------------------------------"
    log "Mise à jour du système d'exploitation" 
    log "-----------------------------------------"
    apt update && apt upgrade -y
}

install_dependencies() {
    log "-----------------------------------------"
    log "Installation des dépendances nécessaires" 
    log "-----------------------------------------"
    apt install zsh tmux curl -y
}

install_oh_my_zsh() {
    log "-----------------------------------------"
    log "Installation d'Oh My ZSH" 
    log "-----------------------------------------"
    export RUNZSH="no"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_plugins() {
    log "-----------------------------------------"
    log "Installation des plugins omz" 
    log "-----------------------------------------"
    zsh_custom=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
    git clone https://github.com/zsh-users/zsh-autosuggestions $zsh_custom/plugins/zsh-autosuggestions 
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $zsh_custom/plugins/zsh-syntax-highlighting 
    git clone https://github.com/zsh-users/zsh-completions $zsh_custom/plugins/zsh-completions
}

copy_config_files() {
    log "-----------------------------------------"
    log "Copie des fichiers de configuration" 
    log "-----------------------------------------"
    cp config/.tmux.conf ~/.tmux.conf
    cp config/.zshrc ~/.zshrc
}

finish_installation() {
    log "-----------------------------------------"
    log "Toutes les installations sont terminées" 
    log "-----------------------------------------"
}

check_root
update_system
install_dependencies
install_oh_my_zsh
install_plugins
copy_config_files
finish_installation
