#!/bin/bash

# -----------------------------------------------------------------------------
# Script d'installation du terminal-didi
#
# Auteur: Adrien CROS
# Version: 1.6
#
# Utilisation: ./terminal-didi.sh
# -----------------------------------------------------------------------------

set -e

# Fonction pour logger les messages avec un timestamp
log() {
    echo "$(date "+%Y-%m-%d %H:%M:%S") [$(basename $0)] $@" | tee -a my_log_file.log
}

# Vérifie si le script est exécuté en tant que root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log "Ce script doit être exécuté en tant que root."
        exit 1
    fi
}

# Vérifie si une commande est disponible sur le système
check_command() {
    command -v $1 >/dev/null 2>&1 || { log "La commande $1 est requise, mais elle n'est pas installée.  Aborting." >&2; exit 1; }
}

# Vérifie si le script est exécuté sur une distribution basée sur Debian
check_debian_based() {
    if ! grep -q "Debian\|Ubuntu" /etc/issue; then
        log "Ce script ne fonctionne que sur les distributions basées sur Debian (Debian, Ubuntu, etc.)."
        exit 1
    fi
}

# Met à jour le système d'exploitation
update_system() {
    log "-----------------------------------------"
    log "Mise à jour du système d'exploitation" 
    log "-----------------------------------------"
    apt update && apt upgrade -y
}

# Installe les dépendances nécessaires
install_dependencies() {
    log "-----------------------------------------"
    log "Installation des dépendances nécessaires" 
    log "-----------------------------------------"
    apt install zsh tmux curl git -y
}

# Installe Oh My Zsh
install_oh_my_zsh() {
    log "-----------------------------------------"
    log "Installation d'Oh My ZSH" 
    log "-----------------------------------------"
    export RUNZSH="no"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Installe un plugin Oh My Zsh
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

# Ajoute un plugin à .zshrc s'il n'est pas déjà activé
add_plugin_to_zshrc() {
    plugin_name=$1

    if ! grep -q "$plugin_name" ~/.zshrc; then
        log "Ajout du plugin $plugin_name à .zshrc"
        sed -i.bak "s/plugins=(/plugins=($plugin_name /" ~/.zshrc
    else
        log "Le plugin $plugin_name est déjà activé dans .zshrc"
    fi
}

# Sauvegarde les fichiers de configuration existants
backup_existing_config() {
    file_path=$1
    backup_path="${file_path}.bak"
    
    if [ -f "$file_path" ]; then
        log "Sauvegarde du fichier de configuration existant : $file_path"
        cp "$file_path" "$backup_path"
    fi
}

# Copie les fichiers de configuration
copy_config_files() {
    log "-----------------------------------------"
    log "Copie des fichiers de configuration" 
    log "-----------------------------------------"
    backup_existing_config ~/.tmux.conf
    backup_existing_config ~/.zshrc
    cp $tmux_config_path ~/.tmux.conf
    cp $zsh_config_path ~/.zshrc
}

# Change le shell par défaut en Zsh
change_default_shell() {
    log "-----------------------------------------"
    log "Changement du shell par défaut en Zsh" 
    log "-----------------------------------------"
    user=$(whoami)
    chsh -s $(which zsh) $user
}

# Termine l'installation
finish_installation() {
    log "-----------------------------------------"
    log "Toutes les installations sont terminées" 
    log "-----------------------------------------"
}

tmux_config_path="config/.tmux.conf"
zsh_config_path="config/.zshrc"
autosuggestions_url="https://github.com/zsh-users/zsh-autosuggestions"
syntax_highlighting_url="https://github.com/zsh-users/zsh-syntax-highlighting.git"
completions_url="https://github.com/zsh-users/zsh-completions"

check_root
check_command git
check_command curl
check_debian_based

update_system
install_dependencies
install_oh_my_zsh

zsh_custom=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
install_plugin "$autosuggestions_url" "$zsh_custom/plugins/zsh-autosuggestions"
install_plugin "$syntax_highlighting_url" "$zsh_custom/plugins/zsh-syntax-highlighting"
install_plugin "$completions_url" "$zsh_custom/plugins/zsh-completions"

add_plugin_to_zshrc "zsh-autosuggestions"
add_plugin_to_zshrc "zsh-syntax-highlighting"
add_plugin_to_zshrc "zsh-completions"

copy_config_files
change_default_shell
finish_installation
