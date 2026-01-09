#!/bin/bash
# Install tmux plugins via TPM

set -e

echo "Installing Tmux plugins..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

TPM_DIR="$HOME/.tmux/plugins/tpm"

# Check if TPM is already installed
if [ -d "$TPM_DIR" ]; then
    echo -e "${GREEN}✓ TPM already installed${NC}"
else
    echo -e "${BLUE}Installing TPM...${NC}"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo -e "${GREEN}✓ TPM installed${NC}"
fi

# Check if tmux is running
if ! tmux info &> /dev/null; then
    echo -e "${BLUE}Starting tmux server...${NC}"
    tmux start-server
fi

# Install plugins
echo -e "${BLUE}Installing plugins...${NC}"
"$TPM_DIR/bin/install_plugins"

echo ""
echo -e "${GREEN}All plugins installed successfully!${NC}"
echo ""
echo "To use the new configuration:"
echo "1. If tmux is running: press 'Ctrl-b' then 'R' to reload"
echo "2. Or restart tmux: exit all sessions and start a new one"
echo ""
echo "Useful commands:"
echo "  prefix + I        - Install new plugins"
echo "  prefix + U        - Update plugins"
echo "  prefix + alt + u  - Uninstall plugins not in config"
