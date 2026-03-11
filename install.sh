#!/bin/bash

# --- 1. Environmental Setup ---
# Get the absolute path of this repository
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)
DRY_RUN=0
CHECK_ONLY=0

for arg in "$@"; do
    case "$arg" in
        --dry-run)
            DRY_RUN=1
            ;;
        --check)
            CHECK_ONLY=1
            ;;
        -h|--help)
            echo "Usage: ./install.sh [--check] [--dry-run]"
            echo "  --check    Run preflight checks without changing the system"
            echo "  --dry-run  Print the actions that would be taken"
            exit 0
            ;;
        *)
            echo "❌ Unknown option: $arg"
            exit 1
            ;;
    esac
done

if [ "$CHECK_ONLY" -eq 1 ]; then
    echo "🔎 Running installer preflight checks..."
elif [ "$DRY_RUN" -eq 1 ]; then
    echo "📝 Running installer dry-run..."
else
    echo "🚀 Setting up your environment..."
fi

run_cmd() {
    if [ "$CHECK_ONLY" -eq 1 ]; then
        return 0
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        echo "[dry-run] $*"
        return 0
    fi

    "$@"
}

print_check() {
    echo "[check] $1"
}

check_command() {
    local command_name="$1"

    if command -v "$command_name" &> /dev/null; then
        print_check "found command: $command_name"
        return 0
    else
        print_check "missing command: $command_name"
        return 1
    fi
}

check_path() {
    local path="$1"

    if [ -e "$path" ]; then
        print_check "found path: $path"
    else
        print_check "missing path: $path"
    fi
}

preflight_checks() {
    local required_commands=(git curl wget vim tmux zsh)
    local missing_commands=()

    echo "Checking required commands..."
    for command_name in "${required_commands[@]}"; do
        if ! check_command "$command_name"; then
            missing_commands+=("$command_name")
        fi
    done

    echo "Checking package manager availability..."
    if command -v apt-get &> /dev/null || command -v yum &> /dev/null || command -v dnf &> /dev/null || command -v pacman &> /dev/null; then
        print_check "supported package manager detected"
    else
        print_check "no supported package manager detected"
    fi

    echo "Checking config sources..."
    check_path "$DOTFILES_DIR/bash/bashrc"
    check_path "$DOTFILES_DIR/zsh/zshrc"
    check_path "$DOTFILES_DIR/zsh/p10k.zsh"
    check_path "$DOTFILES_DIR/git/gitconfig"
    check_path "$DOTFILES_DIR/vim/vimrc"
    check_path "$DOTFILES_DIR/tmux/tmux.conf"
    check_path "$DOTFILES_DIR/ranger"
    check_path "$DOTFILES_DIR/keyd/default.conf"

    echo "Checking optional local override..."
    if [ -f "$HOME/.config/config.sh" ]; then
        print_check "local override exists: $HOME/.config/config.sh"
    else
        print_check "local override not present: $HOME/.config/config.sh"
    fi

    if [ ${#missing_commands[@]} -gt 0 ]; then
        echo "⚠️  Missing commands detected: ${missing_commands[*]}"
        echo "   These are installable dependencies, not a fatal preflight error."
    else
        echo "✅ All required commands are already available"
    fi
}

install_ohmyzsh() {
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "[dry-run] sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended"
        return 0
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

link_config() {
    local source_path="$1"
    local target_path="$2"

    if [ -d "$target_path" ] && [ ! -L "$target_path" ]; then
        local backup_path="${target_path}.backup.$(date +%Y%m%d%H%M%S)"
        echo "📦 Backing up existing directory $target_path to $backup_path"
        run_cmd mv "$target_path" "$backup_path"
    fi

    run_cmd ln -sfn "$source_path" "$target_path"
}

# --- 2. System Package Installation ---
# Detect package manager and install dependencies
install_packages() {
    echo "📦 Installing system packages..."

    if command -v apt-get &> /dev/null; then
        # Ubuntu/Debian
        echo "Detected Ubuntu/Debian system"
        run_cmd sudo apt-get update
        run_cmd sudo apt-get install -y vim git curl wget tmux zsh build-essential

        optional_packages=(fzf fd-find bat autojump ranger xclip)
        for package in "${optional_packages[@]}"; do
            if ! run_cmd sudo apt-get install -y "$package"; then
                echo "⚠️  Optional package '$package' could not be installed automatically"
            fi
        done
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        echo "Detected CentOS/RHEL system"
        run_cmd sudo yum update -y
        run_cmd sudo yum install -y vim git curl wget tmux zsh gcc gcc-c++ make

        optional_packages=(fzf fd bat autojump ranger xclip)
        for package in "${optional_packages[@]}"; do
            if ! run_cmd sudo yum install -y "$package"; then
                echo "⚠️  Optional package '$package' could not be installed automatically"
            fi
        done
    elif command -v dnf &> /dev/null; then
        # Fedora
        echo "Detected Fedora system"
        run_cmd sudo dnf update -y
        run_cmd sudo dnf install -y vim git curl wget tmux zsh gcc gcc-c++ make

        optional_packages=(fzf fd-find fd bat autojump ranger xclip)
        for package in "${optional_packages[@]}"; do
            if ! run_cmd sudo dnf install -y "$package"; then
                echo "⚠️  Optional package '$package' could not be installed automatically"
            fi
        done
    elif command -v pacman &> /dev/null; then
        # Arch Linux
        echo "Detected Arch Linux system"
        run_cmd sudo pacman -Sy --noconfirm
        run_cmd sudo pacman -S --noconfirm vim git curl wget tmux zsh base-devel

        optional_packages=(fzf fd bat autojump ranger xclip)
        for package in "${optional_packages[@]}"; do
            if ! run_cmd sudo pacman -S --noconfirm "$package"; then
                echo "⚠️  Optional package '$package' could not be installed automatically"
            fi
        done
    else
        echo "❌ Unsupported package manager. Please install vim, git, curl, wget, tmux, and zsh manually."
        exit 1
    fi
}

# Check if required packages are installed
check_and_install_packages() {
    local packages=("vim" "git" "curl" "wget" "tmux" "zsh")
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
# Configure zsh as the default shell when available
setup_zsh() {
    if ! command -v zsh &> /dev/null; then
        if [ "$DRY_RUN" -eq 1 ]; then
            echo "[dry-run] zsh would be available after package installation"
            return 0
        fi

        echo "❌ zsh is still unavailable after dependency installation"
        exit 1
    fi

    echo "✅ zsh is available"

    # Change default shell to zsh if not already
    if command -v zsh &> /dev/null && [ "$SHELL" != "$(command -v zsh)" ] && command -v chsh &> /dev/null; then
        echo "🔄 Changing default shell to zsh..."
        run_cmd chsh -s "$(command -v zsh)" || echo "⚠️  Unable to change default shell automatically; run chsh manually"
    fi
}

if [ "$CHECK_ONLY" -eq 1 ]; then
    preflight_checks
    exit 0
fi

check_and_install_packages
setup_zsh

# --- 4. Oh My Zsh Installation ---
# Check if oh-my-zsh is installed, if not, install it quietly
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing oh-my-zsh..."
    install_ohmyzsh || {
        echo "❌ Failed to install oh-my-zsh"
        exit 1
    }
else
    echo "✅ oh-my-zsh is already installed"
fi

# --- 5. Oh My Zsh Plugins and Themes Installation ---
# Install powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "📦 Installing powerlevel10k theme..."
    run_cmd git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" || exit 1
else
    echo "✅ powerlevel10k theme is already installed"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo "📦 Installing zsh-syntax-highlighting plugin..."
    run_cmd git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" || exit 1
else
    echo "✅ zsh-syntax-highlighting plugin is already installed"
fi

# Install zsh-autosuggestions plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "📦 Installing zsh-autosuggestions plugin..."
    run_cmd git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" || exit 1
else
    echo "✅ zsh-autosuggestions plugin is already installed"
fi

# Install zsh-completions plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
    echo "📦 Installing zsh-completions plugin..."
    run_cmd git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" || exit 1
else
    echo "✅ zsh-completions plugin is already installed"
fi

# --- 6. Vim Setup ---
# Install vim-plug
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "📦 Installing vim-plug..."
    run_cmd curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || exit 1
else
    echo "✅ vim-plug is already installed"
fi

# Create necessary directories
run_cmd mkdir -p "$HOME/.vim/plugged"
run_cmd mkdir -p "$HOME/.vim/undodir"

# --- 7. Linking Files ---
# Create symbolic links from the repo to the home directory
echo "🔗 Creating symbolic links..."

# Shell configs
link_config "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
link_config "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
link_config "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"

# Tool configs
link_config "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
link_config "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"
link_config "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# Ranger config
run_cmd mkdir -p "$HOME/.config"
link_config "$DOTFILES_DIR/ranger" "$HOME/.config/ranger"

# Keyd config (system-level, requires sudo)
if command -v keyd &> /dev/null; then
    if [ -d "/etc/keyd" ]; then
        run_cmd sudo ln -sf "$DOTFILES_DIR/keyd/default.conf" "/etc/keyd/default.conf"
        run_cmd sudo keyd reload 2>/dev/null && echo "Keyd configuration reloaded" || echo "Keyd config linked (reload manually)"
    else
        echo "Warning: /etc/keyd directory not found"
    fi
else
    echo "Note: keyd not installed, skipping keyd configuration"
fi

# --- 8. Vim Plugin Installation ---
echo "📦 Installing vim plugins..."
# Install vim plugins non-interactively
run_cmd vim -c "silent! PlugInstall" -c "qa" 2>/dev/null || echo "⚠️  Vim plugin installation may require manual intervention: run :PlugInstall in vim"

# --- 9. Additional Tools Setup ---
# Setup fd (fd-find) for fzf
if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
    echo "🔗 Creating fd symlink for fdfind..."
    run_cmd mkdir -p "$HOME/.local/bin"
    run_cmd ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

# Setup bat for fzf preview
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
    echo "🔗 Creating bat symlink for batcat..."
    run_cmd mkdir -p "$HOME/.local/bin"
    run_cmd ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
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
