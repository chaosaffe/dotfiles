#!/bin/sh

CURRENT_DIR=$(pwd)
TARGET_DIR=$HOME

install_file(){
  echo "Installing $1"
  ln -s $CURRENT_DIR/$1 $TARGET_DIR/$1
}

DOTFILE=.zshrc
install_file $DOTFILE
DOTFILE=.gitconfig
install_file $DOTFILE
DOTFILE=.vimrc
install_file $DOTFILE
