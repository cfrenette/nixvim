{
  description = "A standalone, extensible Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    inputs@{ flake-parts, nixvim, ... }:
    let
      presets = {
        java = ./modules/presets/java.nix;
        rust = ./modules/presets/rust.nix;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake.presets = presets;

      perSystem =
        { lib, system, ... }:
        let
          # Present the eval result as a derivation whose `.extendModules`
          # yields another such derivation, so extensions chain.
          toPackage =
            eval:
            eval.config.build.package
            // {
              extendModules = args: toPackage (eval.extendModules args);
              extend = module: toPackage (eval.extendModules { modules = [ module ]; });
            };

          mkNixvim =
            extraModules:
            toPackage (
              nixvim.lib.evalNixvim {
                inherit system;
                modules = [ ./modules ] ++ extraModules;
              }
            );
        in
        {
          packages.default = mkNixvim [ ];

          # Skip tests for systems where there are no helpers
          checks = lib.optionalAttrs (nixvim.lib ? ${system}) (
            import ./tests {
              inherit mkNixvim presets;
              nixvimLib = nixvim.lib.${system};
            }
          );
        };
    };
}
