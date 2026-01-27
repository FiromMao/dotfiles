#!/bin/bash

# Test script to validate the dotfiles installation
echo "🧪 Testing dotfiles installation..."

# Check if required tools are installed
tools=("vim" "git" "curl" "wget" "tmux" "zsh" "fzf")
missing_tools=()

for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        missing_tools+=("$tool")
    fi
done

if [ ${#missing_tools[@]} -gt 0 ]; then
    echo "❌ Missing tools: ${missing_tools[*]}"
    exit 1
else
    echo "✅ All required tools are installed"
fi

# Check if oh-my-zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ oh-my-zsh is installed"
else
    echo "❌ oh-my-zsh is not installed"
    exit 1
fi

# Check if oh-my-zsh plugins are installed
plugins=("powerlevel10k" "zsh-syntax-highlighting" "zsh-autosuggestions" "zsh-completions")
for plugin in "${plugins[@]}"; do
    if [ -d "$HOME/.oh-my-zsh/custom/$plugin" ] || [ -d "$HOME/.oh-my-zsh/custom/themes/$plugin" ] || [ -d "$HOME/.oh-my-zsh/custom/plugins/$plugin" ]; then
        echo "✅ $plugin is installed"
    else
        echo "❌ $plugin is not installed"
        exit 1
    fi
done

# Check if vim-plug is installed
if [ -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "✅ vim-plug is installed"
else
    echo "❌ vim-plug is not installed"
    exit 1
fi

# Check if symbolic links are created
links=("$HOME/.zshrc" "$HOME/.vimrc" "$HOME/.gitconfig" "$HOME/.tmux.conf")
for link in "${links[@]}"; do
    if [ -L "$link" ]; then
        echo "✅ $(basename "$link") symlink is created"
    else
        echo "❌ $(basename "$link") symlink is not created"
        exit 1
    fi
done

echo "🎉 All tests passed! Installation is complete."