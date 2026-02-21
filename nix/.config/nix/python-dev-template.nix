# Reusable Python development environment template
# Usage: nix-shell $XDG_CONFIG_HOME/nix/python-dev-template.nix --argstr pythonVersion "311"
{ pkgs ? import <nixpkgs> {}
, pythonVersion ? "311"  # Options: "39", "310", "311", "312"
, extraPackages ? []     # Additional Python packages
}:

let
  # Select Python version
  python = pkgs."python${pythonVersion}";

  # Common Python packages for data science and AI/ML
  pythonEnv = python.withPackages (ps: with ps; [
    # Core tools
    pip
    setuptools
    wheel
    virtualenv

    # Development tools
    ipython
    jupyter
    black
    pylint
    pytest
    mypy

    # Data science basics
    numpy
    pandas
    matplotlib
    seaborn

    # Scientific computing
    scipy
    scikit-learn

    # Additional packages passed as argument
  ] ++ extraPackages);

in pkgs.mkShell {
  buildInputs = with pkgs; [
    pythonEnv

    # Build dependencies
    gcc
    stdenv.cc.cc.lib
    zlib

    # Optional: GPU support (uncomment if needed)
    # cudaPackages.cudatoolkit
  ];

  shellHook = ''
    # Set up Python environment
    export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
    export PYTHONPATH="$PWD:$PYTHONPATH"

    echo "Python ${pythonVersion} development environment loaded"
    echo "Python: $(which python)"
    echo "Version: $(python --version)"

    # Create/activate local venv if needed (optional)
    if [ ! -d .venv ]; then
      echo "Creating .venv..."
      python -m venv .venv
    fi

    # Uncomment to auto-activate venv
    # source .venv/bin/activate
  '';
}
