{ lib, extraLib, ... }:
let
  inherit (lib.nixvim) mkRaw;
  inherit (extraLib.nixvim) lazyMapping;
in
{
  plugins = {
    comment = {
      enable = true;
      settings = {
        toggler = {
          line = "<leader>cc";
          block = "<leader>bc";
        };
        opleader = {
          line = "<leader>c";
          block = "<leader>b";
        };
        extra = {
          above = "<leader>cO";
          below = "<leader>co";
          eol = "<leader>cA";
        };

      };
    };
    nvim-autopairs = {
      enable = true;
      settings.check_ts = true;
    };
    oil.enable = true;
    flash = {
      enable = true;
      lazyLoad.settings.keys = map lazyMapping [
        [
          "<leader>w"
          (mkRaw ''
            function()
              require("flash").jump()
            end
          '')
          {
            mode = [
              "n"
              "x"
              "o"
            ];
            desc = "Flash search";
          }
        ]
        [
          "<leader>W"
          (mkRaw ''
            function()
              require("flash").treesitter()
            end
          '')
          {
            mode = [
              "n"
              "x"
              "o"
            ];
            desc = "Flash treesitter";
          }
        ]
      ];
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>E";
      action = mkRaw ''
        function()
          require('oil').open()
        end
      '';
      options.desc = "Open Oil on parent directory";
    }
    {
      mode = "n";
      key = "<leader>e";
      action = mkRaw ''
        function()
          require('oil').open(vim.fn.getcwd())
        end
      '';
      options.desc = "Open Oil on CWD";
    }
  ];
}
