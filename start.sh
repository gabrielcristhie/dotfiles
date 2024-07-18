#!/bin/bash

#Arquivo de start para instalar Node, JDK , Angular, Python e etc.

# Update package list
sudo apt update

# Install Git
sudo apt install -y git

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Install JDK 11
sudo apt install -y openjdk-11-jdk

# Install Vim
sudo apt install -y vim

# Install Node.js LTS
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs

# Install Python 3
sudo apt install -y python3 python3-pip

# Install Neovim
sudo apt install -y neovim

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/main/install.sh)"

# Install GCC
brew install gcc

# Install Tmux
sudo apt install -y tmux

# Install PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Install MySQL
sudo apt install -y mysql-server

# Verifica se o Zsh já está instalado
if ! command -v zsh &> /dev/null; then
    echo "Zsh não está instalado. Instalando..."
    sudo apt update
    sudo apt install -y zsh
fi

# Verifica se o Oh My Zsh já está instalado
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh não está instalado. Instalando..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Instalação do plugin zsh-autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "Plugin zsh-autosuggestions não está instalado. Instalando..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

# Configura Zsh como shell padrão
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Configurando Zsh como shell padrão..."
    chsh -s "$(which zsh)"
fi

# Configuração do arquivo .zshrc
echo "Configurando plugins e tema do Oh My Zsh..."
sed -i 's/ZSH_THEME=.*/ZSH_THEME="agnoster"/' ~/.zshrc
sed -i 's/plugins=.*/plugins=(git zsh-autosuggestions)/' ~/.zshrc

echo "Instalação e configuração do Zsh e plugins concluídas"
