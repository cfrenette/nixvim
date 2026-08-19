{ lib, ... }:
{
  imports = [
    ../core/conform.nix
    ../core/lsp.nix
  ];

  autoCmd = [
    {
      event = "FileType";
      pattern = "java";
      command = "setlocal shiftwidth=2";
    }
  ];

  plugins = {
    conform-nvim.settings.formatters_by_ft.java = [ "google-java-format" ];
    lsp.servers.jdtls = {
      enable = lib.mkDefault true;
      package = lib.mkDefault null;
    };
  };
}
