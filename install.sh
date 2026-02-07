#!/bin/bash

# --- 1. Environmental Setup ---
# Get the absolute path of this repository
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)

echo "🚀 Setting up your environment..."

# --- 2. System Package Installation ---
# Detect package manager and install dependencies
install_packages() {
    echo "📦 Installing system packages..."
    
    if command -v apt-get &> /dev/null; then
        # Ubuntu/Debian
        echo "Detected Ubuntu/Debian system"
        sudo apt-get update
        sudo apt-get install -y vim git curl wget tmux fzf fd-find bat autojump build-essential ranger
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        echo "Detected CentOS/RHEL system"
        sudo yum update -y
        sudo yum install -y vim git curl wget tmux fzf fd-find bat autojump gcc gcc-c++ make ranger
    elif command -v dnf &> /dev/null; then
        # Fedora
        echo "Detected Fedora system"
        sudo dnf update -y
        sudo dnf install -y vim git curl wget tmux fzf fd-find bat autojump gcc gcc-c++ make ranger
    elif command -v pacman &> /dev/null; then
        # Arch Linux
        echo "Detected Arch Linux system"
        sudo pacman -Sy --noconfirm
        sudo pacman -S --noconfirm vim git curl wget tmux fzf fd bat autojump base-devel ranger
    else
        echo "❌ Unsupported package manager. Please install vim, git, curl, wget, tmux, fzf manually."
        exit 1
    fi
}

# Check if required packages are installed
check_and_install_packages() {
    local packages=("vim" "git" "curl" "wget" "tmux")
    local missing_packages=()
    
    for package in "${packages[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            missing_packages+=("$package")
        fi
    done
    
    if [ ${#missing_packages[@]} -gt 0 ]; then
        echo "🔧 Missing packages: ${missing_packages[*]}"
        install_packages
    else
        echo "✅ All required packages are already installed"
    fi
}

# --- 3. Shell Setup ---
# Check if zsh is installed, if not, install it
setup_zsh() {
    if ! command -v zsh &> /dev/null; then
        echo "📦 Installing zsh..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get install -y zsh
        elif command -v yum &> /dev/null; then
            sudo yum install -y zsh
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y zsh
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm zsh
        fi
    else
        echo "✅ zsh is already installed"
    fi
    
    # Change default shell to zsh if not already
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "🔄 Changing default shell to zsh..."
        chsh -s "$(which zsh)"
    fi
}

# --- 4. Oh My Zsh Installation ---
# Check if oh-my-zsh is installed, if not, install it quietly
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ oh-my-zsh is already installed"
fi

# --- 5. Oh My Zsh Plugins and Themes Installation ---
# Install powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "📦 Installing powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
else
    echo "✅ powerlevel10k theme is already installed"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo "📦 Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
else
    echo "✅ zsh-syntax-highlighting plugin is already installed"
fi

# Install zsh-autosuggestions plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "📦 Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
else
    echo "✅ zsh-autosuggestions plugin is already installed"
fi

# Install zsh-completions plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
    echo "📦 Installing zsh-completions plugin..."
    git clone https://github.com/zsh-users/zsh-completions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
else
    echo "✅ zsh-completions plugin is already installed"
fi

# --- 6. Vim Setup ---
# Install vim-plug
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "📦 Installing vim-plug..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo "✅ vim-plug is already installed"
fi

# Create necessary directories
mkdir -p "$HOME/.vim/plugged"
mkdir -p "$HOME/.vim/undodir"

# --- 7. Linking Files ---
# Create symbolic links from the repo to the home directory
echo "🔗 Creating symbolic links..."

# Shell configs
ln -sf "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"

# Tool configs
ln -sf "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# Ranger config
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/ranger" "$HOME/.config/ranger"

# Keyd config (system-level, requires sudo)
if command -v keyd &> /dev/null; then
    if [ -d "/etc/keyd" ]; then
        sudo ln -sf "$DOTFILES_DIR/keyd/default.conf" "/etc/keyd/default.conf"
        sudo keyd reload 2>/dev/null && echo "Keyd configuration reloaded" || echo "Keyd config linked (reload manually)"
    else
        echo "Warning: /etc/keyd directory not found"
    fi
else
    echo "Note: keyd not installed, skipping keyd configuration"
fi

# --- 8. Vim Plugin Installation ---
echo "📦 Installing vim plugins..."
# Install vim plugins non-interactively
vim -c "silent! PlugInstall" -c "qa" 2>/dev/null || echo "⚠️  Vim plugin installation may require manual intervention: run :PlugInstall in vim"

# --- 9. Additional Tools Setup ---
# Setup fd (fd-find) for fzf
if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
    echo "🔗 Creating fd symlink for fdfind..."
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# Setup bat for fzf preview
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
    echo "🔗 Creating bat symlink for batcat..."
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# --- 10. Final Setup ---
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. If vim plugins weren't installed automatically, run: vim +PlugInstall +qall"
echo "3. Configure powerlevel10k by running: p10k configure"
echo "4. Enjoy your new development environment! 🚀"
echo ""
echo "🔧 If you encounter any issues:"
echo "- Make sure all packages were installed correctly"
echo "- Check that your shell is set to zsh: echo \$SHELL"
echo "- Manually install vim plugins if needed: vim +PlugInstall +qall"
