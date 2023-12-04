{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    crystal
    lucky-cli
    overmind
    nodejs
    openssl
    pkg-config
    shards
    yarn
    crystal2nix
    pcre
  ];
}
