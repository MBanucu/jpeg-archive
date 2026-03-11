{
  description = "Dev shell for JPEG Archive";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.gcc
            pkgs.gnumake pkgs.makeWrapper
            pkgs.nasm
            pkgs.autoconf
            pkgs.pkg-config
            pkgs.libtool
            pkgs.mozjpeg
            pkgs.imagemagick
            pkgs.git
            pkgs.bash
          ];
          shellHook = ''
            echo "JPEG Archive dev shell. All build/test tools available."
          '';
        };
      }
    );
}
