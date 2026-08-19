{ lib, ... }:
{
  colorschemes.gruvbox-material = {
    enable = lib.mkDefault true;
    settings = lib.mapAttrs (_: lib.mkDefault) {
      background = "hard";
      transparent_background = 1;
      foreground = "material";
      ui_contrast = "high";
      diagnostic_line_highlight = 1;
      diagnostic_virtual_text = "colored";
    };
  };
}
