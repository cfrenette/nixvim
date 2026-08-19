{ lib, pkgs, ... }:
{
  imports = [
    ../core/conform.nix
    ../core/lsp.nix
  ];

  extraPackages = [ pkgs.beautysh ];

  plugins = {
    conform-nvim.settings.formatters_by_ft.bash = [ "beautysh" ];
    lsp.servers.bashls.enable = lib.mkDefault true;
  };
}
