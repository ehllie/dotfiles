self: super: {
  neovim =
    self.neovim-unwrapped.overrideAttrs (old: {
      treesitter-parsers = { };
    });
}
