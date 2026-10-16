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
  dependencies.rust-analyzer.packageFallback = true;
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
            tailwindcss = {
              filetypes = [
                "rust"
                "html"
                "svelte"
                "vue"
                "css"
                "scss"
                "less"
                "javascript"
                "javascriptreact"
                "typescript"
                "typescriptreact"
              ];
              extraOptions.settings = {
                tailwindCSS = {
                  includeLanguages = {
                    rust = "html";
                    "*.rs" = "html";
                  };
                  experimental = {
                    classRegex = [
                      "class:([^=]*)="
                      ''class=\\("([^"]*)"''
                    ];
                  };
                };
              };
            };

          }
          (enableDefaults [
            "basedpyright"
            "bashls"
            "eslint"
            "gleam"
            "lua_ls"
            "nil_ls"
            "protols"
            "svelte"
            "tailwindcss"
            "tinymist"
            "tombi"
            "ts_ls"
            "wgsl_analyzer"
          ]);
    };

    rustaceanvim = {
      enable = true;
      settings = {
        dap.autoload_configuration = true;
        server = {
          standalone = false;

          default_settings.rust-analyzer = {
            cargo = {
              allFeatures = true;
              loadOutDirsFromCheck = true;
              runBuildScripts = true;
            };

            files.excludeDirs = [
              ".devenv"
            ];

            check = {
              command = "clippy";
              extraArgs = [ "--no-deps" ];
            };
            checkOnSave = true;

            procMacro = {
              enable = true;
              # ignored = listToUnkeyedAttrs [
              #   "async-trait"
              #   "napi-derive"
              #   "async_recursion"
              # ];
            };

          };
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
