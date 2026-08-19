{ lib, ... }:
{
  plugins.cmp = {
    enable = lib.mkDefault true;
    settings = {
      mapping = lib.mapAttrs (_: lib.mkDefault) {
        "<c-Space>" = "cmp.mapping.complete()";
        "<c-e>" = "cmp.mapping.close()";
        "<c-CR>" = "cmp.mapping.confirm({ select = true })";
        "<c-u>" = "cmp.mapping.scroll_docs(-4)";
        "<c-d>" = "cmp.mapping.scroll_docs(4)";
        "<c-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })";
        "<c-n>" = "cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })";
      };
      # Left undefaulted: list options concatenate, so extra sources can be added
      # without restating these. Note added sources are ordered first.
      sources = [
        {
          name = "nvim_lsp";
        }
        {
          name = "luasnip";
        }
        {
          name = "path";
        }
      ];
      snippet.expand = lib.mkDefault ''
        function(args)
            require('luasnip').lsp_expand(args.body)
        end
      '';
    };
  };
}
