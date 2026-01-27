# 🚀 Dotfiles Setup

This is a comprehensive dotfiles setup script that configures a complete development environment from scratch.

## 🎯 Features

- **Shell**: Zsh with Oh My Zsh
- **Theme**: Powerlevel10k
- **Plugins**: Syntax highlighting, autosuggestions, completions
- **Editor**: Vim with plugins and themes
- **Tools**: Git, Tmux, Fzf, Fd, Bat, Autojump
- **Cross-platform**: Supports Ubuntu/Debian, CentOS/RHEL, Fedora, Arch Linux

## 📦 Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the installation script
./install.sh

# Restart your terminal and enjoy!
```

## 🔧 What Gets Installed

### System Packages
- `vim` - Text editor
- `git` - Version control
- `curl` - HTTP client
- `wget` - File downloader
- `tmux` - Terminal multiplexer
- `fzf` - Fuzzy finder
- `fd-find` - Fast file finder
- `bat` - Cat with wings
- `autojump` - Directory jumper
- `zsh` - Shell

### Oh My Zsh Setup
- Oh My Zsh framework
- Powerlevel10k theme
- zsh-syntax-highlighting
- zsh-autosuggestions
- zsh-completions

### Vim Setup
- vim-plug plugin manager
- ALE (syntax checking)
- auto-pairs
- everforest theme
- NERDTree
- vim-airline
- vim-commentary
- vim-easy-align
- vim-fugitive
- ctrlp.vim

### Configuration Files
- `.zshrc` - Zsh configuration
- `.vimrc` - Vim configuration
- `.gitconfig` - Git configuration
- `.tmux.conf` - Tmux configuration
- `.p10k.zsh` - Powerlevel10k configuration

## 🔄 Post-Installation

1. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

2. **Configure Powerlevel10k**:
   ```bash
   p10k configure
   ```

3. **Install Vim plugins** (if not done automatically):
   ```bash
   vim +PlugInstall +qall
   ```

## 🧪 Test Installation

Run the test script to verify everything is installed correctly:
```bash
./test-install.sh
```

## 📁 Directory Structure

```
~/dotfiles/
├── install.sh          # Main installation script
├── test-install.sh     # Test script
├── README.md          # This file
├── bash/
│   └── bashrc         # Bash configuration
├── zsh/
│   ├── zshrc          # Zsh configuration
│   └── p10k.zsh       # Powerlevel10k configuration
├── vim/
│   └── vimrc          # Vim configuration
├── git/
│   └── gitconfig      # Git configuration
└── tmux/
    └── tmux.conf      # Tmux configuration
```

## 🛠️ Manual Installation

If the automatic installation fails, you can install components manually:

### Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Powerlevel10k
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
```

### Vim Plugins
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
```

## 🐛 Troubleshooting

### Permission Issues
If you get permission errors, make sure the script is executable:
```bash
chmod +x install.sh
```

### Plugin Installation Issues
If vim plugins don't install automatically:
1. Open vim: `vim`
2. Run: `:PlugInstall`
3. Exit vim: `:qa`

### Shell Not Changed
If your shell didn't change to zsh:
```bash
chsh -s $(which zsh)
```

### Fzf Issues
If fzf key-bindings don't work:
```bash
# Ubuntu/Debian
sudo apt install fzf

# Source the bindings
source /usr/share/doc/fzf/examples/key-bindings.zsh
```

## 🎨 Customization

Feel free to modify the configuration files in the respective directories:
- Edit `zsh/zshrc` for shell settings
- Edit `vim/vimrc` for editor settings
- Edit `git/gitconfig` for git settings
- Edit `tmux/tmux.conf` for terminal multiplexer settings

## 📝 Notes

- The script detects your Linux distribution and uses the appropriate package manager
- All installations are done in your home directory, no system-wide changes except package installation
- The script creates symlinks to the dotfiles, so you can edit the configurations in this repository
- Some installations may require sudo privileges for system packages

## 🤝 Contributing

Feel free to submit issues and pull requests to improve this setup!

---

**Happy Coding! 🚀**