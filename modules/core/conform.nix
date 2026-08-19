{ lib, ... }:
{
  plugins.conform-nvim = {
    enable = lib.mkDefault true;
    settings = {
      format_on_save = lib.mapAttrs (_: lib.mkDefault) {
        lsp_format = "fallback";
        timeout_ms = 500;
      };
    };
  };
}
