#!/bin/bash

# Test script to validate the dotfiles installation
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)

echo "🧪 Testing dotfiles installation..."

# Check if required tools are installed
tools=("vim" "git" "curl" "wget" "tmux" "zsh")
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

if command -v fzf &> /dev/null; then
    echo "✅ fzf is installed"
else
    echo "⚠️  fzf is not installed; fuzzy finder integration will be limited"
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
links=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.p10k.zsh" "$HOME/.vimrc" "$HOME/.gitconfig" "$HOME/.tmux.conf" "$HOME/.config/ranger")
for link in "${links[@]}"; do
    if [ -L "$link" ]; then
        echo "✅ $(basename "$link") symlink is created"
    else
        echo "❌ $(basename "$link") symlink is not created"
        exit 1
    fi
done

# Check syntax of linked configs when tools are available
if command -v bash &> /dev/null; then
    bash -n "$DOTFILES_DIR/install.sh" || exit 1
    bash -n "$DOTFILES_DIR/test-install.sh" || exit 1
    bash -n "$DOTFILES_DIR/bash/bashrc" || exit 1
    echo "✅ Bash files pass syntax checks"
fi

if command -v zsh &> /dev/null; then
    zsh -n "$DOTFILES_DIR/zsh/zshrc" || exit 1
    echo "✅ Zsh config passes syntax check"
fi

if command -v python3 &> /dev/null; then
    python3 -m py_compile "$DOTFILES_DIR/ranger/commands.py" || exit 1
    echo "✅ Ranger commands pass Python syntax check"
fi

echo "🎉 All tests passed! Installation is complete."
