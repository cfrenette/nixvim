{ lib, ... }:
{
  # Mode is already shown in lualine
  opts.showmode = lib.mkDefault false;
  plugins.lualine = {
    enable = lib.mkDefault true;
    settings = {
      options = {
        component_separators = lib.mapAttrs (_: lib.mkDefault) {
          left = "";
          right = "";
        };
        icons_enabled = lib.mkDefault false;
        section_separators = lib.mapAttrs (_: lib.mkDefault) {
          left = "";
          right = "";
        };
      };
    };
  };
}
