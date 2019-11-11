#!/bin/sh

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
