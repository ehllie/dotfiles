self: super: {
  neovim =
    super.neovim-unwrapped.override {treesitter-parsers = {};};
}
