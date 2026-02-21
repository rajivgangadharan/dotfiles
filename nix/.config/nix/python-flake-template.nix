# Modern Nix Flake template for Python projects
# Copy this to your project root as flake.nix and customize as needed
# Usage: nix develop
{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Choose Python version (python39, python310, python311, python312)
        python = pkgs.python311;

        # Define your Python environment with packages
        pythonEnv = python.withPackages (ps: with ps; [
          # Core development tools
          pip
          setuptools
          wheel

          # Development tools
          ipython
          jupyter
          black
          pylint
          pytest
          pytest-cov
          mypy

          # Data science and ML (customize as needed)
          numpy
          pandas
          matplotlib
          seaborn
          scipy
          scikit-learn

          # Web frameworks (uncomment if needed)
          # flask
          # fastapi
          # uvicorn

          # AI/ML libraries (uncomment if needed)
          # torch
          # tensorflow
          # transformers

          # Add your project-specific packages here
        ]);

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv

            # System dependencies
            pkgs.gcc
            pkgs.stdenv.cc.cc.lib
            pkgs.zlib

            # Additional tools
            pkgs.git
            pkgs.curl

            # Uncomment for GPU support
            # pkgs.cudaPackages.cudatoolkit
          ];

          shellHook = ''
            # Set library path
            export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"

            # Set Python path to include current directory
            export PYTHONPATH="$PWD:$PYTHONPATH"

            # Display environment info
            echo "========================================"
            echo "Python Development Environment"
            echo "========================================"
            echo "Python: $(which python)"
            echo "Version: $(python --version)"
            echo ""
            echo "Use 'python -m pip install -r requirements.txt' to install additional packages"
            echo "Or use 'python -m venv .venv' to create a virtual environment"
            echo "========================================"
          '';
        };

        # Optionally define packages
        packages.default = pythonEnv;
      }
    );
}
