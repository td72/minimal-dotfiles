#!/usr/bin/env bash

# Minimal dotfiles setup script
# Sets up XDG-compliant configuration for bash, fish, vim, and tmux

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# XDG Base Directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

echo -e "${GREEN}Setting up minimal dotfiles with XDG Base Directory compliance...${NC}"

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create XDG directories if they don't exist
echo "Creating XDG directories..."
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$XDG_CACHE_HOME"

# Bash setup
echo -e "\n${YELLOW}Setting up Bash...${NC}"
mkdir -p "$XDG_CONFIG_HOME/bash"
ln -sf "$DOTFILES_DIR/config/bash/bashrc" "$XDG_CONFIG_HOME/bash/bashrc"
ln -sf "$DOTFILES_DIR/config/bash/bash_profile" "$XDG_CONFIG_HOME/bash/bash_profile"

# Create symlinks in home directory for bash (required for bash to find XDG config)
ln -sf "$XDG_CONFIG_HOME/bash/bashrc" "$HOME/.bashrc"
ln -sf "$XDG_CONFIG_HOME/bash/bash_profile" "$HOME/.bash_profile"
echo "  ✓ Bash configuration linked"

# Fish setup
echo -e "\n${YELLOW}Setting up Fish...${NC}"
mkdir -p "$XDG_CONFIG_HOME/fish"
ln -sf "$DOTFILES_DIR/config/fish/config.fish" "$XDG_CONFIG_HOME/fish/config.fish"
echo "  ✓ Fish configuration linked"

# Vim setup
echo -e "\n${YELLOW}Setting up Vim...${NC}"
mkdir -p "$XDG_CONFIG_HOME/vim"
ln -sf "$DOTFILES_DIR/config/vim/vimrc" "$XDG_CONFIG_HOME/vim/vimrc"

# Create vim symlink for XDG support
if [ ! -f "$HOME/.vimrc" ]; then
    cat > "$HOME/.vimrc" << 'EOF'
" Minimal vimrc to redirect to XDG config
set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after
source $XDG_CONFIG_HOME/vim/vimrc
EOF
fi
echo "  ✓ Vim configuration linked"

# Tmux setup
echo -e "\n${YELLOW}Setting up Tmux...${NC}"
mkdir -p "$XDG_CONFIG_HOME/tmux"
ln -sf "$DOTFILES_DIR/config/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"

# Create tmux symlink for compatibility
ln -sf "$XDG_CONFIG_HOME/tmux/tmux.conf" "$HOME/.tmux.conf"
echo "  ✓ Tmux configuration linked"

# Create state directories
echo -e "\n${YELLOW}Creating application state directories...${NC}"
mkdir -p "$XDG_STATE_HOME/bash"
mkdir -p "$XDG_STATE_HOME/fish"
mkdir -p "$XDG_STATE_HOME/vim/"{backup,swap,undo,view}
echo "  ✓ State directories created"

echo -e "\n${GREEN}Setup complete!${NC}"
echo -e "\nConfiguration files are located in:"
echo "  • Bash:  $XDG_CONFIG_HOME/bash/"
echo "  • Fish:  $XDG_CONFIG_HOME/fish/"
echo "  • Vim:   $XDG_CONFIG_HOME/vim/"
echo "  • Tmux:  $XDG_CONFIG_HOME/tmux/"

echo -e "\n${YELLOW}To apply the configurations:${NC}"
echo "  • Bash: source ~/.bashrc"
echo "  • Fish: exec fish"
echo "  • Vim:  just restart vim"
echo "  • Tmux: tmux source ~/.tmux.conf"
