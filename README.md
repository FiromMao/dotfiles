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

# Review prerequisites and detected environment
./install.sh --check

# Preview the changes without modifying your system
./install.sh --dry-run

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
- `zsh` - Shell

### Optional Tools
- `fzf` - Fuzzy finder
- `fd-find` - Fast file finder
- `bat` - Cat with wings
- `autojump` - Directory jumper
- `ranger` - Terminal file manager
- `xclip` - Clipboard integration

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
- `.bashrc` - Bash configuration
- `.zshrc` - Zsh configuration
- `.vimrc` - Vim configuration
- `.gitconfig` - Git configuration
- `.tmux.conf` - Tmux configuration
- `.p10k.zsh` - Powerlevel10k configuration
- `~/.config/ranger` - Ranger configuration
- `~/.config/config.sh` - Optional local machine overrides

## 🔄 Post-Installation

1. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

   Note: your current shell session may still report Bash until you log out and log back in.

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

The test script checks required tools, installed plugins, symlinked config files,
and syntax validation for the Bash, Zsh, and Ranger config files when the required tools are available.

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

### Local Machine Overrides
```bash
mkdir -p ~/.config
cp ~/dotfiles/.config/config.sh ~/.config/config.sh
```

Edit `~/.config/config.sh` for machine-specific paths, environment variables, proxy settings, or local aliases.

## 🐛 Troubleshooting

### Permission Issues
If you get permission errors, make sure the script is executable and that your user can use `sudo`:
```bash
chmod +x install.sh
sudo -v
```

If `sudo -v` fails, use a user with sudo access or configure sudo for that account first.

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

If `getent passwd $USER` shows zsh but `echo $SHELL` still shows Bash, log out and log back in before testing again.

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
- Edit `bash/bashrc` for shared Bash settings
- Edit `zsh/zshrc` for shell settings
- Edit `vim/vimrc` for editor settings
- Edit `git/gitconfig` for git settings
- Edit `tmux/tmux.conf` for terminal multiplexer settings

For machine-specific settings, prefer `~/.config/config.sh` instead of hardcoding personal paths or local environment details into the shared dotfiles repository.

## 📝 Notes

- The script detects your Linux distribution and uses the appropriate package manager
- Most files are installed into your home directory, but the script also installs packages and may change your default shell to zsh
- The script creates symlinks to the dotfiles, so you can edit the configurations in this repository
- Some installations may require sudo privileges for system packages

## 🤝 Contributing

Feel free to submit issues and pull requests to improve this setup!

---

**Happy Coding! 🚀**
