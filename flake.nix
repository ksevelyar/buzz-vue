{
  description = "buzz-vue";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShell = pkgs.mkShell {
        buildInputs = [
          pkgs.nodejs_20
        ];

        shellHook = ''
          export VITE_BACK=ws://buzz.lcl:4001
        '';
      };

      packages.default = pkgs.buildNpmPackage {
        name = "buzz-vue";

        buildInputs = with pkgs; [
          nodejs_20
        ];

        src = self;

        npmDepsHash = "sha256-WwqGHFiotjdUUpmnTDtUc9UAfEoDQgyvqyGcNhJFggI=";

        VITE_BACK = "wss://api.buzz.rusty-cluster.net";
        npmBuild = "npm run build";

        installPhase = ''
          mkdir $out
          cp -r dist/* $out/
        '';
      };
    });
}
