{
  description = "A standalone, extensible Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    inputs@{ flake-parts, nixvim, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # Optional add-ons, composed via `packages.default.extendModules`.
      # The bash and nix presets are already imported by the base config.
      flake.presets = {
        java = ./modules/presets/java.nix;
        rust = ./modules/presets/rust.nix;
      };

      perSystem =
        { system, ... }:
        {
          packages.default =
            let
              # Present the eval result as a derivation whose `.extendModules`
              # yields another such derivation, so extensions chain.
              toPackage =
                eval:
                eval.config.build.package
                // {
                  extendModules = args: toPackage (eval.extendModules args);
                };
            in
            toPackage (nixvim.lib.evalNixvim {
              inherit system;
              modules = [ ./modules ];
            });
        };
    };
}
