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
setopt SHARE_HISTORY             # Share history between sessions
setopt APPEND_HISTORY            # Append to history file
setopt INC_APPEND_HISTORY        # Add commands immediately

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
    terraform
    rust
    golang
    python
    pip
    poetry
    npm
    node
    nvm
    yarn
    colored-man-pages
    command-not-found
    extract
    z
    sudo
    copypath
    copyfile
    copybuffer
    dirhistory
)

# Load Oh-My-Zsh
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
add_to_path "$HOME/.bun/bin"

# Anaconda path (added at end to not override system python)
if [[ -d "$HOME/anaconda3/bin" ]]; then
    export PATH="$PATH:$HOME/anaconda3/bin"
fi

# ====================
# Tool Configurations
# ====================

# Rust/Cargo
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun
export BUN_INSTALL="$HOME/.bun"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Conda initialization
if [[ -f "$HOME/anaconda3/bin/conda" ]]; then
    __conda_setup="$('$HOME/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
            source "$HOME/anaconda3/etc/profile.d/conda.sh"
        fi
    fi
    unset __conda_setup
fi

# Micromamba initialization
export MAMBA_EXE="$HOME/.local/bin/micromamba"
export MAMBA_ROOT_PREFIX="$HOME/micromamba"
if [[ -x "$MAMBA_EXE" ]]; then
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        alias micromamba="$MAMBA_EXE"
    fi
    unset __mamba_setup
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

# Project shortcuts with environment activation
alias smarttalk="cd ~/Code/smarttalk && [[ -f .venv/bin/activate ]] && source .venv/bin/activate"
alias clipart="cd ~/Code/biz/clipart/ && [[ -f .venv/bin/activate ]] && source .venv/bin/activate"

# Micromamba environment shortcuts
alias allm='micromamba activate agentic_llm_venv && cd ~/Code/langgraph-learn/'
alias hfac='micromamba activate agentic_llm_venv && cd ~/Code/huggingface-agents-course/'
alias ai='micromamba activate ai_venv && cd ~/Code/ai/'
alias ml='micromamba activate ai_venv && cd ~/Code/ml/'
alias rag='micromamba activate ai_venv && cd ~/Code/rag-coding-exercise'

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

# Completion settings
fpath+=~/.zfunc
autoload -Uz compinit
# Only regenerate compinit cache once a day for faster startup
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

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
# Key Bindings
# ====================

# Use vim keybindings (comment out if you prefer emacs mode)
# bindkey -v

# Useful keybindings for history search
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
# Performance Optimizations
# ====================

# Lazy load nvm to improve startup time
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # Only load nvm when actually needed
    alias nvm='unalias nvm && source "$NVM_DIR/nvm.sh" && nvm'
    alias npm='unalias npm && source "$NVM_DIR/nvm.sh" && npm'
    alias node='unalias node && source "$NVM_DIR/nvm.sh" && node'
fi
