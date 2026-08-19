{ lib, ... }:
{
  plugins.treesitter = {
    enable = lib.mkDefault true;
    highlight.enable = lib.mkDefault true;
    indent.enable = lib.mkDefault true;
  };
}
