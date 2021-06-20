# tmux-didi
Environnement tmux + zsh avec scripts personnels

Utilisation de :

- TMUX
- ZSH
- Oh-My-ZSH
- zsh-Autosuggestions
- zsh-Syntax-Highlighting
- zsh-Completions


Procédure :

* apt install zsh
* apt install tmux
* apt install git
* apt install curl

* sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
* git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
* git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
* git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions