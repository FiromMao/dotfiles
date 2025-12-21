#!/bin/bash

# --- 1. Environmental Setup ---
# Get the absolute path of this repository
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)

echo "Setting up your environment..."

# --- 2. Tool Checks ---
# Check if oh-my-zsh is installed, if not, install it quietly
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- 3. Linking Files ---
# Create symbolic links from the repo to the home directory
# ln -sf [Source] [Target]

# Shell configs
ln -sf "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"

# Tool configs
ln -sf "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

echo "All configurations are linked successfully!"
