#!/bin/bash

# Arquivo de start para instalar Node, JDK, Angular, Python e etc.

echo "Iniciando script de configuração de máquina Ubuntu..."

# Atualiza a lista de pacotes
echo "Atualizando lista de pacotes..."
sudo apt update -y

# Instala Git
echo "Instalando Git..."
sudo apt install -y git

# Instala Docker
echo "Instalando Docker..."
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Adiciona o usuário atual ao grupo docker
echo "Adicionando o usuário '$USER' ao grupo 'docker'..."
sudo usermod -aG docker "$USER"
echo "Para que as permissões do Docker tenham efeito, você precisará fazer logout e login novamente (ou reiniciar a máquina)."

# Instala Mise (alternativa ao NVM/SDKMAN)
echo "Instalando Mise (gerenciador de versões de linguagens)..."
curl https://mise.run | sh
# Adiciona mise ao PATH para a sessão atual e futura no Zsh
if [ -f "$HOME/.zshrc" ]; then
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> "$HOME/.zshrc"
fi
eval "$(~/.local/bin/mise activate zsh)" # Para a sessão atual

# Instala Maven
echo "Instalando Maven..."
sudo apt install -y maven

# Instala Gradle
echo "Instalando Gradle..."
sudo apt install -y gradle

# Instala Vim
echo "Instalando Vim..."
sudo apt install -y vim

# Instala Python 3 e pip
echo "Instalando Python 3 e pip..."
sudo apt install -y python3 python3-pip

# Instala Neovim
echo "Instalando Neovim..."
sudo apt install -y neovim

# Instala Homebrew
echo "Instalando Homebrew (Linuxbrew)..."
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/main/install.sh)"
    # Adiciona Homebrew ao PATH para a sessão atual e futura no Zsh
    if [ -f "$HOME/.zshrc" ]; then
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
    fi
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" # Para a sessão atual
else
    echo "Homebrew já está instalado."
fi

# Instala GCC via Homebrew
echo "Instalando GCC via Homebrew..."
brew install gcc

# Instala Tmux
echo "Instalando Tmux..."
sudo apt install -y tmux

# Instala VS Code
echo "Instalando VS Code..."
sudo apt install -y software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update -y
sudo apt install -y code

# Instalação de aplicativos via Snap (IntelliJ Community, Postman)
echo "Instalando aplicativos via Snap (IntelliJ Community, Postman)..."
sudo snap install intellij-idea-community --classic
sudo snap install postman

# Instala Discord
echo "Baixando e instalando Discord..."
DISCORD_DEB="discord.deb"
wget -O "$DISCORD_DEB" "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y "./$DISCORD_DEB"
rm "$DISCORD_DEB" # Limpa o arquivo .deb após a instalação

# Instala Obsidian
echo "Baixando e instalando Obsidian..."
OBSIDIAN_DEB="obsidian.deb"
wget -O "$OBSIDIAN_DEB" "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.6.3/obsidian-1.6.3.deb" # Verifique a versão mais recente
sudo apt install -y "./$OBSIDIAN_DEB"
rm "$OBSIDIAN_DEB" 

# Instala DBeaver Community
echo "Baixando e instalando DBeaver Community..."
DBEAVER_DEB="dbeaver.deb"
wget -O "$DBEAVER_DEB" "https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
sudo apt install -y "./$DBEAVER_DEB"
rm "$DBEAVER_DEB" 

# Instala Google Chrome
echo "Baixando e instalando Google Chrome..."
CHROME_DEB="google-chrome-stable_current_amd64.deb"
wget -O "$CHROME_DEB" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo apt install -y "./$CHROME_DEB"
rm "$CHROME_DEB" 

# --- Configurações do Zsh e Oh My Zsh ---
echo "Iniciando configurações do Zsh e Oh My Zsh..."

# Verifica se o Zsh já está instalado
if ! command -v zsh &> /dev/null; then
    echo "Zsh não está instalado. Instalando..."
    sudo apt update -y
    sudo apt install -y zsh
else
    echo "Zsh já está instalado."
fi

# Verifica se o Oh My Zsh já está instalado e instala de forma não interativa
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh não está instalado. Instalando..."
    # Usar --unattended para evitar perguntas interativas
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh já está instalado."
fi

# Instalação do plugin zsh-autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "Plugin zsh-autosuggestions não está instalado. Instalando..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
else
    echo "Plugin zsh-autosuggestions já está instalado."
fi

# Configura Zsh como shell padrão
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Configurando Zsh como shell padrão..."
    chsh -s "$(which zsh)"
    echo "Zsh configurado como shell padrão. Você precisará fazer logout e login novamente (ou reiniciar a máquina) para que a alteração tenha efeito."
else
    echo "Zsh já é o shell padrão."
fi

# Configuração do arquivo .zshrc
echo "Configurando plugins e tema do Oh My Zsh no .zshrc..."
# Garante que o tema seja agnoster
sed -i 's/^ZSH_THEME=.*$/ZSH_THEME="agnoster"/' "$HOME/.zshrc"
# Garante que os plugins incluem git e zsh-autosuggestions
sed -i 's/^plugins=(.*)$/plugins=(git zsh-autosuggestions)/' "$HOME/.zshrc"

echo "Instalação e configuração do Zsh e plugins concluídas!"
echo "---------------------------------------------------------"
echo "Script de configuração finalizado."
echo "LEMBRE-SE: Você precisa fazer logout e login novamente (ou reiniciar a máquina)"
echo "para que as permissões do Docker, o Zsh como shell padrão e as configurações do Mise tenham efeito."
echo "---------------------------------------------------------"
