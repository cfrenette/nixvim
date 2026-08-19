{ lib, pkgs, ... }:
{
  imports = [
    ../core/conform.nix
    ../core/lsp.nix
  ];

  extraPackages = [ pkgs.nixfmt ];

  autoCmd = [
    {
      event = "FileType";
      pattern = "nix";
      command = "setlocal shiftwidth=2";
    }
  ];

  plugins = {
    conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
    lsp.servers.nixd = {
      enable = lib.mkDefault true;
      settings.formatting.command = [ "nixfmt" ];
    };
  };
}
