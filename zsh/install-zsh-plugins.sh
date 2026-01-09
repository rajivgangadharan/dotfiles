#!/bin/bash
# Script to install recommended Zsh plugins for Oh-My-Zsh

set -e

echo "Installing Zsh plugins..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo -e "${BLUE}Installing zsh-autosuggestions...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    echo -e "${GREEN}✓ zsh-autosuggestions installed${NC}"
else
    echo -e "${GREEN}✓ zsh-autosuggestions already installed${NC}"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo -e "${BLUE}Installing zsh-syntax-highlighting...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    echo -e "${GREEN}✓ zsh-syntax-highlighting installed${NC}"
else
    echo -e "${GREEN}✓ zsh-syntax-highlighting already installed${NC}"
fi

# Install zsh-completions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    echo -e "${BLUE}Installing zsh-completions...${NC}"
    git clone https://github.com/zsh-users/zsh-completions \
        "$ZSH_CUSTOM/plugins/zsh-completions"
    echo -e "${GREEN}✓ zsh-completions installed${NC}"
else
    echo -e "${GREEN}✓ zsh-completions already installed${NC}"
fi

echo ""
echo -e "${GREEN}All plugins installed successfully!${NC}"
echo ""
echo "To enable these plugins, add them to your plugins array in ~/.zshrc:"
echo "plugins=(... zsh-autosuggestions zsh-syntax-highlighting zsh-completions)"
echo ""
echo "Then run: source ~/.zshrc"
