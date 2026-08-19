{ lib, ... }:
{
  plugins.lsp = {
    enable = lib.mkDefault true;
    inlayHints = lib.mkDefault false;
    keymaps = {
      diagnostic = lib.mapAttrs (_: lib.mkDefault) {
        "<leader>j" = "goto_next";
        "<leader>k" = "goto_prev";
      };
      lspBuf = lib.mapAttrs (_: lib.mkDefault) {
        "K" = "hover";
        "gd" = "definition";
        "gD" = "references";
        "gi" = "implementation";
        "gt" = "type_definition";
        "<M-CR>" = "code_action";
        "<leader>r" = "rename";
      };
    };

    # Left undefaulted: `postConfig` is a lines option, so further definitions
    # are appended rather than replacing this one.
    postConfig = ''
        vim.api.nvim_create_user_command("LspLogClear", function()
      	  local lsplogpath = vim.fn.stdpath("state") .. "/lsp.log"
      	  print(lsplogpath)
      	  if io.close(io.open(lsplogpath, "w+b")) == false then vim.notify("Clearing LSP Log failed", vim.log.levels.WARN) end
        end, { nargs = 0 })
    '';
  };
}
