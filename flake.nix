{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        #name = "bioemus";
        #driver-src = ./sw/target/kria;

        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python312;

        fxpmath = python.pkgs.buildPythonPackage rec {
          pname = "fxpmath";
          version = "0.4.9";

          src = python.pkgs.fetchPypi {
            inherit pname version;
            #hash = "sha256-AAAA";
            hash = "sha256-RWoK6JYMneK9epUYu8nWKiKtHzxRuMMeQACur0+Ji3U=";
          };

          build-system = [ python.pkgs.setuptools ];
          dependencies = [ python.pkgs.numpy ];

          doCheck = false;

        };

      in with pkgs; {
        devShells.default = mkShell {
          packages = [
            (python.withPackages (python-pkgs:
              with python-pkgs; [
                python
                numpy
                matplotlib
                pyqtgraph
                pyqt5
                jsbeautifier
                pyzmq
                ipykernel
                notebook
                jupyterlab
                fxpmath
                tqdm
                pandas
                python-lsp-server
                pylsp-rope
                pylsp-mypy
                black
              ]))
          ];
          shellHook = ''
            source ./sw/host/init.sh > /dev/null
          '';
        };
        /* packages.default = derivation {
             inherit system name src;
             builder = with pkgs; "${bash}/bin/bash";
             args = [ "-c" "echo foo > $out" ];
           };
        */
      });
}
