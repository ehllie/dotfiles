{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
  concatAttrs = lib.foldAttrs (item: _: item) null;
  manyFiletypes = fileTypes: formatter: lib.genAttrs fileTypes (_: [ formatter ]);
in
{
  plugins.conform-nvim = {
    enable = true;
    lazyLoad.settings.event = "BufWritePre";
    autoInstall = {
      enable = true;
      enableWarnings = true;
    };
    settings = {
      format_after_save = ''
        function(bufnr)
          if vim.g.auto_format then
            return { async = true, bufnr = bufnr }
          end
        end
      '';

      formatters_by_ft = concatAttrs [
        {
          nix = [ "nixfmt" ];
          lua = [ "stylua" ];
          python = [
            "black"
            "isort"
          ];
          rust = [ "rustfmt" ];
          typst = [ "typstyle" ];
          gleam = [ "gleam" ];
          toml = [ "tombi" ];
          _ = [
            "trim_whitespace"
            "trim_newlines"
          ];
        }
        (manyFiletypes [
          "bash"
          "csh"
          "ksh"
          "sh"
          "zsh"
        ] "beautysh")
        (manyFiletypes [
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
          "vue"
          "css"
          "scss"
          "less"
          "html"
          "json"
          "jsonc"
          "yaml"
          "markdown"
          "markdown.mdx"
          "graphql"
          "handlebars"
          "svelte"
        ] "prettier")
        (manyFiletypes [
          "c"
          "cpp"
          "proto"
        ] "clang-format")
      ];

      formatters = {
        isort.prepend_args = [
          "--profile"
          "black"
        ];
        stylua.prepend_args = [
          "--indent-type"
          "spaces"
          "--indent-width"
          "2"
        ];
      };
    };
  };

  globals.auto_format = true;
  keymaps = [
    {
      mode = "n";
      key = "<leader>ls";
      action = mkRaw ''
        function()
          vim.g.auto_format = not vim.g.auto_format
          if vim.g.auto_format then
            vim.notify("Auto format on save: Enabled", "info")
          else
            vim.notify("Auto format on save: Disabled", "info")
          end
        end
      '';
      options.desc = "Toggle format on save";
    }

  ];
}
