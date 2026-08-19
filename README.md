# nixvim

A minimal standalone [Nixvim](https://github.com/nix-community/nixvim) configuration,
built to be extended per project.

The default package contains an editor set up with language support for nix and bash.

```sh
nix run github:cfrenette/nixvim
```

## Use it in a project

`packages.<system>.default` is a wrapped `nvim` derivation that also carries
`.extendModules`. It takes the same arguments as Nixvim's, and returns another
such derivation — so extensions chain.

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:cfrenette/nixvim";
  };

  outputs =
    { nixpkgs, nixvim, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          (nixvim.packages.${system}.default.extendModules {
            modules = [ ./nvim.nix ];
          })
          pkgs.go
          pkgs.gopls
        ];
      };
    };
}
```

```nix
# nvim.nix
{
  plugins = {
    lsp.servers.gopls = {
      enable = true;
      package = null; # use gopls from the devShell
    };
    conform-nvim.settings.formatters_by_ft.go = [ "gofmt" ];
  };
}
```

`nix develop` now gives you an `nvim` that speaks Go, and only inside this
project.

## Presets

`presets` holds optional predefined language modules. Drop them into `modules` alongside
your own:

```nix
nixvim.packages.${system}.default.extendModules {
  modules = [ nixvim.presets.rust ./nvim.nix ];
}
```

| Preset | Server | Formatter | 
| --- | --- | --- | 
| `presets.rust` | `rust_analyzer` | `rustfmt` | 
| `presets.java` | `jdtls` | `google-java-format` | 

Presets ship editor config, not toolchains. `rustc`, `cargo`, `rustfmt`,
`jdtls` and `google-java-format` are expected on `PATH` from the project's
devShell, where their versions can track the project rather than this flake.
Bash and Nix are the exception — they are in the base config and fully
self-contained, since their tooling is small.

Extensions chain, so presets and project config compose freely:

```nix
(nixvim.packages.${system}.default.extendModules {
  modules = [ nixvim.presets.rust ];
}).extendModules {
  modules = [ { opts.colorcolumn = "100"; } ];
}
```

## What's in the base config

Completion (`cmp` + `luasnip`), LSP, formatting (`conform`), `telescope`,
`treesitter`, `lualine`, and the `gruvbox-material` colorscheme.

Bundled tooling: `bash-language-server`, `beautysh`, `nixd`, `nixfmt`,
`ripgrep`, `bat`, `git`, `wl-clipboard`.

### Keymaps

The leader key is left at Neovim's default, backslash. Set
`globals.mapleader` in your own module to change it.

| Key | Action |
| --- | --- |
| `K` | Hover |
| `gd` / `gD` | Definition / references |
| `gi` / `gt` | Implementation / type definition |
| `<M-CR>` | Code action |
| `<leader>r` | Rename |
| `<leader>j` / `<leader>k` | Next / previous diagnostic |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fh` | Help tags |
| `<leader>fd` | Diagnostics |
| `<C-Space>` | Trigger completion |
| `<C-CR>` / `<C-e>` | Confirm / dismiss completion |
| `<C-n>` / `<C-p>` | Next / previous completion item |
| `<C-d>` / `<C-u>` | Scroll docs |

`:LspLogClear` truncates the LSP log.

