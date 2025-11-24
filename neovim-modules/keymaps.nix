{ lib, ... }:
let
  inherit (builtins) concatMap elemAt;
  inherit (lib.nixvim) mkRaw;

  mkKeymaps = concatMap (
    group:
    let
      mode = elemAt group 0;
      keymaps = elemAt group 1;
    in
    map (keymap: keymap // { inherit mode; }) keymaps
  );
in
{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };
  plugins = {
    which-key.enable = true;
  };
  keymaps = mkKeymaps [
    [
      "n"
      [
        {
          key = "<leader><leader>";
          action = "<cmd>w<cr>";
          options.desc = "Save file";
        }
        {
          key = "<leader>qq";
          action = "<cmd>confirm qa<cr>";
          options.desc = "Quit all";
        }
        {
          key = "<c-q>";
          action = "<c-w>q";
          options.desc = "Close window";
        }
        {
          key = "<c-down>";
          action = "<cmd>resize -2<cr>";
          options.desc = "Shrink window vertical";

        }
        {
          key = "<c-left>";
          action = "<cmd>vertical resize -2<cr>";
          options.desc = "Shrink window horizontal";
        }
        {
          key = "<c-right>";
          action = "<cmd>vertical resize +2<CR>";
          options.desc = "Grow window horizontal";
        }
        {
          key = "<c-up>";
          action = "<cmd>resize +2<CR>";
          options.desc = "Grow window vertical";
        }
        {
          key = "j";
          action = "gj";
          options.desc = "Move down by display line";
        }
        {
          key = "k";
          action = "gk";
          options.desc = "Move up by display line";
        }
        {
          key = "<c-h>";
          action = "<c-w>h";
          options.desc = "Move to left window";
        }
        {
          key = "<c-j>";
          action = "<c-w>j";
          options.desc = "Move to bottom window";
        }
        {
          key = "<c-k>";
          action = "<c-w>k";
          options.desc = "Move to top window";
        }
        {
          key = "<c-l>";
          action = "<c-w>l";
          options.desc = "Move to right window";
        }
        {
          key = "<leader>h";
          action = "<cmd>nohlsearch<cr>";
          options.desc = "Clear search highlighting";
        }
        {
          key = "<c-w>f";
          options.desc = "Close all floating windows";
          action = mkRaw ''
            function()
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local config = vim.api.nvim_win_get_config(win)
                if config.relative ~= "" then
                  vim.api.nvim_win_close(win, false)
                end
              end
            end
          '';
        }
      ]
    ]
    [
      "i"
      [
        {
          key = "jk";
          action = "<esc>";
          options.desc = "Exit insert mode";
        }
        {
          key = "<c-s>";
          action = "<cmd>w<cr>";
          options.desc = "Save file";
        }
      ]
    ]
    [
      "v"
      [
        {
          key = "<";
          action = "<gv";
          options.desc = "Indent left";
        }
        {
          key = ">";
          action = ">gv";
          options.desc = "Indent right";
        }
      ]

    ]
  ];
}
