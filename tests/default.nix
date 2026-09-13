{
  mkNixvim,
  nixvimLib,
  presets,
}:
let
  # Launch headless and fail on any runtime error.
  smoke = name: nvim: nixvimLib.check.mkTestDerivationFromNvim { inherit name nvim; };

  base = mkNixvim [ ];

  extend = nvim: modules: nvim.extendModules { inherit modules; };
in
{
  base = smoke "base" base;

  preset-rust = smoke "preset-rust" (extend base [ presets.rust ]);
  preset-java = smoke "preset-java" (extend base [ presets.java ]);

  presets-chained = smoke "presets-chained" (extend (extend base [ presets.rust ]) [ presets.java ]);

}
