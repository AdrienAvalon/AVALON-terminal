#!/bin/bash
# -----------------------------------------------------------------------------
# Script d'installation du terminal-didi
#
# Auteur: Adrien CROS
# Version: 1.4
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

check_command() {
    command -v $1 >/dev/null 2>&1 || { log "La commande $1 est requise, mais elle n'est pas installée.  Aborting." >&2; exit 1; }
}

check_debian_based() {
    if ! grep -q "Debian\|Ubuntu" /etc/issue; then
        log "Ce script ne fonctionne que sur les distributions basées sur Debian (Debian, Ubuntu, etc.)."
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

install_plugin() {
    repo_url=$1
    plugin_dir=$2

    if [ ! -d "$plugin_dir" ]; then
        log "Installation du plugin $(basename $plugin_dir)"
        git clone $repo_url $plugin_dir
    else
        log "Le plugin $(basename $plugin_dir) est déjà installé"
    fi
}

copy_config_files() {
    log "-----------------------------------------"
    log "Copie des fichiers de configuration" 
    log "-----------------------------------------"
    cp $tmux_config_path ~/.tmux.conf
    cp $zsh_config_path ~/.zshrc
}

change_default_shell() {
    log "-----------------------------------------"
    log "Changement du shell par défaut en Zsh" 
    log "-----------------------------------------"
    user=$(whoami)
    sudo chsh -s $(which zsh) $user
}

finish_installation() {
    log "-----------------------------------------"
    log "Toutes les installations sont terminées" 
    log "-----------------------------------------"
}

tmux_config_path="config/.tmux.conf"
zsh_config_path="config/.zshrc"

check_root
check_command git
check_command curl
check_debian_based

update_system
install_dependencies
install_oh_my_zsh

zsh_custom=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
install_plugin "https://github.com/zsh-users/zsh-autosuggestions" "$zsh_custom/plugins/zsh-autosuggestions"
install_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$zsh_custom/plugins/zsh-syntax-highlighting"
install_plugin "https://github.com/zsh-users/zsh-completions" "$zsh_custom/plugins/zsh-completions"

copy_config_files
change_default_shell
finish_installation
