{ lib, ... }:
{
  imports = [
    ./core/cmp.nix
    ./core/colorscheme.nix
    ./core/conform.nix
    ./core/lsp.nix
    ./core/lualine.nix
    ./core/options.nix
    ./core/telescope.nix
    ./core/treesitter.nix
    ./presets/bash.nix
    ./presets/nix.nix
  ];

  clipboard.providers.wl-copy.enable = lib.mkDefault true;
  viAlias = lib.mkDefault true;
  vimAlias = lib.mkDefault true;
}
