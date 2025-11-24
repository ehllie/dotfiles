{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw toRawKeys;
  inherit (lib) recursiveUpdate;
  enableDefaults =
    lsps:
    lib.genAttrs lsps (_: {
      enable = true;
      packageFallback = true;
    });
in
{
  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      keymaps = {
        extra = [
          {
            mode = "n";
            key = "<leader>ll";
            action = mkRaw "vim.lsp.codelens.run";
            options.desc = "Run codelens";
          }
          {
            mode = "n";
            key = "<leader>la";
            action = mkRaw "function() require('fastaction').code_action() end";
            options.desc = "Run code action";

          }
        ];
        diagnostic = {
          "<leader>ld" = "open_float";
          "<leader>lj" = "goto_next";
          "<leader>lk" = "goto_prev";
        };
        lspBuf = {
          K = "hover";
          gd = "definition";
          gD = "declaration";
          gr = "references";
          gi = "implementation";
          "<leader>lr" = "rename";
        };
      };
      servers =
        recursiveUpdate
          {

            nil_ls.settings.nix.flake = {
              autoArchive = true;
              autoEvalInputs = true;
            };
            lua_ls.settings.workspace.checkThirdParty = false;

          }
          (enableDefaults [
            "nil_ls"
            "lua_ls"
            "tinymist"
            "basedpyright"
          ]);
    };

    rustaceanvim = {
      enable = true;

      settings.default_settings.rust-analyzer = {
        cargo = {
          allFeatures = true;
          loadOutDirsFromCheck = true;
          runBuildScripts = true;
        };
        checkOnSave = {
          allFeatures = true;
          command = "clippy";
          extraArgs = [ "--no-deps" ];
        };
        procMacro = {
          enable = true;
          ignored = [
            "async-trait"
            "napi-derive"
            "async_recursion"
          ];
        };

      };

    };

    fastaction.enable = true;
    nvim-lightbulb = {
      enable = true;
      settings.autocmd.enabled = true;
    };

  };

  diagnostic.settings = {
    signs.text = toRawKeys {
      "vim.diagnostic.severity.ERROR" = "";
      "vim.diagnostic.severity.WARN" = "";
      "vim.diagnostic.severity.INFO" = "";
      "vim.diagnostic.severity.HINT" = "";
    };
    update_in_insert = true;
    severity_sort = true;
    float = {
      source = "if_many";
      border = "rounded";
      header = "";
      prefix = "";
    };
  };
}
