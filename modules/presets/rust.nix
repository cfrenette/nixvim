{ lib, ... }:
{
  imports = [
    ../core/conform.nix
    ../core/lsp.nix
  ];

  plugins = {
    conform-nvim.settings.formatters_by_ft.rust = [ "rustfmt" ];
    lsp.servers.rust_analyzer = {
      enable = lib.mkDefault true;
      # Use the more up-to-date versions from the project's devshell
      installRustc = lib.mkDefault false;
      installCargo = lib.mkDefault false;
    };
  };
}
