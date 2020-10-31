#!/bin/sh

# add golang ppa
sudo add-apt-repository ppa:longsleep/golang-backports

sudo apt update

sudo apt-get remove docker docker-engine docker.io containerd runc

# install tools
sudo apt-get install \
  zsh \
  curl \
  git \
  hub \
  wget \
  golang-go \
  fonts-powerline \
  scdaemon \
  tmux \
  apt-transport-https \
  ca-certificates \
  gnupg-agent \
  software-properties-common \
  xclip \
  bat \
  -y

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

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

dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

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

# chsh
chsh -s $(which tmux)
