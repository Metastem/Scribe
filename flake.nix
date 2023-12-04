{
  description = "Scribe";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          devShell = import ./shell.nix { inherit pkgs; };
          packages.default = pkgs.callPackage ./default.nix { };
        })
    // {
      nixosModules.default = import ./module.nix self;
    };
}
