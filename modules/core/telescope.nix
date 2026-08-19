{ lib, pkgs, ... }:
let
  mkKeymap = action: desc: {
    action = lib.mkDefault action;
    options.desc = lib.mkDefault desc;
  };
in
{
  extraPackages = [ pkgs.ripgrep ];

  plugins.web-devicons.enable = lib.mkDefault true;
  plugins.telescope = {
    enable = lib.mkDefault true;
    keymaps = {
      "<leader>ff" = mkKeymap "find_files" "[F]ind [F]iles";
      "<leader>fg" = mkKeymap "live_grep" "[F]ind [G]rep";
      "<leader>fh" = mkKeymap "help_tags" "[F]ind [H]elp Tags";
      "<leader>fd" = mkKeymap "diagnostics" "[F]ind [D]iagnostics";
    };
  };
}
