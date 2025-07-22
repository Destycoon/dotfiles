#!/bin/bash

DOTFILES_DIR=$(pwd)

echo "Linking dotfiles..."

ln -sf $DOTFILES_DIR/.bashrc ~/.bashrc
ln -sf $DOTFILES_DIR/.zshrc ~/.zshrc
ln -sf $DOTFILES_DIR/.config/kitty ~/.config/kitty
ls -sf $DOTFILES_DIR/starship.toml ~/.config/starship.toml


echo "Done!"
