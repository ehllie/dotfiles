{ extraLib, lib, ... }:
let
  inherit (extraLib.nixvim) lazyMapping;
  inherit (lib.nixvim) mkRaw;
  requireFn =
    module: rhs:
    mkRaw ''
      function()
        return require("${module}").${rhs}
      end
    '';
in
{
  plugins = {
    dap = {
      enable = true;
      signs.dapBreakpoint = {
        text = "";
        texthl = "DiagnosticSignError";
      };
      lazyLoad.settings.keys = map lazyMapping [
        [
          "<leader>dO"
          (requireFn "dap" "step_out()")
          { desc = "Step out"; }
        ]
        [
          "<leader>db"
          (requireFn "dap" "toggle_breakpoint()")
          { desc = "Toggle breakpoint"; }
        ]
        [
          "<leader>dc"
          (requireFn "dap" "continue()")
          { desc = "Continue"; }
        ]
        [
          "<leader>di"
          (requireFn "dap" "step_into()")
          { desc = "Step into"; }
        ]
        [
          "<leader>dj"
          (requireFn "dap.ext.vscode" "load_launchjs()")
          { desc = "Load launch.js configurations"; }
        ]
        [
          "<leader>dl"
          (requireFn "dap" "run_last()")
          { desc = "Run last"; }
        ]
        [
          "<leader>do"
          (requireFn "dap" "step_over()")
          { desc = "Step over"; }
        ]
        [
          "<leader>dr"
          (requireFn "dap" "repl.toggle()")
          { desc = "Toggle repl"; }
        ]
      ];
    };
    dap-ui = {
      enable = true;
      lazyLoad.settings = {
        keys = map lazyMapping [
          [
            "<leader>de"
            (requireFn "dapui" "eval()")
            { desc = "Evaluate expression"; }
          ]
          [
            "<leader>du"
            (requireFn "dapui" "toggle()")
            { desc = "Toggle DAP UI"; }
          ]
        ];
        before = mkRaw "function() require('lz.n').trigger_load('nvim-dap') end";

      };
      settings = {
        icons = {
          expanded = "▾";
          collapsed = "▸";
        };
        mappings = {
          expand = [
            "h"
            "l"
            "<2-LeftMouse>"
          ];
          open = "o";
          remove = "d";
          edit = "c";
          repl = "r";
          toggle = "t";
        };
        expand_lines = true;
        layouts = [
          {
            elements = [
              {
                id = "scopes";
                size = 4; # Can be float or integer > 1
              }
              {
                id = "stacks";
                size = 3;
              }
              {
                id = "breakpoints";
                size = 3;
              }
            ];
            size = 40;
            position = "right"; # Can be "left", "right", "top", "bottom"
          }
          {
            elements = [
              {
                id = "watches";
                size = 4;
              }
              {
                id = "console";
                size = 6;
              }
            ];
            size = 2;
            position = "bottom";
          }
        ];
        floating = {
          max_height = null;
          max_width = null;
          border = "rounded";
          mappings = {
            close = [
              "q"
              "<Esc>"
            ];
          };
        };
      };

    };
  };
}
