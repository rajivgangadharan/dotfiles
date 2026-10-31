{
  description = "OCaml development environment with LSP, dune, and utop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        ocamlPkgs = pkgs.ocamlPackages;
      in {
        devShells.default = pkgs.mkShell {
          name = "ocaml-dev";

          buildInputs = with pkgs; [
            # Compiler
            ocaml

            # Build system
            dune_3

            # Package management
            ocamlPkgs.findlib   # ocamlfind

            # Editor integration (LSP + formatter)
            ocamlPkgs.ocaml-lsp
            ocamlformat

            # REPL
            ocamlPkgs.utop

            # Development tools
            ocamlPkgs.merlin    # type inference, completion
            ocamlPkgs.odoc      # documentation generator
            ocamlPkgs.ounit2    # unit testing

            # Utilities
            git
            ripgrep
            fd
          ];

          shellHook = ''
            if [ -t 0 ]; then
              echo "OCaml development environment"
              echo "=============================="
              echo "OCaml:       $(ocaml --version)"
              echo "Dune:        $(dune --version)"
              echo "ocamllsp:    $(ocamllsp --version 2>/dev/null || echo 'available')"
              echo "ocamlformat: $(ocamlformat --version)"
              echo ""
              echo "Commands:"
              echo "  dune init project <name>  - Start a new project"
              echo "  dune build                - Build"
              echo "  dune test                 - Run tests"
              echo "  dune exec <target>        - Run an executable"
              echo "  utop                      - Interactive REPL"
              echo "  ocamlfind list            - List installed packages"
              echo ""
            fi
          '';
        };
      }
    );
}
