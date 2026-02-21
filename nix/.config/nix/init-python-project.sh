#!/usr/bin/env bash
# Initialize a Nix-based Python project
# Usage: init-python-project.sh [project-directory]

set -e

PROJECT_DIR="${1:-.}"
TEMPLATE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nix"

echo "Initializing Nix Python project in: $PROJECT_DIR"

# Create project directory if it doesn't exist
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Check if flake.nix already exists
if [ -f "flake.nix" ]; then
    echo "⚠️  flake.nix already exists. Skipping."
else
    echo "Creating flake.nix..."
    cp "$TEMPLATE_DIR/python-flake-template.nix" flake.nix
    echo "✓ Created flake.nix"
fi

# Create .envrc for direnv integration (optional but recommended)
if command -v direnv &> /dev/null; then
    if [ ! -f ".envrc" ]; then
        echo "Creating .envrc for direnv..."
        echo "use flake" > .envrc
        echo "✓ Created .envrc (run 'direnv allow' to enable)"
    fi
else
    echo "ℹ️  direnv not found. Install it for automatic environment loading."
fi

# Create basic .gitignore for Python projects
if [ ! -f ".gitignore" ]; then
    echo "Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Nix
result
.direnv/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
venv/
.venv/
ENV/
env/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Testing
.pytest_cache/
.coverage
htmlcov/

# Jupyter
.ipynb_checkpoints/
EOF
    echo "✓ Created .gitignore"
fi

echo ""
echo "=========================================="
echo "✓ Python project initialized!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Edit flake.nix to add your Python dependencies"
echo "  2. Run 'nix develop' to enter the development environment"
echo "  3. (Optional) Run 'direnv allow' to auto-load environment"
echo ""
echo "Quick commands:"
echo "  nix develop          - Enter development shell"
echo "  nix flake update     - Update dependencies"
echo "  nix develop --command python  - Run Python directly"
echo ""
