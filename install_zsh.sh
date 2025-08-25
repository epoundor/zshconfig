#!/usr/bin/env bash

# Quitter en cas d'erreur
set -e

# Vérifie que git et curl sont installés
if ! command -v git &> /dev/null; then
    echo "git n'est pas installé. Installation..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y git
    elif command -v yum &> /dev/null; then
        sudo yum install -y git
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y git
    else
        echo "Veuillez installer git manuellement."
        exit 1
    fi
fi

if ! command -v curl &> /dev/null; then
    echo "curl n'est pas installé. Installation..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y curl
    elif command -v yum &> /dev/null; then
        sudo yum install -y curl
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y curl
    else
        echo "Veuillez installer curl manuellement."
        exit 1
    fi
fi

# Installation de zsh si nécessaire
if ! command -v zsh &> /dev/null; then
    echo "zsh n'est pas installé. Installation..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y zsh
    elif command -v yum &> /dev/null; then
        sudo yum install -y zsh
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y zsh
    else
        echo "Veuillez installer zsh manuellement."
        exit 1
    fi
fi

# Installation de Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installation de Oh My Zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh déjà installé."
fi

# Installation des plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installation de zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installation de zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

# Installation du thème Powerlevel10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Installation du thème Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

# Configuration du .zshrc
echo "Mise à jour du fichier .zshrc..."

# Met le thème bira
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="bira"/' ~/.zshrc || echo 'ZSH_THEME="bira"' >> ~/.zshrc



# Ajoute les plugins
if grep -q "^plugins=" ~/.zshrc; then
    sed -i 's/^plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
else
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc
fi

echo "Installation terminée ✅"
echo "👉 Pour activer zsh par défaut : chsh -s $(which zsh)"
echo "👉 Recharge ton shell avec : exec zsh"
