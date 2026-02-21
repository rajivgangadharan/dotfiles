# Nix-based Python Development Setup

This directory contains templates and tools for managing Python development environments with Nix.

## Quick Start

### New Project
```bash
# Initialize a new Python project with Nix
nix-init-python my-project
cd my-project
nix develop
```

### Existing Project
```bash
cd your-project
cp $XDG_CONFIG_HOME/nix/python-flake-template.nix flake.nix
# Edit flake.nix to customize packages
nix develop
```

### Quick Python Shell (No Project Setup)
```bash
# Python 3.11 (default)
pydev

# Specific Python version
py39    # Python 3.9
py310   # Python 3.10
py311   # Python 3.11
py312   # Python 3.12
```

## Available Files

### `python-dev-template.nix`
Traditional nix-shell template for quick Python environments.
- Works without git/flakes
- Good for quick experiments
- Use with `nix-shell` command

### `python-flake-template.nix`
Modern Nix Flake template for reproducible project environments.
- Reproducible and version-locked
- Better for long-term projects
- Use with `nix develop` command

### `init-python-project.sh`
Helper script to initialize a new Python project with Nix.

## Common Workflows

### 1. Start a New AI/ML Project
```bash
mkdir my-ml-project
cd my-ml-project
cp $XDG_CONFIG_HOME/nix/python-flake-template.nix flake.nix

# Edit flake.nix and uncomment ML libraries (torch, transformers, etc.)
$EDITOR flake.nix

# Enter environment
nix develop

# Install additional packages
python -m pip install langchain openai
```

### 2. Use with Existing requirements.txt
```bash
cd your-project
cp $XDG_CONFIG_HOME/nix/python-flake-template.nix flake.nix
nix develop
python -m pip install -r requirements.txt
```

### 3. Per-Project Environment with direnv (Recommended)
```bash
# Install direnv if not already installed
nix-env -iA nixpkgs.direnv

# In your project
echo "use flake" > .envrc
direnv allow

# Now the environment auto-loads when you cd into the directory!
```

## Customizing Your Environment

### Adding Python Packages (in flake.nix)
Edit the `pythonEnv` section:
```nix
pythonEnv = python.withPackages (ps: with ps; [
  numpy
  pandas
  # Add more packages from nixpkgs here
  requests
  beautifulsoup4
]);
```

### Adding System Dependencies
Edit the `buildInputs` section:
```nix
buildInputs = [
  pythonEnv
  pkgs.postgresql  # Database
  pkgs.redis       # Cache
  pkgs.git         # Version control
];
```

### Using Different Python Versions
Change the `python` variable:
```nix
# Python 3.9
python = pkgs.python39;

# Python 3.10
python = pkgs.python310;

# Python 3.11
python = pkgs.python311;

# Python 3.12
python = pkgs.python312;
```

## Finding Package Names

### Python Packages
```bash
# Search for a Python package
nix search nixpkgs python311Packages.numpy
nix search nixpkgs python311Packages.torch
```

### System Packages
```bash
# Search for system packages
nix search nixpkgs postgresql
nix search nixpkgs redis
```

## Advantages of Nix for Python Development

1. **Reproducibility**: Exact versions locked in flake.lock
2. **System Integration**: Native packages, no LD_LIBRARY_PATH hacks
3. **Declarative**: Environment defined in code
4. **Cacheable**: Binary cache for instant downloads
5. **Multi-language**: Mix Python with Node, Rust, etc. in same environment
6. **Garbage Collection**: Automatic cleanup of old environments

## Useful Commands

```bash
# Enter development environment
nix develop

# Update all dependencies
nix flake update

# Run command in environment without entering shell
nix develop --command python script.py

# Check what's in the environment
nix develop --command which python
nix develop --command python -c "import sys; print(sys.path)"

# Clean up old environments
nix-collect-garbage -d
```

## Troubleshooting

### "command not found: nix"
Make sure Nix is installed and sourced in your shell.

### "experimental feature 'flakes' not enabled"
Already enabled in `$XDG_CONFIG_HOME/nix/nix.conf`.

### "error: cannot find flake 'flake:nixpkgs'"
Run: `nix registry add nixpkgs github:NixOS/nixpkgs/nixos-unstable`

### Package not available in nixpkgs
Use pip inside the Nix shell:
```bash
nix develop
python -m pip install --user package-name
```

## Resources

- [Nix Pills](https://nixos.org/guides/nix-pills/) - Deep dive into Nix
- [nixpkgs Python docs](https://nixos.org/manual/nixpkgs/stable/#python) - Python in Nix
- [Awesome Nix](https://github.com/nix-community/awesome-nix) - Curated resources
