# ====================
# Oh-My-Zsh Configuration
# ====================

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration
# Disabled because we use Starship prompt (see bottom of file)
ZSH_THEME=""

# ====================
# Oh-My-Zsh Settings
# ====================

# Update behavior
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 13

# Performance optimizations
DISABLE_UNTRACKED_FILES_DIRTY="true"  # Faster git status on large repos

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS          # Don't record duplicate entries
setopt HIST_IGNORE_ALL_DUPS      # Delete old duplicate entries
setopt HIST_FIND_NO_DUPS         # Don't display duplicates when searching
setopt HIST_IGNORE_SPACE         # Don't record entries starting with space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicates to history file
setopt SHARE_HISTORY             # Share history between all sessions in real-time
setopt APPEND_HISTORY            # Append to history file

# ====================
# Oh-My-Zsh Plugins
# ====================

# Plugins to load
# Standard plugins: $ZSH/plugins/
# Custom plugins: $ZSH_CUSTOM/plugins/
plugins=(
    git
    docker
    docker-compose
    kubectl
    rust
    npm
    node
    colored-man-pages
    command-not-found
    extract
    sudo
    copypath
    copyfile
    copybuffer
    dirhistory
)

# Custom fpath must be before source oh-my-zsh.sh so compinit picks it up
fpath+=~/.zfunc

# Load Oh-My-Zsh (handles compinit internally)
source $ZSH/oh-my-zsh.sh

# ====================
# Environment Variables
# ====================

# Language and Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Editor configuration
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi
export VISUAL="$EDITOR"

# Architecture flags
export ARCHFLAGS="-arch $(uname -m)"

# ====================
# PATH Configuration
# ====================

# Function to add to PATH only if directory exists and not already in PATH
add_to_path() {
    if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# Add paths in reverse priority order (last added = highest priority)
add_to_path "/usr/local/bin"
add_to_path "/usr/local/go/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.cargo/bin"
add_to_path "$HOME/go/bin"
add_to_path "/opt/nvim-linux64/bin"
add_to_path "/opt/nvim-linux-x86_64/bin"
add_to_path "/opt/flutter/flutter/bin"
add_to_path "/opt/dev/flutter/bin"
add_to_path "/opt/android-studio/cmdline-tools/latest/bin"
add_to_path "/opt/atom"
add_to_path "$HOME/opt/terraform"
add_to_path "$HOME/.opencode/bin"
add_to_path "$HOME/.npm-global/bin"

# ====================
# Tool Configurations
# ====================

# Rust/Cargo
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# ====================
# API Keys & Secrets
# ====================

# GitHub Personal Access Token (only load if file exists)
if [[ -f "$HOME/keys/github.pat" ]]; then
    export GITHUB_PAT=$(cat "$HOME/keys/github.pat")
fi

# Digital Ocean PAT (set your token here if needed)
# export DO_PAT="your_token_here"

# ====================
# Aliases
# ====================

# Editor aliases
alias vi='nvim'
alias vim='nvim'
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"

# Kubernetes
alias kubectl="microk8s kubectl"
alias k="kubectl"

# Utility aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lAh'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git aliases (additional to oh-my-zsh git plugin)
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'

# ====================
# Custom Configurations
# ====================

# RSYNC exclude file
export RSYNC_EXCLUDE_FILES=/media/rajivg/ADATA/Work/exclude_from.txt

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Menu selection for completion
zstyle ':completion:*' menu select

# Color completion for files and directories
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ====================
# Zsh Enhancements
# ====================

# Catppuccin syntax highlighting (if available)
if [[ -f "$HOME/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh" ]]; then
    source "$HOME/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh"
fi

# Load zsh-syntax-highlighting if installed
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
if [[ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Load zsh-autosuggestions if installed
if [[ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Autosuggestion configuration
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ====================
# Starship Prompt
# ====================

# Initialize Starship (modern prompt)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ====================
# Zoxide (fast directory jumping)
# ====================

# Faster replacement for the OMZ 'z' plugin, written in Rust
# Install: cargo install zoxide  OR  nix profile install nixpkgs#zoxide
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# ====================
# Key Bindings
# ====================

# Use vim keybindings (comment out if you prefer emacs mode)
# bindkey -v

# History search (overridden by fzf below if installed)
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# Home/End keys
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Delete key
bindkey "^[[3~" delete-char

# ====================
# fzf Integration
# ====================

# Fuzzy history (CTRL-R), file picker (CTRL-T), cd (ALT-C)
# These override the basic ^R binding above when fzf is installed
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# ====================
# Local Configuration
# ====================

# Load generic environment variable files
for _env_file in "$HOME/.env" "$HOME/.env.local.home" "$HOME/.env.local.office"; do
    [[ -f "$_env_file" ]] && source "$_env_file"
done

unset _env_file

# Load machine-specific configuration
# Set ZSH_LOCAL_CONFIG environment variable to choose which config to load
# Default to .zshrc.local.home if not set
ZSH_LOCAL_CONFIG="${ZSH_LOCAL_CONFIG:-home}"
if [[ -f "${ZDOTDIR:-$HOME}/.zshrc.local.$ZSH_LOCAL_CONFIG" ]]; then
    source "${ZDOTDIR:-$HOME}/.zshrc.local.$ZSH_LOCAL_CONFIG"
fi

# ====================
# Hooks (must be last)
# ====================

eval "$(direnv hook zsh)"
