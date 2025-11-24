{ ... }:
{
  imports = [
    ./completion.nix
    ./editing.nix
    ./folding.nix
    ./formatting.nix
    ./keymaps.nix
    ./lsp.nix
    ./lualine.nix
    ./telescope.nix
    ./treesitter.nix
    ./visual.nix
  ];

  plugins.lz-n.enable = true;
  clipboard.register = "unnamedplus";
  luaLoader.enable = true;
  opts = {
    cmdheight = 0;
    cursorline = true;
    expandtab = true;
    exrc = true;
    fileencoding = "utf-8";
    fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:";
    hlsearch = true;
    ignorecase = true;
    laststatus = 3;
    linebreak = true;
    mouse = "a";
    number = true;
    pumblend = 30;
    pumheight = 10;
    relativenumber = true;
    scrolloff = 8;
    shiftwidth = 2;
    showmode = false;
    sidescrolloff = 8;
    signcolumn = "yes";
    smartcase = true;
    spell = true;
    splitbelow = true;
    splitright = true;
    swapfile = false;
    tabstop = 2;
    termguicolors = true;
    undofile = true;
    updatetime = 600;
    winblend = 30;
    winborder = "rounded";
    wrap = false;
  };

  autoCmd = [
    {
      event = [
        "BufEnter"
        "BufWritePre"
      ];
      pattern = [ ".env*" ];
      command = "set noundofile";
    }
    {
      event = "CursorHold";
      command = "checktime";
    }
    {
      event = "FileType";
      pattern = [
        "markdown"
        "typst"
      ];
      command = "setlocal wrap";
    }
  ];
}
