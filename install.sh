#!/bin/sh

# add golang ppa
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update

# install tools
sudo apt-get install \
  zsh \
  curl \
  git \
  hub \
  wget \
  golang-go \
  fonts-powerline \
  zsh-syntax-highlighting \
  scdaemon \
  -y

# chsh
chsh -s $(which zsh)

# install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install powerline 9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/johanhaleby/kubetail.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/kubetail

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# install config files
SOURCE_DIR=$(dirname "$(readlink -f "$0")")
echo $SOURCE_DIR
TARGET_DIR=$HOME

install_file(){
  echo "Installing $1"
  mkdir -p $TARGET_DIR
  ln -sf $SOURCE_DIR/$1 $TARGET_DIR/$1
}

DOTFILE=.gitconfig
install_file $DOTFILE

DOTFILE=.tmux.conf
install_file $DOTFILE

DOTFILE=.vimrc
install_file $DOTFILE

DOTFILE=.zshrc
install_file $DOTFILE

DOTFILE=gpg-agent.conf
TARGET_DIR=$HOME/.gnupg
install_file $DOTFILE

DOTFILE=config
TARGET_DIR=$HOME/.ssh
install_file $DOTFILE
